-- ==============================================
-- FASE 4: AGREGAÇÕES E RESUMOS
-- Exercício 4.4: Relatórios Executivos Completos - SOLUÇÃO
-- ==============================================

-- EXERCÍCIO 1: Dashboard de Plataforma
SELECT 
    COUNT(DISTINCT u.id) as total_usuarios,
    COUNT(DISTINCT p.id) as total_posts,
    COUNT(DISTINCT c.id) as total_comentarios,
    ROUND((COUNT(DISTINCT p.id)::numeric / COUNT(DISTINCT u.id)::numeric), 2) as media_posts_por_usuario,
    ROUND((COUNT(DISTINCT c.id)::numeric / NULLIF(COUNT(DISTINCT p.id), 0)), 2) as media_comentarios_por_post
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
LEFT JOIN comments c ON p.id = c.post_id;

-- Resultado esperado: Overview da plataforma


-- EXERCÍCIO 2: Top 5 Usuários por Engajamento
SELECT 
    u.full_name,
    COUNT(DISTINCT p.id) as total_posts,
    COUNT(DISTINCT c.id) as total_comentarios,
    COUNT(DISTINCT t.id) as total_transacoes,
    (COUNT(DISTINCT p.id) + COUNT(DISTINCT c.id) + COUNT(DISTINCT t.id)) as score_engajamento
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
LEFT JOIN comments c ON u.id = c.user_id
LEFT JOIN transactions t ON u.id = t.user_id
GROUP BY u.id, u.full_name
ORDER BY score_engajamento DESC
LIMIT 5;

-- Resultado esperado: Top 5 usuários mais engajados


-- EXERCÍCIO 3: Análise Financeira por Região
SELECT 
    u.state,
    COUNT(DISTINCT u.id) as total_usuarios,
    SUM(t.amount) as valor_total_transacoes,
    ROUND((SUM(t.amount)::numeric / COUNT(DISTINCT u.id)::numeric), 2) as valor_medio_por_usuario,
    MAX(t.amount) as valor_maximo,
    MIN(t.amount) as valor_minimo
FROM users u
LEFT JOIN transactions t ON u.id = t.user_id
GROUP BY u.state
ORDER BY valor_total_transacoes DESC NULLS LAST;

-- Resultado esperado: Análise por estado


-- EXERCÍCIO 4: Relatório de Fraude
SELECT 
    COUNT(DISTINCT fd.id) as total_fraudes,
    COUNT(DISTINCT CASE WHEN fd.is_fraud = TRUE THEN fd.id END) as fraudes_confirmadas,
    ROUND(AVG(fd.fraud_score)::numeric, 2) as score_medio,
    ROUND((COUNT(DISTINCT CASE WHEN fd.is_fraud = TRUE THEN fd.id END)::numeric / 
           COUNT(DISTINCT t.id)::numeric), 4) as taxa_fraude
FROM fraud_data fd
LEFT JOIN transactions t ON fd.transaction_id = t.id;

-- Resultado esperado: Overview de fraudes


-- EXERCÍCIO 5: Comparativo de Desempenho
SELECT 
    u.full_name,
    COUNT(DISTINCT p.id) as posts_criados,
    ROUND((COUNT(DISTINCT c.id)::numeric / NULLIF(COUNT(DISTINCT p.id), 0)), 2) as engagement_rate,
    SUM(t.amount) as valor_movimentado,
    CASE 
        WHEN SUM(t.amount) > 2000 THEN 'Alto'
        WHEN SUM(t.amount) > 1000 THEN 'Médio'
        ELSE 'Baixo'
    END as categoria_desempenho
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
LEFT JOIN comments c ON p.id = c.post_id
LEFT JOIN transactions t ON u.id = t.user_id
GROUP BY u.id, u.full_name
ORDER BY valor_movimentado DESC NULLS LAST;

-- Resultado esperado: Comparativo de performance

