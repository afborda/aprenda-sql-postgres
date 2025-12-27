-- SOLUÇÃO 02
CREATE OR REPLACE VIEW silver_users AS
WITH ranked AS (
  SELECT u.*, LOWER(TRIM(u.email)) AS email_norm,
         ROW_NUMBER() OVER (PARTITION BY u.cpf ORDER BY u.updated_at DESC NULLS LAST, u.id DESC) AS rn
  FROM users u
  WHERE u.state IN ('AC','AL','AP','AM','BA','CE','DF','ES','GO','MA','MT','MS','MG','PA','PB','PR','PE','PI','RJ','RN','RO','RS','RR','SC','SE','SP','TO')
)
SELECT id, username, email_norm AS email, full_name, cpf, phone, address, city, state, zip_code, created_at, updated_at
FROM ranked
WHERE rn = 1;
