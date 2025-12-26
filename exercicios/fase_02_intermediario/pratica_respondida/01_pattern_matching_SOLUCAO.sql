-- ==============================================
-- FASE 2: CONSULTAS INTERMEDIÁRIAS
-- Exercício 2.1: Pattern Matching com LIKE - SOLUÇÃO
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

-- Resultado esperado: 1 linha (João da Silva Santos)


-- EXERCÍCIO 3: Buscar por sufixo
SELECT full_name, email
FROM users
WHERE full_name LIKE '%Silva';

-- Resultado esperado: 0 linhas (nenhum nome termina em Silva)


-- EXERCÍCIO 4: Buscar emails por domínio
SELECT full_name, email
FROM users
WHERE email LIKE '%.com';

-- Resultado esperado: 10 linhas (todos os emails terminam em .com)


-- EXERCÍCIO 5: Busca case-insensitive
SELECT full_name, email
FROM users
WHERE full_name ILIKE '%silva%';

-- Resultado esperado: 1 linha (insensível a maiúsculas/minúsculas)


-- EXERCÍCIO 6: Underscore (_) para um caractere
SELECT full_name, email
FROM users
WHERE full_name LIKE 'Jo__';

-- Resultado esperado: 0 linhas (nomes com exatamente 4 letras começando com Jo)

