-- Seed limpo para BI: ~10k usuarios, ~80-100k transacoes (param tpu)
-- Execucao: psql "..." -v ON_ERROR_STOP=1 -v tpu=8 -f scripts/seed_portfolio_10k.sql

\set tpu 8

BEGIN;

WITH city_map AS (
  SELECT * FROM (VALUES
    ('Sao Paulo','SP','01000-000','11'),
    ('Rio de Janeiro','RJ','20000-000','21'),
    ('Belo Horizonte','MG','30000-000','31'),
    ('Curitiba','PR','80000-000','41'),
    ('Porto Alegre','RS','90000-000','51'),
    ('Fortaleza','CE','60000-000','85'),
    ('Brasilia','DF','70000-000','61'),
    ('Salvador','BA','40000-000','71'),
    ('Recife','PE','50000-000','81'),
    ('Joinville','SC','89200-000','47')
  ) AS t(city, state, cep_base, ddd)
),
first_names AS (
  SELECT unnest(ARRAY['Joao','Maria','Carlos','Ana','Pedro','Lucia','Felipe','Beatriz','Rafael','Isabela','Guilherme','Larissa','Marcos','Patricia','Bruno','Camila','Andre','Fernanda','Diego','Aline']) AS fn
),
last_names AS (
  SELECT unnest(ARRAY['Silva','Oliveira','Santos','Pereira','Gomes','Martins','Rocha','Castro','Dias','Nunes','Costa','Ferreira','Alves','Mendes','Barbosa','Lima','Cardoso','Ribeiro','Souza','Araujo']) AS ln
),
series AS (
  SELECT gs AS i FROM generate_series(1, 10000) gs
),
ins_users AS (
  INSERT INTO users (username, email, full_name, cpf, phone, address, city, state, cep, created_at, updated_at)
  SELECT
    'usuario_' || LPAD(s.i::TEXT, 5, '0') AS username,
    LOWER(REPLACE(fn.fn, ' ', '')) || '.' || LOWER(ln.ln) || s.i || '@aprenda.sql' AS email,
    fn.fn || ' ' || ln.ln || CASE WHEN (s.i % 3)=0 THEN ' ' || (SELECT ln2.ln FROM last_names ln2 ORDER BY random() LIMIT 1) ELSE '' END AS full_name,
    NULL::TEXT AS cpf,
    '(' || c.ddd || ') ' ||
    CASE WHEN (s.i % 2)=0
      THEN '9' || LPAD((floor(random()*100000))::TEXT, 5, '0') || '-' || LPAD((floor(random()*10000))::TEXT, 4, '0')
      ELSE LPAD((floor(random()*10000))::TEXT, 4, '0') || '-' || LPAD((floor(random()*10000))::TEXT, 4, '0')
    END AS phone,
    'Rua Aprendizado, ' || ((s.i % 1000)+1) AS address,
    c.city, c.state,
    SUBSTRING(c.cep_base,1,5) || '-' || LPAD((s.i % 1000)::TEXT,3,'0') AS cep,
    NOW() - (INTERVAL '365 days' * random()) AS created_at,
    NOW() AS updated_at
  FROM series s
  CROSS JOIN LATERAL (SELECT fn FROM first_names ORDER BY random() LIMIT 1) fn
  CROSS JOIN LATERAL (SELECT ln FROM last_names ORDER BY random() LIMIT 1) ln
  CROSS JOIN LATERAL (SELECT city, state, cep_base, ddd FROM city_map ORDER BY random() LIMIT 1) c
  ON CONFLICT (username) DO NOTHING
  RETURNING id, username
),
ins_accounts AS (
  INSERT INTO user_accounts (user_id, account_type, account_number, balance, card_last_digits, created_at, updated_at)
  SELECT
    u.id,
    (ARRAY['checking','savings','digital'])[1 + floor(random()*3)::int] AS account_type,
    'AC' || LPAD(u.id::TEXT, 12, '0') AS account_number,
    ROUND((random()*8000 + 200)::NUMERIC, 2) AS balance,
    LPAD((floor(random()*10000))::TEXT, 4, '0') AS card_last_digits,
    NOW(), NOW()
  FROM users u
  WHERE u.username LIKE 'usuario_%'
  ON CONFLICT (account_number) DO NOTHING
  RETURNING user_id
),
cfg AS (SELECT COALESCE(NULLIF(:tpu, ''), '8')::int AS tpu)
INSERT INTO transactions (user_id, amount, transaction_type, payment_method, status, merchant, location_city, location_state, created_at)
SELECT
  u.id,
  CASE
    WHEN tt = 'purchase' THEN ROUND((random()*450 + 50)::NUMERIC, 2)
    WHEN tt = 'payment' THEN ROUND((random()*900 + 100)::NUMERIC, 2)
    WHEN tt = 'transfer' THEN ROUND((random()*800 + 50)::NUMERIC, 2)
    ELSE ROUND((random()*300 + 20)::NUMERIC, 2)
  END AS amount,
  tt AS transaction_type,
  (ARRAY['pix','credit_card','debit_card','boleto'])[1 + floor(random()*4)::int] AS payment_method,
  (ARRAY['completed','pending','failed'])[1 + floor(random()*3)::int] AS status,
  (ARRAY['Supermercado Bom Preco','Farmacia Saude','Delivery Rapido','Moda Brasil','Eletronicos Tech','Servicos Uteis','Restaurante Sabor','Padaria do Bairro','Posto de Gasolina','Loja de Casa'])[1 + floor(random()*10)::int] AS merchant,
  c.city, c.state,
  NOW() - (
    CASE WHEN random() < 0.65 THEN INTERVAL '90 days' * random()
         WHEN random() < 0.90 THEN INTERVAL '180 days' * random()
         ELSE INTERVAL '365 days' * random()
    END
  ) AS created_at
FROM users u
JOIN cfg ON TRUE
CROSS JOIN LATERAL (SELECT city, state FROM city_map ORDER BY random() LIMIT 1) c
CROSS JOIN LATERAL (SELECT (ARRAY['purchase','transfer','withdraw','payment'])[1 + floor(random()*4)::int] AS tt) t
CROSS JOIN LATERAL generate_series(1, cfg.tpu) g(n)
WHERE NOT EXISTS (SELECT 1 FROM transactions t2 WHERE t2.user_id = u.id);

INSERT INTO fraud_data (transaction_id, is_fraud, risk_score)
SELECT t.id, TRUE, ROUND((random()*40 + 60)::NUMERIC, 2)
FROM transactions t
WHERE random() < 0.025
ON CONFLICT DO NOTHING;

COMMIT;

CREATE INDEX IF NOT EXISTS idx_tx_created_at ON transactions(created_at);
CREATE INDEX IF NOT EXISTS idx_tx_state ON transactions(location_state);
CREATE INDEX IF NOT EXISTS idx_tx_user ON transactions(user_id);
CREATE INDEX IF NOT EXISTS idx_users_state ON users(state);
CREATE INDEX IF NOT EXISTS idx_accounts_user ON user_accounts(user_id);
CREATE INDEX IF NOT EXISTS idx_fraud_tx ON fraud_data(transaction_id);
