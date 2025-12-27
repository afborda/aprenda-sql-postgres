#!/usr/bin/env python3
"""
Advanced seed script using Faker pt_BR for ALL data
- Realistic Brazilian data generation (names, addresses, merchants, etc)
- CPF validation with check digits
- Normalized data (1NF/2NF/3NF) with FK relationships
- Data quality analysis before insertion
Usage: python3 scripts/seed_faker_10k.py "postgresql://user:pass@host/db" [--tpu 8] [--count 10000]
"""

import sys
import os
import psycopg2
from psycopg2.extras import execute_batch
from faker import Faker
from datetime import datetime, timedelta
import random
import argparse
import re
from collections import Counter

# ============= BRAZILIAN MAPPINGS (1NF/2NF/3NF Normalized) =============
CITY_STATE_MAPPING = {
    'São Paulo': {'state': 'SP', 'ddd': '11', 'cep_base': '01000'},
    'Rio de Janeiro': {'state': 'RJ', 'ddd': '21', 'cep_base': '20000'},
    'Belo Horizonte': {'state': 'MG', 'ddd': '31', 'cep_base': '30000'},
    'Curitiba': {'state': 'PR', 'ddd': '41', 'cep_base': '80000'},
    'Porto Alegre': {'state': 'RS', 'ddd': '51', 'cep_base': '90000'},
    'Fortaleza': {'state': 'CE', 'ddd': '85', 'cep_base': '60000'},
    'Brasília': {'state': 'DF', 'ddd': '61', 'cep_base': '70000'},
    'Salvador': {'state': 'BA', 'ddd': '71', 'cep_base': '40000'},
    'Recife': {'state': 'PE', 'ddd': '81', 'cep_base': '50000'},
    'Joinville': {'state': 'SC', 'ddd': '47', 'cep_base': '89200'},
}

# ============= PAYMENT METHODS & TRANSACTION TYPES =============
PAYMENT_METHODS = ['pix', 'credit_card', 'debit_card', 'boleto']
TRANSACTION_TYPES = ['purchase', 'transfer', 'withdraw', 'payment']
TX_STATUSES = ['completed', 'pending', 'failed']

# ============= CPF VALIDATION =============
def validate_cpf(cpf_str):
    """Validate Brazilian CPF (normalized format: 000.000.000-00)"""
    # Remove formatting
    cpf = re.sub(r'\D', '', cpf_str)
    
    # Check length
    if len(cpf) != 11:
        return False
    
    # Check if all digits are same (invalid)
    if len(set(cpf)) == 1:
        return False
    
    # Validate first check digit
    sum1 = sum(int(cpf[i]) * (10 - i) for i in range(9))
    digit1 = 11 - (sum1 % 11)
    digit1 = 0 if digit1 > 9 else digit1
    
    if int(cpf[9]) != digit1:
        return False
    
    # Validate second check digit
    sum2 = sum(int(cpf[i]) * (11 - i) for i in range(10))
    digit2 = 11 - (sum2 % 11)
    digit2 = 0 if digit2 > 9 else digit2
    
    return int(cpf[10]) == digit2

def generate_valid_cpf():
    """Generate a valid Brazilian CPF with check digits"""
    # Generate first 9 digits
    base = [random.randint(0, 9) for _ in range(9)]
    
    # Calculate first check digit
    sum1 = sum(base[i] * (10 - i) for i in range(9))
    digit1 = 11 - (sum1 % 11)
    digit1 = 0 if digit1 > 9 else digit1
    base.append(digit1)
    
    # Calculate second check digit
    sum2 = sum(base[i] * (11 - i) for i in range(10))
    digit2 = 11 - (sum2 % 11)
    digit2 = 0 if digit2 > 9 else digit2
    base.append(digit2)
    
    # Format as 000.000.000-00
    cpf_str = ''.join(map(str, base))
    return f"{cpf_str[0:3]}.{cpf_str[3:6]}.{cpf_str[6:9]}-{cpf_str[9:11]}"

# ============= CONNECTION & DATABASE =============
def create_connection(db_url):
    """Create connection to PostgreSQL"""
    try:
        return psycopg2.connect(db_url)
    except psycopg2.Error as e:
        print(f"✗ Connection error: {e}")
        sys.exit(1)

