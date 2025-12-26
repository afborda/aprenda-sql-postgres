-- ==============================================
-- FASE 4: AGREGAÇÕES E RESUMOS
-- Exercício 4.1: GROUP BY e Funções Agregadas Básicas - SOLUÇÃO
-- ==============================================

-- EXERCÍCIO 1: Contar posts por usuário
SELECT u.full_name, COUNT(p.id) as total_posts
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
GROUP BY u.id, u.full_name
ORDER BY total_posts DESC;

-- Resultado esperado: Cada usuário com contagem de posts


-- EXERCÍCIO 2: Soma de transações
SELECT u.full_name, SUM(t.amount) as total_gasto
FROM users u
LEFT JOIN transactions t ON u.id = t.user_id
GROUP BY u.id, u.full_name
ORDER BY total_gasto DESC NULLS LAST;

-- Resultado esperado: Total gasto por usuário


-- EXERCÍCIO 3: Média de visualizações
SELECT u.full_name, ROUND(AVG(p.views)::numeric, 2) as media_views
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
GROUP BY u.id, u.full_name
ORDER BY media_views DESC NULLS LAST;

-- Resultado esperado: Média de visualizações dos posts


-- EXERCÍCIO 4: Transações máxima e mínima
SELECT u.full_name, MAX(t.amount) as maior_transacao, MIN(t.amount) as menor_transacao
FROM users u
LEFT JOIN transactions t ON u.id = t.user_id
GROUP BY u.id, u.full_name
ORDER BY maior_transacao DESC NULLS LAST;

-- Resultado esperado: Maior e menor valor por usuário


-- EXERCÍCIO 5: Contagem de comentários
SELECT p.title, COUNT(c.id) as total_comentarios
FROM posts p
LEFT JOIN comments c ON p.id = c.post_id
GROUP BY p.id, p.title
ORDER BY total_comentarios DESC
LIMIT 5;

-- Resultado esperado: Top 5 posts com mais comentários

