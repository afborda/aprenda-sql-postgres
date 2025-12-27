-- Fase 8: Índices Avançados
-- Exercício 6: Estratégia Completa de Índices para Produção
--
-- Objetivo: Planejar uma estratégia de índices para novo schema
--
-- Cenário: Você precisa otimizar uma aplicação que faz estas queries:
-- 1. Buscar transações de um usuário (com paginação)
-- 2. Buscar fraudes de uma região
-- 3. Relatório de vendas por estado e mês
-- 4. Análise de transações por período

-- ============================================================================
-- ANÁLISE INICIAL: Queries esperadas
-- ============================================================================

-- Query 1: Transações de um usuário (comum, alta frequência)
-- WHERE user_id = X ORDER BY created_at DESC LIMIT 50
EXPLAIN ANALYZE
SELECT id, amount, created_at, status
FROM transactions
WHERE user_id = 123
ORDER BY created_at DESC
LIMIT 50;

-- Query 2: Fraudes por região (comum)
-- WHERE location_state = X AND fraud_score > Y
EXPLAIN ANALYZE
SELECT id, user_id, amount, fraud_score
FROM transactions
WHERE location_state = 'SP' AND fraud_score > 0.8
ORDER BY fraud_score DESC;

-- Query 3: Relatório agregado (menos frequente, pesado)
-- GROUP BY com múltiplas agregações
EXPLAIN ANALYZE
SELECT 
  location_state,
  DATE_TRUNC('month', created_at)::DATE as mes,
  COUNT(*) as total,
  SUM(amount) as volume
FROM transactions
GROUP BY location_state, DATE_TRUNC('month', created_at)
ORDER BY mes DESC;

-- Query 4: Análise por período e usuário
-- JOIN + agregação
EXPLAIN ANALYZE
SELECT 
  u.state,
  COUNT(DISTINCT t.id) as transacoes,
  SUM(t.amount) as volume
FROM users u
JOIN transactions t ON u.id = t.user_id
WHERE t.created_at > CURRENT_DATE - INTERVAL '30 days'
GROUP BY u.state
ORDER BY volume DESC;

-- ============================================================================
-- 📋 ESTRATÉGIA DE ÍNDICES
-- ============================================================================
--
-- Baseado nas queries acima, qual seria sua estratégia?
-- 
-- Considere:
-- 1. Índices compostos vs separados
-- 2. Índices parciais para reduzir tamanho
-- 3. Ordem das colunas no índice
-- 4. Trade-off: leitura vs escrita
--
-- Escreva aqui sua estratégia:
--
-- Para Query 1: Índice em (user_id, created_at DESC)
--   CREATE INDEX idx_transactions_user_created ON transactions(user_id, created_at DESC);
--
-- Para Query 2: Índice em (location_state, fraud_score DESC)
--   CREATE INDEX idx_transactions_fraud_state ON transactions(location_state, fraud_score DESC);
--
-- Para Query 3: Sem índice específico? Ou materialized view?
--   - Esta é agregação pesada, provavelmente materialized view
--
-- Para Query 4: Índice em (user_id) já cobre, precisa de created_at também?
--   CREATE INDEX idx_transactions_user_date ON transactions(user_id, created_at);

-- ============================================================================
-- IMPLEMENTAÇÃO SUGERIDA
-- ============================================================================

-- Índices essenciais
CREATE INDEX IF NOT EXISTS idx_transactions_user_created 
ON transactions(user_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_transactions_fraud_state 
ON transactions(location_state, fraud_score DESC)
WHERE fraud_score > 0.5;  -- Índice parcial para fraudes

CREATE INDEX IF NOT EXISTS idx_users_state 
ON users(state);

-- Índices secundários (se performance ainda for inadequada)
CREATE INDEX IF NOT EXISTS idx_transactions_created_at 
ON transactions(created_at DESC)
WHERE amount > 1000;  -- Apenas transações significativas

-- ============================================================================
-- VALIDAÇÃO: Rodar queries novamente com índices
-- ============================================================================

EXPLAIN ANALYZE
SELECT id, amount, created_at, status
FROM transactions
WHERE user_id = 123
ORDER BY created_at DESC
LIMIT 50;

EXPLAIN ANALYZE
SELECT id, user_id, amount, fraud_score
FROM transactions
WHERE location_state = 'SP' AND fraud_score > 0.8
ORDER BY fraud_score DESC;

EXPLAIN ANALYZE
SELECT 
  u.state,
  COUNT(DISTINCT t.id) as transacoes,
  SUM(t.amount) as volume
FROM users u
JOIN transactions t ON u.id = t.user_id
WHERE t.created_at > CURRENT_DATE - INTERVAL '30 days'
GROUP BY u.state
ORDER BY volume DESC;

-- ============================================================================
-- 📊 ANÁLISE DE ÍNDICES
-- ============================================================================

-- Ver todos os índices criados
SELECT 
  schemaname,
  tablename,
  indexname,
  indexdef,
  pg_size_pretty(pg_relation_size(indexrelid)) as tamanho,
  idx_scan as scans
FROM pg_stat_user_indexes
WHERE schemaname = 'public'
ORDER BY pg_relation_size(indexrelid) DESC;

-- ============================================================================
-- 📋 QUESTÕES FINAIS
-- ============================================================================
--
-- Q1: Qual é o tamanho total dos índices?
-- Q2: Todos os índices estão sendo usados?
-- Q3: Há redundância (índices que fazem o mesmo)?
-- Q4: Se houvesse 10x mais dados, a estratégia mudaria?
-- Q5: Como você balancearia leitura (rápida) vs escrita (não tão lenta)?
--
-- 💡 Próximas melhorias:
-- - Monitorar query performance regularmente
-- - Remover índices não usados após 2 semanas
-- - Considerar materialized view para agregações pesadas
-- - Particionar tabela transactions por data se crescer muito
