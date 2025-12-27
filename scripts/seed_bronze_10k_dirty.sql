-- Seed bronze com inconformidades controladas para pratica ETL
-- Execucao: psql "..." -v ON_ERROR_STOP=1 -v tpu=6 -f scripts/seed_bronze_10k_dirty.sql
\set tpu 6

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
    'bronze_' || LPAD(s.i::TEXT, 5, '0') AS username,
    -- 8% emails invalidos/maiúsculos/faltando dominio
    CASE WHEN random() < 0.08 THEN UPPER(fn.fn || s.i || '@APR') ELSE LOWER(fn.fn || '.' || ln.ln || s.i || '@aprenda.sql') END AS email,
    fn.fn || ' ' || ln.ln || CASE WHEN (s.i % 3)=0 THEN ' ' || (SELECT ln2.ln FROM last_names ln2 ORDER BY random() LIMIT 1) ELSE '' END AS full_name,
    -- CPF nulo ou tamanho errado em ~15%
    CASE WHEN random() < 0.15 THEN SUBSTRING(LPAD(floor(random()*1e11)::TEXT,11,'0'),1,10) ELSE LPAD(floor(random()*1e11)::TEXT,11,'0') END AS cpf,
    -- Telefone sem formato/DDD errado em ~12%
    CASE WHEN random() < 0.12 THEN LPAD(floor(random()*1e10)::TEXT,10,'0') ELSE '(' || c.ddd || ') ' || LPAD(floor(random()*1e9)::TEXT,9,'0') END AS phone,
    'Rua ETL, ' || ((s.i % 1000)+1) AS address,
    -- 5% UF trocada com cidade
    CASE WHEN random() < 0.05 THEN (SELECT city FROM city_map ORDER BY random() LIMIT 1) ELSE c.city END AS city,
    CASE WHEN random() < 0.05 THEN (SELECT state FROM city_map ORDER BY random() LIMIT 1) ELSE c.state END AS state,
    -- 10% CEP sem hifen ou tamanho errado
    CASE WHEN random() < 0.10 THEN REPLACE(c.cep_base,'-','') ELSE SUBSTRING(c.cep_base,1,5) || '-' || LPAD((s.i % 1000)::TEXT,3,'0') END AS cep,
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
    (ARRAY['checking','savings','digital'])[1 + floor(random()*3)::int],
    'ACB' || LPAD(u.id::TEXT, 12, '0') AS account_number,
    ROUND((random()*8000 - 500)::NUMERIC, 2), -- pode gerar negativo
    LPAD((floor(random()*10000))::TEXT, 4, '0') AS card_last_digits,
    NOW(), NOW()
  FROM users u
  WHERE u.username LIKE 'bronze_%'
  ON CONFLICT (account_number) DO NOTHING
  RETURNING user_id
),
cfg AS (SELECT COALESCE(NULLIF(:tpu, ''), '6')::int AS tpu)
INSERT INTO transactions (user_id, amount, transaction_type, payment_method, status, merchant, location_city, location_state, created_at)
SELECT
  CASE WHEN random() < 0.003 THEN u.id + 999999 ELSE u.id END AS user_id, -- ~0.3% orfa
  CASE WHEN random() < 0.10 THEN ROUND((random()*200)::NUMERIC, 2) * -1 ELSE ROUND((random()*900 + 10)::NUMERIC, 2) END AS amount, -- 10% negativos
  (ARRAY['purchase','transfer','withdraw','payment'])[1 + floor(random()*4)::int] AS transaction_type,
  (ARRAY['pix','credit_card','debit_card','boleto','cheque'])[1 + floor(random()*5)::int] AS payment_method, -- cheque fora do dominio
  (ARRAY['completed','pending','failed','unknown'])[1 + floor(random()*4)::int] AS status, -- unknown invalido
  (ARRAY['Supermercado Bom Preco','Farmacia Saude','Delivery Rapido','Loja Generica',''] )[1 + floor(random()*5)::int] AS merchant,
  c.city, c.state,
  CASE WHEN random() < 0.05 THEN NOW() + INTERVAL '5 days' ELSE NOW() - (INTERVAL '365 days' * random()) END AS created_at -- 5% datas futuras
FROM users u
JOIN cfg ON TRUE
CROSS JOIN LATERAL (SELECT city, state FROM city_map ORDER BY random() LIMIT 1) c
CROSS JOIN LATERAL generate_series(1, cfg.tpu) g(n)
WHERE u.username LIKE 'bronze_%';

INSERT INTO fraud_data (transaction_id, is_fraud, risk_score)
SELECT t.id, TRUE, ROUND((random()*40 + 60)::NUMERIC, 2)
FROM transactions t
WHERE random() < 0.03
ON CONFLICT DO NOTHING;

COMMIT;
