-- ==============================================
-- FASE 3: RELACIONAMENTOS E JOINS
-- DESAFIOS CONTEXTUALIZADOS
-- ==============================================
-- 🎯 Cenário: Você é analista de dados da fintech

-- ==============================================
-- DESAFIO 1: Relatório de Engajamento
-- ==============================================
-- 📋 Contexto: Marketing quer identificar usuários engajados
-- 
-- Sua tarefa:
-- - Liste usuários com suas atividades (posts, comentários, transações)
-- - Crie uma coluna "status_engajamento":
--   - "Muito Ativo": >= 3 posts OU >= 5 comentários
--   - "Ativo": >= 1 post OU >= 2 comentários
--   - "Inativo": nenhuma atividade
-- - Retorne: full_name, total_posts, total_comentarios, status_engajamento
-- - Ordenar por total_posts DESC

SELECT 
    u.full_name,
    COUNT(DISTINCT p.id) as total_posts,
    COUNT(DISTINCT c.id) as total_comentarios,
    CASE 
        WHEN COUNT(DISTINCT p.id) >= 3 OR COUNT(DISTINCT c.id) >= 5 THEN 'Muito Ativo'
        WHEN COUNT(DISTINCT p.id) >= 1 OR COUNT(DISTINCT c.id) >= 2 THEN 'Ativo'
        ELSE 'Inativo'
    END as status_engajamento
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
LEFT JOIN comments c ON u.id = c.user_id
GROUP BY u.id, u.full_name
ORDER BY total_posts DESC;

-- ✅ Resposta esperada: Segmentação de usuários por engajamento


-- ==============================================
-- DESAFIO 2: Análise de Risco por Região
-- ==============================================
-- 📋 Contexto: Compliance quer mapear riscos geográficos
--
-- Sua tarefa:
-- - Para cada estado, mostre:
--   - Total de usuários
--   - Total de fraudes detectadas
--   - Score médio de fraude
--   - Taxa de fraude (fraudes / total usuários)
-- - Retorne: state, total_usuarios, total_fraudes, score_medio, taxa_fraude
-- - Ordenar por total_fraudes DESC

SELECT 
    u.state,
    COUNT(DISTINCT u.id) as total_usuarios,
    COUNT(DISTINCT fd.id) as total_fraudes,
    ROUND(AVG(fd.fraud_score)::numeric, 2) as score_medio,
    ROUND((COUNT(DISTINCT fd.id)::numeric / COUNT(DISTINCT u.id)::numeric), 2) as taxa_fraude
FROM users u
LEFT JOIN fraud_data fd ON u.id = fd.user_id
GROUP BY u.state
ORDER BY total_fraudes DESC;

-- ✅ Resposta esperada: Mapeamento de risco por estado


-- ==============================================
-- DESAFIO 3: Posts Virais sem Engajamento
-- ==============================================
-- 📋 Contexto: Produto quer entender posts com muitas views mas poucos comentários
--
-- Sua tarefa:
-- - Encontre posts com:
--   - views > 400
--   - comentários < 2
-- - Retorne: title, views, autor, total_comentarios, likes
-- - Ordenar por views DESC

SELECT 
    p.title,
    p.views,
    u.full_name as autor,
    COUNT(c.id) as total_comentarios,
    p.likes
FROM posts p
INNER JOIN users u ON p.user_id = u.id
LEFT JOIN comments c ON p.id = c.post_id
GROUP BY p.id, p.title, p.views, u.full_name, p.likes
HAVING p.views > 400 AND COUNT(c.id) < 2
ORDER BY p.views DESC;

-- ✅ Resposta esperada: Posts com alta visualização e baixo engajamento

