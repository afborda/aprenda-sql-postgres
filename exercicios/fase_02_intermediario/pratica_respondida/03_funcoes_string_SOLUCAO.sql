-- ==============================================
-- FASE 2: CONSULTAS INTERMEDIÁRIAS
-- Exercício 2.3: Funções de String - SOLUÇÃO
-- ==============================================

-- EXERCÍCIO 1: Converter para maiúsculas
SELECT full_name, UPPER(full_name) AS uppercase_name
FROM users;

-- Resultado esperado: 10 linhas com nomes em MAIÚSCULAS


-- EXERCÍCIO 2: Converter para minúsculas
SELECT email, LOWER(email) AS email_lower
FROM users;

-- Resultado esperado: 10 linhas com emails em minúsculas


-- EXERCÍCIO 3: Tamanho do nome
SELECT full_name, LENGTH(full_name) AS name_length
FROM users
ORDER BY name_length DESC;

-- Resultado esperado: Nomes ordenados por comprimento (maior para menor)


-- EXERCÍCIO 4: Extrair parte da string
SELECT cpf, SUBSTRING(cpf, 1, 3) AS cpf_start, full_name
FROM users
WHERE cpf IS NOT NULL;

-- Resultado esperado: Primeiros 3 dígitos do CPF


-- EXERCÍCIO 5: Concatenar strings
SELECT full_name, city, CONCAT(full_name, ' - ', city) AS user_location
FROM users;

-- Resultado esperado: Nome e cidade combinados (ex: João da Silva Santos - São Paulo)


-- EXERCÍCIO 6: Email em formato uppercase
SELECT email, UPPER(email) AS email_uppercase
FROM users;

-- Resultado esperado: Emails em maiúsculas

