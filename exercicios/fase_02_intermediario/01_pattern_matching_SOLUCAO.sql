-- ==============================================
-- FASE 2: CONSULTAS INTERMEDIÁRIAS
-- Exercício 2.1: Pattern Matching - SOLUÇÃO
-- ==============================================

-- EXERCÍCIO 1: Buscar por prefixo
SELECT full_name, email
FROM users
WHERE full_name LIKE 'Maria%';

-- Resultado esperado: 1 linha (Maria Oliveira Costa)


-- EXERCÍCIO 2: Buscar por contém
SELECT full_name, state
FROM users
WHERE full_name LIKE '%Silva%';

-- Resultado esperado: 2 linhas (João da Silva Santos, Lúcia Martins da Silva)


-- EXERCÍCIO 3: Buscar por sufixo
SELECT full_name, email
FROM users
WHERE full_name LIKE '%Silva';

-- Resultado esperado: Usuários com Silva no final do nome


-- EXERCÍCIO 4: Buscar emails por domínio
SELECT full_name, email
FROM users
WHERE email LIKE '%.com';

-- Resultado esperado: 10 linhas (todos têm .com)


-- EXERCÍCIO 5: Busca case-insensitive
SELECT full_name, email
FROM users
WHERE full_name ILIKE '%silva%';

-- Resultado esperado: Mesmo resultado que Ex 2 (case-insensitive)


-- EXERCÍCIO 6: Underscore para um caractere
SELECT merchant, amount
FROM transactions
WHERE merchant LIKE 'S_______ %';

-- Resultado esperado: Merchants que começam com S
