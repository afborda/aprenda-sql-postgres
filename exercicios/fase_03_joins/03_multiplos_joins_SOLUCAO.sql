-- ==============================================
-- FASE 3: RELACIONAMENTOS E JOINS
-- Exercício 3.3: Múltiplos JOINs - SOLUÇÃO
-- ==============================================

-- EXERCÍCIO 1: Análise de fraudes completa
SELECT fd.fraud_type, fd.fraud_score, u.full_name, t.amount, t.merchant
FROM fraud_data fd
INNER JOIN users u ON fd.user_id = u.id
INNER JOIN transactions t ON fd.transaction_id = t.id
WHERE fd.is_fraud = TRUE
ORDER BY fd.fraud_score DESC;

-- Resultado esperado: Fraudes confirmadas com detalhes


-- EXERCÍCIO 2: Posts, autores e comentários
SELECT p.title, u.full_name as autor, p.views, COUNT(c.id) as total_comentarios
FROM posts p
INNER JOIN users u ON p.user_id = u.id
LEFT JOIN comments c ON p.id = c.post_id
GROUP BY p.id, p.title, u.full_name, p.views
ORDER BY total_comentarios DESC;

-- Resultado esperado: Posts com contagem de comentários


-- EXERCÍCIO 3: Transações com usuário e conta
SELECT u.full_name, t.amount, t.transaction_type, ua.account_type, t.payment_method
FROM transactions t
INNER JOIN users u ON t.user_id = u.id
INNER JOIN user_accounts ua ON u.id = ua.user_id
ORDER BY t.amount DESC
LIMIT 5;

-- Resultado esperado: Top 5 transações com dados completos


-- EXERCÍCIO 4: Comentários com post e autores
SELECT 
    c.content,
    p.title,
    u1.full_name as autor_comentario,
    u2.full_name as autor_post
FROM comments c
INNER JOIN posts p ON c.post_id = p.id
INNER JOIN users u1 ON c.user_id = u1.id
INNER JOIN users u2 ON p.user_id = u2.id;

-- Resultado esperado: Comentários com ambos autores


-- EXERCÍCIO 5: Dashboard de usuários
SELECT 
    u.full_name,
    COUNT(DISTINCT p.id) as total_posts,
    COUNT(DISTINCT c.id) as total_comentarios,
    COUNT(DISTINCT t.id) as total_transacoes
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
LEFT JOIN comments c ON u.id = c.user_id
LEFT JOIN transactions t ON u.id = t.user_id
GROUP BY u.id, u.full_name
ORDER BY total_posts DESC;

-- Resultado esperado: Dashboard completo por usuário
