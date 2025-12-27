-- Seed com dados realistas brasileiros usando apenas SQL
-- Execução: psql "..." -v ON_ERROR_STOP=1 -f scripts/seed_faker_sql_10k.sql

BEGIN;

-- Tabela temporária com dados brasileiros realistas
CREATE TEMP TABLE temp_users (
  username VARCHAR(50),
  email VARCHAR(100),
  full_name VARCHAR(150),
  cpf VARCHAR(14),
  phone VARCHAR(20),
  address VARCHAR(255),
  city VARCHAR(100),
  state VARCHAR(2),
  zip_code VARCHAR(10)
);

-- INSERT 10k users com dados variados
INSERT INTO temp_users
WITH 
first_names AS (
  SELECT unnest(ARRAY[
    'João','Maria','Carlos','Ana','Pedro','Lucia','Felipe','Beatriz','Rafael','Isabela',
    'Guilherme','Larissa','Marcos','Patricia','Bruno','Camila','André','Fernanda','Diego','Aline',
    'Ricardo','Mariana','Fernando','Carolina','Lucas','Vanessa','Rodrigo','Amanda','Alves','Simone',
    'Eduardo','Juliana','Antonio','Sophia','Roberto','Vitória','Gustavo','Giuliana','Paulo','Marina'
  ]) AS fn
),
last_names AS (
  SELECT unnest(ARRAY[
    'Silva','Oliveira','Santos','Pereira','Gomes','Martins','Rocha','Castro','Dias','Nunes',
    'Costa','Ferreira','Alves','Mendes','Barbosa','Lima','Cardoso','Ribeiro','Souza','Araújo',
    'Cavalcante','Monteiro','Guedes','Pacheco','Lemos','Conceição','Freitas','Teixeira','Machado','Barros'
  ]) AS ln
),
cities_cep_ddd AS (
  SELECT * FROM (VALUES
    ('São Paulo','SP','01000','11'),('Rio de Janeiro','RJ','20000','21'),('Belo Horizonte','MG','30000','31'),
    ('Curitiba','PR','80000','41'),('Porto Alegre','RS','90000','51'),('Fortaleza','CE','60000','85'),
    ('Brasília','DF','70000','61'),('Salvador','BA','40000','71'),('Recife','PE','50000','81'),
    ('Joinville','SC','89200','47')
  ) AS t(city, state, cep_base, ddd)
),
cpf_numbers AS (
  -- CPF format: 000.000.000-00 (realistic looking)
  SELECT i, 
    LPAD((100000000 + (i % 900000000))::TEXT, 9, '0') AS cpf_base
  FROM generate_series(1, 10000) i
),
users_data AS (
  SELECT
    s.i,
    'usuario_' || LPAD(s.i::TEXT, 5, '0') AS username,
    LOWER(fn.fn) || '.' || LOWER(ln.ln) || s.i || '@aprenda.sql' AS email,
    fn.fn || ' ' || ln.ln || CASE WHEN (s.i % 4) = 0 THEN ' ' || (SELECT ln2.ln FROM last_names ln2 ORDER BY RANDOM() LIMIT 1) ELSE '' END AS full_name,
    SUBSTRING(cpf.cpf_base, 1, 3) || '.' || SUBSTRING(cpf.cpf_base, 4, 3) || '.' || SUBSTRING(cpf.cpf_base, 7, 3) || '-' || LPAD((s.i % 100)::TEXT, 2, '0') AS cpf,
    '(' || c.ddd || ') 9' || LPAD((10000000 + (s.i * 7 % 90000000))::TEXT, 8, '0') AS phone,
    'Rua ' || fn.fn || ', ' || ((s.i % 1000) + 1)::TEXT AS address,
    c.city, c.state,
    c.cep_base || '-' || LPAD((s.i % 1000)::TEXT, 3, '0') AS zip_code
  FROM generate_series(1, 10000) s(i)
  CROSS JOIN LATERAL (SELECT fn FROM first_names ORDER BY RANDOM() LIMIT 1) fn
  CROSS JOIN LATERAL (SELECT ln FROM last_names ORDER BY RANDOM() LIMIT 1) ln
  CROSS JOIN LATERAL (SELECT city, state, cep_base, ddd FROM cities_cep_ddd ORDER BY RANDOM() LIMIT 1) c
  CROSS JOIN LATERAL (SELECT LPAD((100000000 + (s.i % 900000000))::TEXT, 9, '0') AS cpf_base) cpf
)
SELECT username, email, full_name, cpf, phone, address, city, state, zip_code
FROM users_data;