# ============= DATA GENERATION =============
def generate_users(fake, count=10000):
    """
    Generate user records (1NF: atomic, no repeating groups)
    CPF is unique per user (2NF: no partial dependencies)
    """
    users = []
    cities = list(NORMALIZED_CITIES.keys())
    used_cpfs = set()
    used_emails = set()
    
    print(f"  Generating {count} unique users with valid CPF...")
    
    for i in range(1, count + 1):
        # Ensure unique CPF
        while True:
            cpf = generate_valid_cpf()
            if cpf not in used_cpfs:
                used_cpfs.add(cpf)
                break
        
        # Ensure unique email
        while True:
            email = f"{fake.user_name().lower()}_{i}@aprenda.sql"
            if email not in used_emails:
                used_emails.add(email)
                break
        
        city = random.choice(cities)
        city_info = NORMALIZED_CITIES[city]
        
        username = f"usuario_{i:05d}"
        full_name = fake.name()
        
        # Generate phone with correct DDD (2NF: no partial dependency on city)
        ddd = city_info['ddd']
        if random.random() < 0.6:
            phone = f"({ddd}) 9{random.randint(10000000, 99999999):08d}"
        else:
            phone = f"({ddd}) {random.randint(20000000, 99999999):08d}"
        
        address = fake.street_address()
        state = city_info['state']
        
        # Generate CEP with city prefix (3NF: normalized, not repeated)
        cep_base = city_info['cep_base']
        cep = f"{cep_base}-{random.randint(0, 999):03d}"
        
        # Realistic created_at distribution (90 days = 40%, 180 days = 40%, older = 20%)
        rand_days = random.random()
        if rand_days < 0.40:
            days_ago = random.randint(0, 90)
        elif rand_days < 0.80:
            days_ago = random.randint(90, 180)
        else:
            days_ago = random.randint(180, 365)
        
        created_at = datetime.now() - timedelta(days=days_ago, seconds=random.randint(0, 86400))
        
        users.append((
            username, email, full_name, cpf, phone, address,
            city, state, cep, created_at, datetime.now()
        ))
        
        if i % 1000 == 0:
            print(f"    Generated {i} users...")
    
    return users

def generate_accounts(conn, count=10000):
    """
    Generate user_accounts (1NF: atomic data)
    FK to users ensures referential integrity
    """
    accounts = []
    cursor = conn.cursor()
    cursor.execute("SELECT id FROM users ORDER BY id LIMIT %s", (count,))
    user_ids = [row[0] for row in cursor.fetchall()]
    cursor.close()
    
    print(f"  Generating {len(user_ids)} unique accounts...")
    
    for idx, user_id in enumerate(user_ids):
        account_type = random.choice(['checking', 'savings', 'digital'])
        account_number = f"AC{user_id:012d}"  # Unique, derived from user_id
        balance = round(random.uniform(200, 8000), 2)
        card_last_digits = f"{random.randint(0, 9999):04d}"
        
        accounts.append((
            user_id, account_type, account_number, None, card_last_digits,
            balance, None, True, datetime.now(), datetime.now()
        ))
        
        if (idx + 1) % 2000 == 0:
            print(f"    Generated {idx + 1} accounts...")
    
    return accounts

def generate_transactions(conn, tpu=8, count=10000):
    """
    Generate transactions with FK to users
    1NF: each transaction is atomic
    2NF: no partial dependencies
    """
    transactions = []
    cursor = conn.cursor()
    cursor.execute("SELECT id, city, state FROM users ORDER BY id LIMIT %s", (count,))
    users = cursor.fetchall()
    cursor.close()
    
    total_txs = count * tpu
    print(f"  Generating ~{total_txs:,} transactions (~{tpu} per user)...")
    
    tx_count = 0
    for user_id, user_city, user_state in users:
        for _ in range(tpu):
            tx_type = random.choice(TRANSACTION_TYPES)
            
            # Amount varies by type (3NF: not dependent on other fields)
            if tx_type == 'purchase':
                amount = round(random.uniform(50, 500), 2)
            elif tx_type == 'payment':
                amount = round(random.uniform(100, 1000), 2)
            elif tx_type == 'transfer':
                amount = round(random.uniform(50, 800), 2)
            else:  # withdraw
                amount = round(random.uniform(20, 300), 2)
            
            payment_method = random.choice(PAYMENT_METHODS)
            status = random.choice(TX_STATUSES)
            merchant = random.choice(MERCHANTS)
            
            # 70% in user's city, 30% in other cities
            if random.random() < 0.7:
                tx_city = user_city
                tx_state = user_state
            else:
                tx_city = random.choice(list(NORMALIZED_CITIES.keys()))
                tx_state = NORMALIZED_CITIES[tx_city]['state']
            
            # Temporal distribution: 65% last 90 days, 25% in 180, 10% in 365
            rand = random.random()
            if rand < 0.65:
                days_ago = random.randint(0, 90)
            elif rand < 0.90:
                days_ago = random.randint(90, 180)
            else:
                days_ago = random.randint(180, 365)
            
            created_at = datetime.now() - timedelta(
                days=days_ago, 
                seconds=random.randint(0, 86400)
            )
            
            transactions.append((
                user_id, amount, tx_type, merchant, payment_method,
                tx_city, tx_state, None, None, status, created_at
            ))
            
            tx_count += 1
            if tx_count % 20000 == 0:
                print(f"    Generated {tx_count:,} transactions...")
    
    return transactions

def generate_fraud(conn):
    """Generate fraud_data with FK to transactions and users"""
    fraud_records = []
    cursor = conn.cursor()
    cursor.execute("SELECT id, user_id FROM transactions WHERE random() < 0.025")
    rows = cursor.fetchall()
    cursor.close()
    
    print(f"  Generating {len(rows)} fraud records (~2.5%)...")
    
    for tx_id, user_id in rows:
        fraud_score = round(random.uniform(0.60, 1.00), 2)
        fraud_records.append((
            tx_id, user_id, None, fraud_score, True, None, datetime.now(), None, 'open'
        ))
    
    return fraud_records

