-- ==============================================
-- FASE 1: FUNDAMENTOS SQL
-- Exercício 1.3: Ordenação - SOLUÇÃO
-- ==============================================

-- EXERCÍCIO 1: Usuários ordenados por nome
SELECT full_name, email 
FROM users 
ORDER BY full_name ASC;

-- Resultado esperado: 10 linhas, Ana primeiro, Lucía último


-- EXERCÍCIO 2: Posts mais visualizados (top 3)
SELECT title, views 
FROM posts 
ORDER BY views DESC 
LIMIT 3;

-- Resultado esperado: 650, 540, 510


-- EXERCÍCIO 3: 5 menores transações
SELECT user_id, amount, created_at 
FROM transactions 
ORDER BY amount ASC 
LIMIT 5;

-- Resultado esperado: 45.00, 89.99, 110.00, 150.50, 180.50


-- EXERCÍCIO 4: Usuários por estado e nome
SELECT state, full_name, city 
FROM users 
ORDER BY state ASC, full_name ASC;

-- Resultado esperado: Agrupado por estado (BA, CE, DF, MG, PE, PR, RJ, RS, SC, SP)


-- EXERCÍCIO 5: 5 usuários mais recentes
SELECT full_name, created_at 
FROM users 
ORDER BY created_at DESC 
LIMIT 5;

-- Resultado esperado: Últimos 5 usuários criados


-- EXERCÍCIO 6: Top 3 posts com mais likes
SELECT title, likes, views 
FROM posts 
ORDER BY likes DESC 
LIMIT 3;

-- Resultado esperado: Posts com 210, 167, 165 likes
