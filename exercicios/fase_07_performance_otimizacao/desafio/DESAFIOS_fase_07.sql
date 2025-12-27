-- Fase 7: Performance e Otimização
-- DESAFIOS - 6 Casos de Estudo Reais
--
-- Estes desafios são mais próximos de situações reais que você encontrará
-- em produção. Use EXPLAIN ANALYZE para diagnosticar e otimizar!

-- =============================================================================
-- DESAFIO 1: Detectar e Otimizar Consulta de Fraude com Múltiplos JOINs
-- =============================================================================
--
-- Uma query começou a ficar lenta após aumentar o volume de transações.
-- Seu trabalho: Otimizá-la para < 500ms
--
-- ANTES (versão lenta):
EXPLAIN ANALYZE
SELECT 
  f.id,
  f.transaction_id,
  f.fraud_score,
  t.amount,
  t.created_at,
  u.full_name,
  u.state,
  ua.account_number
FROM fraud_data f
JOIN transactions t ON f.transaction_id = t.id
JOIN users u ON t.user_id = u.id
JOIN user_accounts ua ON u.id = ua.user_id
WHERE f.fraud_score > 0.9
  AND t.created_at > CURRENT_DATE - INTERVAL '7 days'
ORDER BY f.fraud_score DESC;

-- ❓ Questões:
-- 1. Que índices você criaria?
-- 2. Qual é a operação mais cara?
-- 3. Quantas linhas intermediárias são processadas?
-- 4. Há múltiplos JOINs aninhados - como otimizá-los?

-- DICA: Índices em colunas de JOIN (ON) e WHERE são críticos!

-- =============================================================================
-- DESAFIO 2: Otimizar Relatório Mensal de Transações
-- =============================================================================
--
-- Um relatório que resume transações por estado está muito lento.
-- Precisa retornar em < 1 segundo para que o dashboard seja responsivo.
--
-- Query problemática:

EXPLAIN ANALYZE
SELECT 
  u.state,
  DATE_TRUNC('month', t.created_at)::DATE as mes,
  COUNT(*) as total_transacoes,
  COUNT(DISTINCT u.id) as usuarios_unicos,
  SUM(t.amount) as volume,
  AVG(t.amount) as valor_medio,
  PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY t.amount) as p95,
  COUNT(*) FILTER (WHERE t.amount > 10000) as transacoes_altas
FROM users u
JOIN transactions t ON u.id = t.user_id
GROUP BY u.state, DATE_TRUNC('month', t.created_at)
ORDER BY mes DESC, volume DESC;

-- ❓ Questões:
-- 1. Esta query é candidata para materialized view?
-- 2. Se sim, qual seria a estrutura?
-- 3. Como você atualizaria periodicamente?
-- 4. Quanto tempo economizaria?

-- DICA: Agregações pesadas + consultas frequentes = material view!

-- =============================================================================
-- DESAFIO 3: Benchmark - CTE vs Subconsulta vs Window Function
-- =============================================================================
--
-- Mesmo resultado, três abordagens. Qual é mais rápida?
-- Compare com EXPLAIN ANALYZE e timestamps!

-- Abordagem 1: CTE (Common Table Expression)
EXPLAIN ANALYZE
WITH usuarios_gastos AS (
  SELECT 
    user_id,
    SUM(amount) as total_gasto,
    COUNT(*) as num_transacoes
  FROM transactions
  WHERE created_at > CURRENT_DATE - INTERVAL '90 days'
  GROUP BY user_id
)
SELECT 
  u.full_name,
  ug.total_gasto,
  ug.num_transacoes,
  ROUND(ug.total_gasto / ug.num_transacoes, 2) as valor_medio
FROM users u
JOIN usuarios_gastos ug ON u.id = ug.user_id
WHERE ug.total_gasto > 5000
ORDER BY ug.total_gasto DESC;

-- Abordagem 2: Subconsulta
EXPLAIN ANALYZE
SELECT 
  u.full_name,
  ug.total_gasto,
  ug.num_transacoes,
  ROUND(ug.total_gasto / ug.num_transacoes, 2) as valor_medio
FROM users u
JOIN (
  SELECT 
    user_id,
    SUM(amount) as total_gasto,
    COUNT(*) as num_transacoes
  FROM transactions
  WHERE created_at > CURRENT_DATE - INTERVAL '90 days'
  GROUP BY user_id
) ug ON u.id = ug.user_id
WHERE ug.total_gasto > 5000
ORDER BY ug.total_gasto DESC;

-- Abordagem 3: Window Function
EXPLAIN ANALYZE
WITH usuario_stats AS (
  SELECT 
    user_id,
    SUM(amount) OVER (PARTITION BY user_id) as total_gasto,
    COUNT(*) OVER (PARTITION BY user_id) as num_transacoes
  FROM transactions
  WHERE created_at > CURRENT_DATE - INTERVAL '90 days'
)
SELECT DISTINCT
  u.full_name,
  us.total_gasto,
  us.num_transacoes,
  ROUND(us.total_gasto / us.num_transacoes, 2) as valor_medio
FROM users u
JOIN usuario_stats us ON u.id = us.user_id
WHERE us.total_gasto > 5000
ORDER BY us.total_gasto DESC;

-- ❓ Questões:
-- 1. Qual abordagem tem menor custo estimado?
-- 2. Qual produz menos linhas intermediárias?
-- 3. Qual você escolheria? Por quê?
-- 4. As diferenças são significativas?

-- DICA: Use \timing on no psql para medir tempo real!

