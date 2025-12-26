-- ==============================================
-- FASE 4: AGREGAÇÕES E RESUMOS
-- Exercício 4.2: Cláusula HAVING e Filtros Avançados - SOLUÇÃO
-- ==============================================

-- EXERCÍCIO 1: Usuários com 2 ou mais posts
SELECT u.full_name, COUNT(p.id) as total_posts
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
GROUP BY u.id, u.full_name
HAVING COUNT(p.id) >= 2
ORDER BY total_posts DESC;

-- Resultado esperado: Usuários ativos com múltiplos posts


-- EXERCÍCIO 2: Usuários com gasto acima de R$ 1000
SELECT u.full_name, SUM(t.amount) as total_gasto
FROM users u
LEFT JOIN transactions t ON u.id = t.user_id
GROUP BY u.id, u.full_name
HAVING SUM(t.amount) > 1000
ORDER BY total_gasto DESC;

-- Resultado esperado: Usuários de alto gasto


-- EXERCÍCIO 3: Posts com média de likes acima de 100
SELECT u.full_name, COUNT(p.id) as total_posts, ROUND(AVG(p.likes)::numeric, 2) as media_likes
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
GROUP BY u.id, u.full_name
HAVING AVG(p.likes) > 100
ORDER BY media_likes DESC;

-- Resultado esperado: Usuários com posts bem-recebidos


-- EXERCÍCIO 4: Transações por tipo (purchase only)
SELECT u.full_name, SUM(t.amount) as total_purchases
FROM users u
LEFT JOIN transactions t ON u.id = t.user_id AND t.transaction_type = 'purchase'
GROUP BY u.id, u.full_name
ORDER BY total_purchases DESC NULLS LAST;

-- Resultado esperado: Gasto em purchases


-- EXERCÍCIO 5: Contar posts e filtrar
SELECT u.full_name, COUNT(p.id) as total_posts
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
GROUP BY u.id, u.full_name
HAVING COUNT(p.id) = 1
ORDER BY u.full_name;

-- Resultado esperado: Usuários com exatamente um post

