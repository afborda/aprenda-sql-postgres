-- ==============================================
-- FASE 4: AGREGAÇÕES E RESUMOS
-- DESAFIOS CONTEXTUALIZADOS
-- ==============================================
-- 🎯 Cenário: Você é analista de dados da fintech

-- ==============================================
-- DESAFIO 1: Receita por Região
-- ==============================================
-- 📋 Contexto: CEO quer saber onde estão as maiores receitas
--
-- Sua tarefa:
-- - Retorne receita total por estado
-- - Mostre: state, receita_total, num_transacoes, ticket_medio
-- - Filtrar apenas estados com receita > R$ 2000
-- - Ordenar por receita_total DESC

SELECT 
    u.state,
    SUM(t.amount) as receita_total,
    COUNT(t.id) as num_transacoes,
    ROUND((SUM(t.amount)::numeric / COUNT(t.id)), 2) as ticket_medio
FROM users u
LEFT JOIN transactions t ON u.id = t.user_id
GROUP BY u.state
HAVING SUM(t.amount) > 2000
ORDER BY receita_total DESC;

-- ✅ Resposta esperada: Estados com receita significativa


-- ==============================================
-- DESAFIO 2: Segmentação de Usuários por Valor
-- ==============================================
-- 📋 Contexto: Marketing quer criar VIP tiers
--
-- Sua tarefa:
-- - Classifique usuários por valor gasto
-- - Colunas: full_name, total_gasto, categoria
--   - VIP: > R$ 2500
--   - Premium: R$ 1500-2500
--   - Regular: < R$ 1500
-- - Retorne contagem por categoria

WITH usuario_gastos AS (
    SELECT u.full_name, COALESCE(SUM(t.amount), 0) as total_gasto
    FROM users u
    LEFT JOIN transactions t ON u.id = t.user_id
    GROUP BY u.id, u.full_name
)
SELECT 
    CASE 
        WHEN total_gasto > 2500 THEN 'VIP'
        WHEN total_gasto >= 1500 THEN 'Premium'
        ELSE 'Regular'
    END as categoria,
    COUNT(*) as total_usuarios,
    ROUND(AVG(total_gasto)::numeric, 2) as gasto_medio
FROM usuario_gastos
GROUP BY categoria
ORDER BY gasto_medio DESC;

-- ✅ Resposta esperada: Distribuição por categoria


-- ==============================================
-- DESAFIO 3: Detecção de Contas Inativas
-- ==============================================
-- 📋 Contexto: Retenção quer identificar usuários que deixaram de usar
--
-- Sua tarefa:
-- - Encontre usuários com ZERO transações
-- - Mostre: full_name, created_at, dias_inativo
-- - Calcule dias desde criação

SELECT 
    u.full_name,
    u.created_at,
    DATE_PART('day', NOW() - u.created_at)::INT as dias_desde_criacao,
    CASE 
        WHEN DATE_PART('day', NOW() - u.created_at) > 30 THEN 'Crítico'
        WHEN DATE_PART('day', NOW() - u.created_at) > 7 THEN 'Atenção'
        ELSE 'Normal'
    END as status_atividade
FROM users u
LEFT JOIN transactions t ON u.id = t.user_id
GROUP BY u.id, u.full_name, u.created_at
HAVING COUNT(t.id) = 0
ORDER BY dias_desde_criacao DESC;

-- ✅ Resposta esperada: Usuários sem atividade


-- ==============================================
-- DESAFIO 4: Análise de Tipos de Transação
-- ==============================================
-- 📋 Contexto: Produto quer entender padrões de uso
--
-- Sua tarefa:
-- - Mostre distribuição por tipo
-- - Colunas: transaction_type, qtd, valor_total, valor_medio
-- - Calcule percentual de cada tipo

SELECT 
    transaction_type,
    COUNT(*) as qtd,
    SUM(amount) as valor_total,
    ROUND(AVG(amount)::numeric, 2) as valor_medio,
    ROUND((COUNT(*)::numeric / (SELECT COUNT(*) FROM transactions)) * 100, 2) as percentual
FROM transactions
GROUP BY transaction_type
ORDER BY valor_total DESC;

-- ✅ Resposta esperada: Mix de transações


-- ==============================================
-- DESAFIO 5: Usuários de Alto Risco
-- ==============================================
-- 📋 Contexto: Compliance quer monitorar suspeitos
--
-- Sua tarefa:
-- - Encontre usuários com fraudes confirmadas
-- - Mostre: full_name, num_fraudes, score_medio, status
-- - Apenas usuários com >= 1 fraude
-- - Categorize: "Crítico" (>=2 fraudes), "Monitorar" (<2)

SELECT 
    u.full_name,
    COUNT(DISTINCT fd.id) as num_fraudes,
    ROUND(AVG(fd.fraud_score)::numeric, 2) as score_medio,
    CASE 
        WHEN COUNT(DISTINCT fd.id) >= 2 THEN 'Crítico'
        ELSE 'Monitorar'
    END as status_risco
FROM users u
INNER JOIN fraud_data fd ON u.id = fd.user_id AND fd.is_fraud = TRUE
GROUP BY u.id, u.full_name
ORDER BY num_fraudes DESC;

-- ✅ Resposta esperada: Usuários suspeitos


-- ==============================================
-- DESAFIO 6: Benchmark de Performance
-- ==============================================
-- 📋 Contexto: RH quer comparar performance média
--
-- Sua tarefa:
-- - Calcule média geral de todos os usuários
-- - Mostre: full_name, posts_vs_media, transacoes_vs_media, categoria
-- - Categoria: "Acima da Média", "Médio", "Abaixo da Média"

WITH metricas_geral AS (
    SELECT 
        AVG(COUNT(DISTINCT p.id)) OVER () as media_posts,
        AVG(SUM(t.amount)) OVER () as media_transacoes
    FROM users u
    LEFT JOIN posts p ON u.id = p.user_id
    LEFT JOIN transactions t ON u.id = t.user_id
    GROUP BY u.id
)
SELECT 
    u.full_name,
    COUNT(DISTINCT p.id) as total_posts,
    SUM(t.amount) as total_transacoes,
    CASE 
        WHEN COUNT(DISTINCT p.id) > (SELECT AVG(num_posts) FROM 
            (SELECT COUNT(DISTINCT p2.id) as num_posts FROM users u2 LEFT JOIN posts p2 ON u2.id = p2.user_id GROUP BY u2.id) sub) 
        THEN 'Acima da Média'
        WHEN COUNT(DISTINCT p.id) < 0.5 * (SELECT AVG(num_posts) FROM 
            (SELECT COUNT(DISTINCT p2.id) as num_posts FROM users u2 LEFT JOIN posts p2 ON u2.id = p2.user_id GROUP BY u2.id) sub)
        THEN 'Abaixo da Média'
        ELSE 'Médio'
    END as categoria_performance
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
LEFT JOIN transactions t ON u.id = t.user_id
GROUP BY u.id, u.full_name
ORDER BY total_posts DESC;

-- ✅ Resposta esperada: Ranking de performance

