-- ==============================================
-- QUERIES ÚTEIS: JOINS EXPLICADOS
-- Aprenda com exemplos reais do seu banco
-- ==============================================

-- ==============================================
-- INNER JOIN: Apenas registros com correspondência
-- ==============================================
-- Retorna APENAS linhas que existem em AMBAS as tabelas

-- ✅ Exemplo 1: Posts com nomes de autores
SELECT 
    p.title as "Título do Post",
    u.full_name as "Autor",
    p.views as "Visualizações"
FROM posts p
INNER JOIN users u ON p.user_id = u.id
ORDER BY p.views DESC;

-- Resultado: 10 posts (todos têm autor porque todo post tem user_id válido)


-- ✅ Exemplo 2: Comentários com nomes de autores
SELECT 
    c.content as "Comentário",
    u.full_name as "Quem Comentou",
    p.title as "Post"
FROM comments c
INNER JOIN users u ON c.user_id = u.id
INNER JOIN posts p ON c.post_id = p.id
ORDER BY c.created_at DESC;

-- Resultado: 11 comentários com detalhes completos


-- ✅ Exemplo 3: Transações com dados do usuário
SELECT 
    t.id as "ID",
    u.full_name as "Usuário",
    t.amount as "Valor (R$)",
    t.transaction_type as "Tipo",
    t.merchant as "Comerciante"
FROM transactions t
INNER JOIN users u ON t.user_id = u.id
WHERE t.transaction_type = 'purchase'
ORDER BY t.created_at DESC;

-- Resultado: Apenas transações que são 'purchase'

-- ==============================================
-- LEFT JOIN: Todos da esquerda + correspondências
-- ==============================================
-- Retorna TODOS os registros da tabela esquerda
-- E aqueles da direita que correspondem

-- ✅ Exemplo 4: Todos os usuários e SEUS posts (ou NULL)
SELECT 
    u.full_name as "Usuário",
    COUNT(p.id) as "Total de Posts"
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
GROUP BY u.id, u.full_name
ORDER BY u.full_name;

-- Resultado: 10 usuários, cada um com sua contagem de posts
-- Alguns têm 0 posts, outros têm 1 ou mais


-- ✅ Exemplo 5: Usuários que NUNCA fizeram transação
SELECT 
    u.full_name as "Usuário",
    COUNT(t.id) as "Transações"
FROM users u
LEFT JOIN transactions t ON u.id = t.user_id
GROUP BY u.id, u.full_name
HAVING COUNT(t.id) = 0
ORDER BY u.full_name;

-- Resultado: Usuários inativos (sem transações)


-- ✅ Exemplo 6: Posts e seus comentários (mesmo sem comentários)
SELECT 
    p.title as "Post",
    p.views as "Visualizações",
    COUNT(c.id) as "Total de Comentários"
FROM posts p
LEFT JOIN comments c ON p.id = c.post_id
GROUP BY p.id, p.title, p.views
ORDER BY COUNT(c.id) DESC;

-- Resultado: Todos os posts, alguns com 0 comentários

-- ==============================================
-- FULL OUTER JOIN: Todos de ambos os lados
-- ==============================================
-- Retorna TODOS os registros de ambas as tabelas
-- (PostgreSQL suporta, alguns SGBDs não)

-- ✅ Exemplo 7: Comparação completa de dados
SELECT 
    COALESCE(u.full_name, 'Sem nome') as "Usuário",
    COALESCE(COUNT(t.id), 0) as "Transações"
FROM users u
FULL OUTER JOIN transactions t ON u.id = t.user_id
GROUP BY u.id, u.full_name
ORDER BY COUNT(t.id) DESC;

-- Resultado: Todos os usuários mesmo os sem transações

-- ==============================================
-- SELF JOIN: Juntar tabela com ela mesma
-- ==============================================

-- ✅ Exemplo 8: Usuários da mesma cidade
SELECT 
    u1.full_name as "Usuário 1",
    u2.full_name as "Usuário 2",
    u1.city as "Cidade"
FROM users u1
INNER JOIN users u2 ON u1.city = u2.city AND u1.id < u2.id
ORDER BY u1.city;

-- Resultado: Pares de usuários na mesma cidade
