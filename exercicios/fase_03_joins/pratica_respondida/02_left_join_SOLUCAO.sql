-- ==============================================
-- FASE 3: RELACIONAMENTOS E JOINS
-- Exercício 3.2: LEFT JOIN - SOLUÇÃO
-- ==============================================

-- EXERCÍCIO 1: Usuários e seus posts (todos)
SELECT u.full_name, COUNT(p.id) as total_posts
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
GROUP BY u.id, u.full_name
ORDER BY total_posts DESC;

-- Resultado esperado: Todos usuários com contagem de posts


-- EXERCÍCIO 2: Usuários que nunca postaram
SELECT u.full_name, u.email
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
WHERE p.id IS NULL;

-- Resultado esperado: Usuários sem posts


-- EXERCÍCIO 3: Usuários e transações (todos)
SELECT u.full_name, COUNT(t.id) as total_transacoes
FROM users u
LEFT JOIN transactions t ON u.id = t.user_id
GROUP BY u.id, u.full_name
ORDER BY total_transacoes DESC;

-- Resultado esperado: Todos usuários com count de transações


-- EXERCÍCIO 4: Posts com ou sem comentários
SELECT p.title, COUNT(c.id) as total_comentarios
FROM posts p
LEFT JOIN comments c ON p.id = c.post_id
GROUP BY p.id, p.title
ORDER BY total_comentarios DESC;

-- Resultado esperado: Posts com contagem de comentários


-- EXERCÍCIO 5: Usuários inativos (sem transações)
SELECT u.full_name, u.state, u.created_at
FROM users u
LEFT JOIN transactions t ON u.id = t.user_id
WHERE t.id IS NULL;

