-- ==============================================
-- FASE 2: CONSULTAS INTERMEDIÁRIAS
-- Exercício 2.4: Funções de Data - SOLUÇÃO
-- ==============================================

-- EXERCÍCIO 1: Data e hora atual
SELECT NOW() AS data_hora_atual, CURRENT_DATE AS data_atual;

-- Resultado esperado: Data e hora atual em dois formatos


-- EXERCÍCIO 2: Idade da conta em dias
SELECT 
    full_name, 
    created_at, 
    AGE(NOW(), created_at) AS idade_conta
FROM users
ORDER BY created_at DESC;

-- Resultado esperado: Diferença de tempo entre criação e agora


-- EXERCÍCIO 3: Extrair apenas a data
SELECT title, created_at, DATE(created_at) AS data_criacao
FROM posts
LIMIT 5;

-- Resultado esperado: Data sem hora


-- EXERCÍCIO 4: Extrair ano de uma data
SELECT 
    full_name, 
    created_at, 
    EXTRACT(YEAR FROM created_at) AS ano
FROM users;

-- Resultado esperado: Ano de criação (2024 ou 2025)


-- EXERCÍCIO 5: Extrair mês e dia
SELECT 
    user_id, 
    amount, 
    EXTRACT(MONTH FROM created_at) AS mes,
    EXTRACT(DAY FROM created_at) AS dia
FROM transactions
LIMIT 5;

-- Resultado esperado: Mês (1-12) e dia (1-31) da transação


-- EXERCÍCIO 6: Usuários criados no último mês
SELECT full_name, created_at
FROM users
WHERE created_at >= NOW() - INTERVAL '30 days';

-- Resultado esperado: Usuários criados nos últimos 30 dias

