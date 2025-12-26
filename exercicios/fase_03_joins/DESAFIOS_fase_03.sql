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


-- ==============================================
-- DESAFIO 4: Perfil Financeiro do Usuário
-- ==============================================
-- 📋 Contexto: Vendas quer criar ofertas personalizadas
--
-- Sua tarefa:
-- - Para cada usuário com transações, mostre:
--   - Nome completo
--   - Total gasto (SUM de amount)
--   - Ticket médio
--   - Total de transações
--   - Tipo de conta predominante
-- - Apenas usuários com > R$ 500 em transações
-- - Retorne: full_name, total_gasto, ticket_medio, total_transacoes, account_type
-- - Ordenar por total_gasto DESC

SELECT 
    u.full_name,
    SUM(t.amount) as total_gasto,
    ROUND(AVG(t.amount)::numeric, 2) as ticket_medio,
    COUNT(t.id) as total_transacoes,
    MAX(ua.account_type) as account_type
FROM users u
INNER JOIN transactions t ON u.id = t.user_id
INNER JOIN user_accounts ua ON u.id = ua.user_id
GROUP BY u.id, u.full_name
HAVING SUM(t.amount) > 500
ORDER BY total_gasto DESC;

-- ✅ Resposta esperada: Perfil de gastos dos top clientes


-- ==============================================
-- DESAFIO 5: Usuários em Risco de Churn
-- ==============================================
-- 📋 Contexto: Retenção quer identificar usuários inativos
--
-- Sua tarefa:
-- - Encontre usuários que:
--   - NÃO fizeram transações
--   - NÃO fizeram posts
--   - Cadastrados há mais de 30 dias
-- - Retorne: full_name, email, state, created_at
-- - Ordenar por created_at ASC (mais antigos primeiro)

SELECT 
    u.full_name,
    u.email,
    u.state,
    u.created_at
FROM users u
LEFT JOIN transactions t ON u.id = t.user_id
LEFT JOIN posts p ON u.id = p.user_id
WHERE t.id IS NULL 
  AND p.id IS NULL
  AND u.created_at < NOW() - INTERVAL '30 days'
ORDER BY u.created_at ASC;

-- ✅ Resposta esperada: Usuários em risco de abandono


-- ==============================================
-- BONUS: DESAFIO 6 - Dashboard Executivo
-- ==============================================
-- 📋 Contexto: C-Level quer visão 360° do negócio
--
-- Sua tarefa:
-- - Crie um relatório mostrando:
--   - Usuário
--   - Total posts
--   - Total comentários
--   - Total transações
--   - Valor total transacionado
--   - Score médio de fraude (se houver)
--   - Status: "VIP" (>R$1000), "Regular" (R$100-1000), "Novo" (<R$100 ou sem transação)
-- - Apenas top 10 usuários por valor transacionado

SELECT 
    u.full_name,
    COUNT(DISTINCT p.id) as total_posts,
    COUNT(DISTINCT c.id) as total_comentarios,
    COUNT(DISTINCT t.id) as total_transacoes,
    COALESCE(SUM(t.amount), 0) as valor_total,
    ROUND(AVG(fd.fraud_score)::numeric, 2) as score_fraude_medio,
    CASE 
        WHEN COALESCE(SUM(t.amount), 0) > 1000 THEN 'VIP'
        WHEN COALESCE(SUM(t.amount), 0) >= 100 THEN 'Regular'
        ELSE 'Novo'
    END as status
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
LEFT JOIN comments c ON u.id = c.user_id
LEFT JOIN transactions t ON u.id = t.user_id
LEFT JOIN fraud_data fd ON u.id = fd.user_id
GROUP BY u.id, u.full_name
ORDER BY valor_total DESC
LIMIT 10;

-- ✅ Resposta esperada: Dashboard completo top 10 clientes
