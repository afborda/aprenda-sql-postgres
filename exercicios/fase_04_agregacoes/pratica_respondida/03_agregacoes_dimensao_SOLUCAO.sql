-- ==============================================
-- FASE 4: AGREGAÇÕES E RESUMOS
-- Exercício 4.3: Agregações por Dimensão - SOLUÇÃO
-- ==============================================

-- EXERCÍCIO 1: Usuários e posts por estado
SELECT u.state, COUNT(DISTINCT u.id) as total_usuarios, COUNT(p.id) as total_posts
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
GROUP BY u.state
ORDER BY total_posts DESC;

-- Resultado esperado: Distribuição por estado


-- EXERCÍCIO 2: Transações por tipo
SELECT t.transaction_type, COUNT(t.id) as total_transacoes, SUM(t.amount) as valor_total
FROM transactions t
GROUP BY t.transaction_type
ORDER BY valor_total DESC;

-- Resultado esperado: Transações por tipo


-- EXERCÍCIO 3: Análise por estado e tipo de transação
SELECT u.state, t.transaction_type, SUM(t.amount) as total_valor, COUNT(t.id) as total_transacoes
FROM users u
LEFT JOIN transactions t ON u.id = t.user_id
GROUP BY u.state, t.transaction_type
ORDER BY u.state, total_valor DESC;

-- Resultado esperado: Cruzamento estado x tipo


-- EXERCÍCIO 4: Engajamento por usuário
SELECT u.full_name, COUNT(DISTINCT p.id) as total_posts, COUNT(DISTINCT c.id) as total_comentarios
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
LEFT JOIN comments c ON u.id = c.user_id
GROUP BY u.id, u.full_name
ORDER BY total_posts DESC;

-- Resultado esperado: Atividade de cada usuário


-- EXERCÍCIO 5: Fraudes por estado
SELECT u.state, COUNT(DISTINCT fd.id) as total_fraudes, ROUND(AVG(fd.fraud_score)::numeric, 2) as score_medio
FROM users u
LEFT JOIN fraud_data fd ON u.id = fd.user_id AND fd.is_fraud = TRUE
GROUP BY u.state
HAVING COUNT(DISTINCT fd.id) > 0
ORDER BY total_fraudes DESC;

-- Resultado esperado: Risco por região