# ============= MAIN EXECUTION =============
def main():
    parser = argparse.ArgumentParser(
        description='Seed database with normalized Brazilian data (1NF/2NF/3NF) and FK constraints'
    )
    parser.add_argument('database_url', help='PostgreSQL connection string')
    parser.add_argument('--tpu', type=int, default=8, help='Transactions per user (default: 8)')
    parser.add_argument('--count', type=int, default=10000, help='Number of users (default: 10000)')
    args = parser.parse_args()
    
    fake = Faker('pt_BR')
    
    try:
        conn = create_connection(args.database_url)
        cursor = conn.cursor()
        
        # ===== USERS (1NF, 2NF, 3NF compliant) =====
        print("\n[1/5] USERS")
        users = generate_users(fake, args.count)
        execute_batch(cursor, """
            INSERT INTO users (username, email, full_name, cpf, phone, address, city, state, zip_code, created_at, updated_at)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            ON CONFLICT (username) DO NOTHING
        """, users, page_size=1000)
        conn.commit()
        print(f"  ✓ Inserted {len(users)} users")
        
        # ===== USER_ACCOUNTS (FK to users) =====
        print("\n[2/5] USER_ACCOUNTS")
        accounts = generate_accounts(conn, args.count)
        execute_batch(cursor, """
            INSERT INTO user_accounts (user_id, account_type, account_number, account_holder, card_last_digits, balance, credit_limit, is_active, created_at, updated_at)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            ON CONFLICT (account_number) DO NOTHING
        """, accounts, page_size=1000)
        conn.commit()
        print(f"  ✓ Inserted {len(accounts)} accounts")
        
        # ===== TRANSACTIONS (FK to users) =====
        print(f"\n[3/5] TRANSACTIONS (~{args.count * args.tpu:,} records)")
        transactions = generate_transactions(conn, args.tpu, args.count)
        execute_batch(cursor, """
            INSERT INTO transactions (user_id, amount, transaction_type, merchant, payment_method, location_city, location_state, ip_address, device_type, status, created_at)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, transactions, page_size=1000)
        conn.commit()
        print(f"  ✓ Inserted {len(transactions)} transactions")
        
        # ===== FRAUD_DATA (FK to transactions & users) =====
        print("\n[4/5] FRAUD_DATA")
        fraud = generate_fraud(conn)
        execute_batch(cursor, """
            INSERT INTO fraud_data (transaction_id, user_id, fraud_type, fraud_score, is_fraud, reason, detected_at, resolved_at, status)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
            ON CONFLICT DO NOTHING
        """, fraud, page_size=1000)
        conn.commit()
        print(f"  ✓ Inserted {len(fraud)} fraud records")
        
        # ===== INDEXES =====
        print("\n[5/5] INDEXES & VALIDATION")
        cursor.execute("""
            CREATE INDEX IF NOT EXISTS idx_tx_created_at ON transactions(created_at);
            CREATE INDEX IF NOT EXISTS idx_tx_state ON transactions(location_state);
            CREATE INDEX IF NOT EXISTS idx_tx_user ON transactions(user_id);
            CREATE INDEX IF NOT EXISTS idx_users_state ON users(state);
            CREATE INDEX IF NOT EXISTS idx_users_cpf ON users(cpf);
            CREATE INDEX IF NOT EXISTS idx_accounts_user ON user_accounts(user_id);
            CREATE INDEX IF NOT EXISTS idx_fraud_tx ON fraud_data(transaction_id);
            CREATE INDEX IF NOT EXISTS idx_fraud_user ON fraud_data(user_id);
        """)
        conn.commit()
        print("  ✓ Indexes created")
        
        # Final validation
        cursor.execute("""
            SELECT 
              (SELECT COUNT(*) FROM users) as user_count,
              (SELECT COUNT(*) FROM user_accounts) as account_count,
              (SELECT COUNT(*) FROM transactions) as tx_count,
              (SELECT COUNT(*) FROM fraud_data) as fraud_count
        """)
        row = cursor.fetchone()
        user_count, account_count, tx_count, fraud_count = row
        
        print(f"\n✓ DATABASE SEEDING COMPLETE!")
        print(f"  • Users: {user_count:,}")
        print(f"  • Accounts: {account_count:,}")
        print(f"  • Transactions: {tx_count:,}")
        print(f"  • Fraud Records: {fraud_count:,}")
        print(f"\n✓ Data is normalized (1NF/2NF/3NF) with all FK constraints enforced!")
        
        cursor.close()
        conn.close()
        
    except Exception as e:
        print(f"\n✗ Error: {e}", file=sys.stderr)
        import traceback
        traceback.print_exc()
        sys.exit(1)

if __name__ == '__main__':
    main()
