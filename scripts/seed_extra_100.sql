-- Seed extra synthetic data (~100 users and linked records)
-- Idempotent: uses ON CONFLICT and NOT EXISTS guards

-- 1) Add 100 users with unique usernames/emails (cpf NULL to avoid format)
WITH gs AS (
  SELECT generate_series(1,100) AS n
)
INSERT INTO users (username, email, full_name, cpf, phone, address, city, state, zip_code)
SELECT 
  'aluno_'||n,
  'aluno'||n||'@aprenda.sql',
  'Aluno '||n||' de SQL',
  NULL,
  '(11) 9'||LPAD((100000 + n)::text,6,'0'),
  'Rua Estudo '||n,
  (ARRAY['São Paulo','Rio de Janeiro','Belo Horizonte','Curitiba','Porto Alegre','Fortaleza','Brasília','Salvador','Recife','Joinville'])[1 + (floor(random()*10))::int],
  (ARRAY['SP','RJ','MG','PR','RS','CE','DF','BA','PE','SC'])[1 + (floor(random()*10))::int],
  LPAD(n::text,5,'0')||'-000'
FROM gs
ON CONFLICT (username) DO NOTHING;

-- Helper CTE of new users
WITH new_users AS (
  SELECT id, full_name, city, state FROM users WHERE username LIKE 'aluno_%'
)
-- 2) One bank account per new user
INSERT INTO user_accounts (user_id, account_type, account_number, account_holder, card_last_digits, balance, credit_limit, is_active)
SELECT 
  id,
  'bank_account',
  'ACC-'||LPAD(id::text,8,'0'),
  full_name,
  NULL,
  round((random()*20000)::numeric,2),
  NULL,
  TRUE
FROM new_users
ON CONFLICT (account_number) DO NOTHING;

-- 3) One post per new user (guard against duplicates by title)
WITH new_users AS (
  SELECT id FROM users WHERE username LIKE 'aluno_%'
)
INSERT INTO posts (user_id, title, content, views, likes)
SELECT 
  id,
  'Estudo SQL #'||id,
  'Praticando consultas, JOINs e agregações no banco público.',
  (100 + (floor(random()*600))::int),
  (10 + (floor(random()*250))::int)
FROM new_users nu
WHERE NOT EXISTS (
  SELECT 1 FROM posts p WHERE p.user_id = nu.id AND p.title = 'Estudo SQL #'||nu.id
);

-- 4) One comment per new post (guard against duplicates)
WITH new_posts AS (
  SELECT id FROM posts WHERE title LIKE 'Estudo SQL #%'
)
INSERT INTO comments (post_id, user_id, content, likes)
SELECT 
  np.id,
  (SELECT id FROM users ORDER BY random() LIMIT 1),
  'Comentário de prática #'||np.id,
  (floor(random()*50))::int
FROM new_posts np
WHERE NOT EXISTS (
  SELECT 1 FROM comments c WHERE c.post_id = np.id AND c.content = 'Comentário de prática #'||np.id
);

-- 5) One transaction per new user (merchant tagged)
WITH new_users AS (
  SELECT id, city, state FROM users WHERE username LIKE 'aluno_%'
)
INSERT INTO transactions (user_id, amount, transaction_type, merchant, payment_method, location_city, location_state, ip_address, device_type, status)
SELECT 
  id,
  round((random()*3000 + 20)::numeric,2),
  (ARRAY['purchase','transfer','withdrawal'])[1 + (floor(random()*3))::int],
  'Estudo Merchant '||id,
  (ARRAY['credit_card','debit_card','pix','boleto'])[1 + (floor(random()*4))::int],
  city,
  state,
  '10.'||floor(random()*255)::int||'.'||floor(random()*255)::int||'.'||floor(random()*255)::int,
  (ARRAY['mobile','desktop','tablet'])[1 + (floor(random()*3))::int],
  'completed'
FROM new_users nu
WHERE NOT EXISTS (
  SELECT 1 FROM transactions t WHERE t.user_id = nu.id AND t.merchant = 'Estudo Merchant '||nu.id
);

-- 6) Fraud data for ~50 random study transactions
WITH tx AS (
  SELECT id, user_id FROM transactions WHERE merchant LIKE 'Estudo Merchant %' ORDER BY random() LIMIT 50
)
INSERT INTO fraud_data (transaction_id, user_id, fraud_type, fraud_score, is_fraud, reason, status)
SELECT 
  id,
  user_id,
  (ARRAY['suspicious_activity','credit_card_fraud','identity_theft'])[1 + (floor(random()*3))::int],
  round(random(),2),
  (random() > 0.85),
  'Gerado automaticamente para estudo',
  'open'
FROM tx
ON CONFLICT DO NOTHING;