-- INSERT into actual users table
INSERT INTO users (username, email, full_name, cpf, phone, address, city, state, zip_code, created_at, updated_at)
SELECT username, email, full_name, cpf, phone, address, city, state, zip_code,
  NOW() - (INTERVAL '365 days' * random())::INTERVAL,
  NOW()
FROM temp_users
ON CONFLICT (username) DO NOTHING;

-- INSERT accounts
INSERT INTO user_accounts (user_id, account_type, account_number, card_last_digits, balance, is_active, created_at, updated_at)
SELECT
  id,
  (ARRAY['checking','savings','digital'])[1 + (id % 3)] AS account_type,
  'AC' || LPAD(id::TEXT, 12, '0') AS account_number,
  LPAD((floor(random()*10000))::TEXT, 4, '0') AS card_last_digits,
  ROUND((random()*8000 + 200)::NUMERIC, 2) AS balance,
  TRUE, NOW(), NOW()
FROM users
ON CONFLICT (account_number) DO NOTHING;

-- INSERT transactions (~8 per user = 80k)
INSERT INTO transactions (user_id, amount, transaction_type, payment_method, status, merchant, location_city, location_state, created_at)
SELECT
  u.id,
  CASE
    WHEN t_type = 'purchase' THEN ROUND((random()*450 + 50)::NUMERIC, 2)
    WHEN t_type = 'payment' THEN ROUND((random()*900 + 100)::NUMERIC, 2)
    WHEN t_type = 'transfer' THEN ROUND((random()*800 + 50)::NUMERIC, 2)
    ELSE ROUND((random()*300 + 20)::NUMERIC, 2)
  END AS amount,
  t_type AS transaction_type,
  (ARRAY['pix','credit_card','debit_card','boleto'])[1 + (random()::int % 4)] AS payment_method,
  (ARRAY['completed','pending','failed'])[1 + (random()::int % 3)] AS status,
  (ARRAY['Supermercado Bom Preço','Farmácia Saúde','Delivery Rápido','Moda Brasil','Eletrônicos Tech','Serviços Úteis','Restaurante Sabor','Padaria do Bairro','Posto de Gasolina','Loja de Casa'])[1 + (random()::int % 10)] AS merchant,
  u.city, u.state,
  NOW() - CASE 
    WHEN random() < 0.65 THEN (INTERVAL '90 days' * random())::INTERVAL
    WHEN random() < 0.90 THEN (INTERVAL '180 days' * random())::INTERVAL
    ELSE (INTERVAL '365 days' * random())::INTERVAL
  END AS created_at
FROM users u
CROSS JOIN generate_series(1, 8) tx_num
CROSS JOIN LATERAL (SELECT (ARRAY['purchase','transfer','withdraw','payment'])[1 + (random()::int % 4)] AS t_type) t;

-- INSERT fraud (~2.5% of transactions)
INSERT INTO fraud_data (transaction_id, user_id, is_fraud, fraud_score)
SELECT id, user_id, TRUE, ROUND(((0.60 + random()*0.40)::NUMERIC), 2)
FROM transactions
WHERE random() < 0.025
ON CONFLICT DO NOTHING;

COMMIT;

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_tx_created_at ON transactions(created_at);
CREATE INDEX IF NOT EXISTS idx_tx_state ON transactions(location_state);
CREATE INDEX IF NOT EXISTS idx_tx_user ON transactions(user_id);
CREATE INDEX IF NOT EXISTS idx_users_state ON users(state);
CREATE INDEX IF NOT EXISTS idx_accounts_user ON user_accounts(user_id);
CREATE INDEX IF NOT EXISTS idx_fraud_tx ON fraud_data(transaction_id);
