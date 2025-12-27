-- SOLUÇÃO 01
-- Mesma consulta de referência; pode enriquecer com contagens.

-- Contagem geral de problemas por tipo
WITH emails AS (
  SELECT COUNT(*) AS invalid_emails FROM users WHERE email !~ '^[^@\s]+@[^@\s]+\.[^@\s]+$'
), cpfs AS (
  SELECT COUNT(*) AS invalid_cpfs FROM users WHERE cpf !~ '^\d{11}$'
), ceps AS (
  SELECT COUNT(*) AS invalid_ceps FROM users WHERE zip_code !~ '^\d{8}$'
), ufs AS (
  SELECT COUNT(*) AS invalid_ufs FROM users WHERE state NOT IN ('AC','AL','AP','AM','BA','CE','DF','ES','GO','MA','MT','MS','MG','PA','PB','PR','PE','PI','RJ','RN','RO','RS','RR','SC','SE','SP','TO')
)
SELECT * FROM emails, cpfs, ceps, ufs;
