-- ==============================================
-- FASE 2: CONSULTAS INTERMEDIÁRIAS
-- Exercício 2.4: Funções de Data - SOLUÇÃO
-- ==============================================

-- EXERCÍCIO 1: Data e hora atual
SELECT NOW() as data_hora_atual, CURRENT_DATE as data_atual;

-- Resultado esperado: Data/hora atual e data atual


-- EXERCÍCIO 2: Idade da conta em dias
SELECT full_name, created_at, AGE(NOW(), created_at) as idade_conta
FROM users
ORDER BY created_at ASC;

-- Resultado esperado: Tempo desde criação em dias/meses/anos


-- EXERCÍCIO 3: Extrair apenas a data
SELECT title, created_at, DATE(created_at) as data_criacao
FROM posts
LIMIT 5;

-- Resultado esperado: Data sem hora


-- EXERCÍCIO 4: Extrair ano de uma data
SELECT full_name, created_at, EXTRACT(YEAR FROM created_at) as ano
FROM users;

-- Resultado esperado: Ano (2024 ou 2025)


-- EXERCÍCIO 5: Extrair mês e dia
SELECT user_id, amount, 
    EXTRACT(MONTH FROM created_at) as mes,
    EXTRACT(DAY FROM created_at) as dia
FROM transactions
LIMIT 5;

-- Resultado esperado: Mês (1-12) e Dia (1-31)


-- EXERCÍCIO 6: Usuários criados no último mês
SELECT full_name, created_at
FROM users
WHERE created_at >= NOW() - INTERVAL '30 days'
ORDER BY created_at DESC;

-- Resultado esperado: Usuários recentes (todos, se criados recentemente)
