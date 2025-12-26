-- ==============================================
-- FASE 3: RELACIONAMENTOS E JOINS
-- Exercício 3.1: INNER JOIN - SOLUÇÃO
-- ==============================================

-- EXERCÍCIO 1: Posts com nome do autor
SELECT p.title, u.full_name as autor
FROM posts p
INNER JOIN users u ON p.user_id = u.id;

-- Resultado esperado: Todos os posts com nome do autor


-- EXERCÍCIO 2: Transações com nome do usuário
SELECT t.amount, t.merchant, u.full_name as cliente
FROM transactions t
INNER JOIN users u ON t.user_id = u.id
ORDER BY t.amount DESC;

-- Resultado esperado: Transações ordenadas por valor


-- EXERCÍCIO 3: Comentários com título do post
SELECT c.content, p.title
FROM comments c
INNER JOIN posts p ON c.post_id = p.id
LIMIT 5;

-- Resultado esperado: 5 comentários com títulos dos posts


-- EXERCÍCIO 4: Posts com views e autor
SELECT p.title, p.views, u.full_name as autor
FROM posts p
INNER JOIN users u ON p.user_id = u.id
WHERE p.views > 300
ORDER BY p.views DESC;

-- Resultado esperado: Posts virais com autores


-- EXERCÍCIO 5: Transações de usuários de SP
SELECT u.full_name, u.state, t.amount, t.transaction_type
FROM transactions t
INNER JOIN users u ON t.user_id = u.id
WHERE u.state = 'SP';

-- Resultado esperado: Apenas transações de SP


-- EXERCÍCIO 6: Posts com likes e cidade do autor
SELECT p.title, p.likes, u.full_name, u.city
FROM posts p
INNER JOIN users u ON p.user_id = u.id
ORDER BY p.likes DESC
LIMIT 5;

-- Resultado esperado: Top 5 posts por likes