-- =============================================================================
-- DESAFIO 4: Encontrar e Otimizar Queries Mais Lentas do Sistema
-- =============================================================================
--
-- Se tiver acesso a pg_stat_statements, use esta query para encontrar
-- as queries mais lentas do banco:

-- (Requer extensão: CREATE EXTENSION pg_stat_statements;)
-- 
-- SELECT 
--   query,
--   calls,
--   mean_exec_time::numeric(10,2) as avg_ms,
--   max_exec_time::numeric(10,2) as max_ms,
--   total_exec_time::numeric(15,2) as total_ms
-- FROM pg_stat_statements
-- WHERE query NOT LIKE '%pg_stat_statements%'
-- ORDER BY mean_exec_time DESC
-- LIMIT 10;

-- Seu trabalho:
-- 1. Identificar a query mais lenta
-- 2. Executar com EXPLAIN ANALYZE
-- 3. Diagnosticar o problema
-- 4. Aplicar otimizações (índices, rewrite, etc.)
-- 5. Medir melhoria

-- Para este exercício, vamos simular:
EXPLAIN ANALYZE
SELECT 
  u.state,
  COUNT(*) as count
FROM transactions t
JOIN users u ON u.id = t.user_id
WHERE EXTRACT(YEAR FROM t.created_at) = 2024
GROUP BY u.state;

-- ❓ Questões:
-- 1. Há algum problema óbvio nesta query?
-- 2. Como você a reescreveria?
-- 3. Qual seria o ganho?

-- DICA: EXTRACT(YEAR FROM ...) não pode usar índices facilmente!

-- =============================================================================
-- DESAFIO 5: Análise de Performance com Transações por Região
-- =============================================================================
--
-- Consulta complexa que analisa padrões de fraude por região e hora do dia

EXPLAIN ANALYZE
SELECT 
  u.state,
  EXTRACT(HOUR FROM t.created_at)::INT as hora_do_dia,
  COUNT(*) as total_trans,
  COUNT(DISTINCT CASE WHEN f.fraud_score > 0.8 THEN t.id END) as fraudes,
  SUM(t.amount) as volume,
  MAX(t.amount) as maior_valor,
  MIN(t.amount) as menor_valor,
  AVG(t.amount) as media,
  STDDEV(t.amount) as desvio_padrao
FROM transactions t
JOIN users u ON t.user_id = u.id
LEFT JOIN fraud_data f ON t.id = f.transaction_id
WHERE t.created_at > CURRENT_DATE - INTERVAL '30 days'
GROUP BY u.state, EXTRACT(HOUR FROM t.created_at)
HAVING COUNT(*) > 50
ORDER BY volume DESC;

-- ❓ Questões:
-- 1. Quantos índices você criaria?
-- 2. STDDEV é cara - vale a pena?
-- 3. LEFT JOIN sem filtro - isso é eficiente?
-- 4. Este seria candidato para materialized view?

-- DICA: Considere se realmente precisa de STDDEV para cada hora/estado!

-- =============================================================================
-- DESAFIO 6: Case de Estudo - Dashboard com múltiplas agregações
-- =============================================================================
--
-- Uma empresa de BI precisa de um dashboard que agregue muitas métricas.
-- Performance é crítica: deve retornar em < 2 segundos.

EXPLAIN ANALYZE
SELECT 
  u.state,
  COUNT(DISTINCT u.id) as usuarios,
  COUNT(DISTINCT t.id) as transacoes,
  SUM(t.amount) as volume,
  AVG(t.amount) as media,
  COUNT(*) FILTER (WHERE f.fraud_score > 0.9) as fraudes_altas,
  COUNT(*) FILTER (WHERE t.amount > 10000) as grandes_valores,
  COUNT(*) FILTER (WHERE t.created_at > CURRENT_DATE) as transacoes_hoje,
  MAX(t.created_at) as ultima_transacao,
  COUNT(DISTINCT ua.account_number) as contas_unicas
FROM users u
JOIN transactions t ON u.id = t.user_id
LEFT JOIN fraud_data f ON t.id = f.transaction_id
LEFT JOIN user_accounts ua ON u.id = ua.user_id
WHERE t.created_at > CURRENT_DATE - INTERVAL '90 days'
GROUP BY u.state
ORDER BY volume DESC;

-- ❓ Questões:
-- 1. Quantas agregações diferentes há?
-- 2. Quantos JOINs e qual é o impacto de cada um?
-- 3. Como você arquitetaria a solução para < 2s?
--    a) Índices + query otimizada?
--    b) Materialized view?
--    c) Particionamento dos dados?
--    d) Cache em aplicação (Redis)?
-- 4. Qual trade-off é aceitável (atualização vs speed)?

-- DICA: Múltiplas agregações pode ser otimizado com:
-- - Materialized view (precalculado)
-- - Particionamento por data
-- - Índices compostos bem planejados
-- - Às vezes, quebra em múltiplas views (menos agregações cada)

-- =============================================================================
-- 📝 RESUMO DOS DESAFIOS:
-- =============================================================================
--
-- 1. JOINs múltiplos → Índices em colunasFK
-- 2. Relatórios mensais → Materialized view
-- 3. CTE vs Subconsulta → Window function geralmente ganha
-- 4. Encontrar queries lentas → EXPLAIN ANALYZE é seu amigo
-- 5. Padrões complexos → Múltiplos índices + agregações bem-planejadas
-- 6. Dashboard produção → Materialized view + refresh agendado
--
-- 🎯 Meta: Usar EXPLAIN ANALYZE para entender o que o PostgreSQL está fazendo
-- e aplicar a otimização apropriada para cada caso!
