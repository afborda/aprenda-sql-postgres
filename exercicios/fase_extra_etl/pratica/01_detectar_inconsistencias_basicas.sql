-- 01) Detectar inconsistências básicas em Bronze (users)
-- Objetivo: listar potenciais problemas de formato/domínio.

-- Emails inválidos (regex simples)
SELECT id, email
FROM users
WHERE email !~ '^[^@\s]+@[^@\s]+\.[^@\s]+$';

-- CPF inválido por formato (não 11 dígitos) — atenção: sem validar dígitos verificadores aqui
SELECT id, cpf
FROM users
WHERE cpf !~ '^\d{11}$';

-- CEP inválido (não 8 dígitos)
SELECT id, zip_code
FROM users
WHERE zip_code !~ '^\d{8}$';

-- UF inválida
SELECT id, state
FROM users
WHERE state NOT IN ('AC','AL','AP','AM','BA','CE','DF','ES','GO','MA','MT','MS','MG','PA','PB','PR','PE','PI','RJ','RN','RO','RS','RR','SC','SE','SP','TO');
