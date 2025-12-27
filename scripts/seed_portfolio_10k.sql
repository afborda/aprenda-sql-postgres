-- Seed limpo para BI: ~10k usuarios, ~80-100k transacoes (param tpu)
-- Execucao: psql "..." -v ON_ERROR_STOP=1 -v tpu=8 -f scripts/seed_portfolio_10k.sql

\set tpu 8

BEGIN;

-- INSERT 10k users
INSERT INTO users (username, email, full_name, cpf, phone, address, city, state, zip_code, created_at, updated_at)
SELECT
  'usuario_' || LPAD(i::TEXT, 5, '0') AS username,
  'user' || i || '@aprenda.sql' AS email,
  'User ' || i || ' Full Name' AS full_name,
  NULL::TEXT AS cpf,
  '(11) ' || LPAD((floor(random()*100000))::TEXT, 5, '0') || '-' || LPAD((floor(random()*10000))::TEXT, 4, '0') AS phone,
  'Rua Aprendizado, ' || ((i % 1000)+1) AS address,
  (ARRAY['Sao Paulo','Rio de Janeiro','Belo Horizonte','Curitiba','Porto Alegre','Fortaleza','Brasilia','Salvador','Recife','Joinville'])[1 + (i % 10)] AS city,
  (ARRAY['SP','RJ','MG','PR','RS','CE','DF','BA','PE','SC'])[1 + (i % 10)] AS state,
  '01000-' || LPAD((i % 1000)::TEXT, 3, '0') AS zip_code,
  NOW() - (INTERVAL '365 days' * random()) AS created_at,
  NOW() AS updated_at
FROM generate_series(1, 10000) i
ON CONFLICT (username) DO NOTHING;

-- INSERT accounts for each user
INSERT INTO user_accounts (user_id, account_type, account_number, balance, card_last_digits, created_at, updated_at)
SELECT
  id,
  (ARRAY['checking','savings','digital'])[1 + (id % 3)] AS account_type,
  'AC' || LPAD(id::TEXT, 12, '0') AS account_number,
  ROUND((random()*8000 + 200)::NUMERIC, 2) AS balance,
  LPAD((floor(random()*10000))::TEXT, 4, '0') AS card_last_digits,
  NOW(), NOW()
FROM users
ON CONFLICT (account_number) DO NOTHING;

-- INSERT ~80k transactions (8 per user with tpu=8)
INSERT INTO transactions (user_id, amount, transaction_type, payment_method, status, merchant, location_city, location_state, created_at)
SELECT
  u.id,
  CASE
    WHEN t.tt = 'purchase' THEN ROUND((random()*450 + 50)::NUMERIC, 2)
    WHEN t.tt = 'payment' THEN ROUND((random()*900 + 100)::NUMERIC, 2)
    WHEN t.tt = 'transfer' THEN ROUND((random()*800 + 50)::NUMERIC, 2)
    ELSE ROUND((random()*300 + 20)::NUMERIC, 2)
  END AS amount,
  t.tt AS transaction_type,
  (ARRAY['pix','credit_card','debit_card','boleto'])[1 + (random()::int % 4)] AS payment_method,
  (ARRAY['completed','pending','failed'])[1 + (random()::int % 3)] AS status,
  (ARRAY['Supermercado','Farmacia','Delivery','Moda','Eletronicos','Servicos','Restaurante','Padaria','Gasolina','Loja'])[1 + (random()::int % 10)] AS merchant,
  u.city, u.state,
  NOW() - (INTERVAL '1 second' * (random()*31536000)::int) AS created_at
FROM users u, generate_series(1, :tpu) AS tx_num
CROSS JOIN LATERAL (SELECT (ARRAY['purchase','transfer','withdraw','payment'])[1 + (random()::int % 4)] AS tt) t;

-- INSERT fraud flags (~2.5% of transactions)
INSERT INTO fraud_data (transaction_id, user_id, is_fraud, fraud_score)
SELECT id, user_id, TRUE, ROUND(((0.60 + random()*0.40)::NUMERIC), 2)
FROM transactions
WHERE random() < 0.025
ON CONFLICT DO NOTHING;

COMMIT;

CREATE INDEX IF NOT EXISTS idx_tx_created_at ON transactions(created_at);
CREATE INDEX IF NOT EXISTS idx_tx_state ON transactions(location_state);
CREATE INDEX IF NOT EXISTS idx_tx_user ON transactions(user_id);
CREATE INDEX IF NOT EXISTS idx_users_state ON users(state);
CREATE INDEX IF NOT EXISTS idx_accounts_user ON user_accounts(user_id);
CREATE INDEX IF NOT EXISTS idx_fraud_tx ON fraud_data(transaction_id);
