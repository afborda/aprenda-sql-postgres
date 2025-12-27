-- Fase 8: Índices Avançados
-- SOLUÇÃO: Exercício 6 - Estratégia Completa de Índices
--
-- Plano detalhado de indexação para produção

-- ✅ ESTRATÉGIA PROPOSTA:

-- Para Query 1: Transações de usuário (alta frequência)
-- - Índice composto em (user_id, created_at DESC)
CREATE INDEX IF NOT EXISTS idx_transactions_user_created 
ON transactions(user_id, created_at DESC);

-- Para Query 2: Fraudes por região (comum)
-- - Índice composto em (location_state, fraud_score DESC)
-- - Índice parcial para economizar espaço
CREATE INDEX IF NOT EXISTS idx_transactions_fraud_state 
ON transactions(location_state, fraud_score DESC)
WHERE fraud_score > 0.5;

-- Para Query 3: Relatório agregado (pesado)
-- - Esta é agregação! Melhor solução: MATERIALIZED VIEW
-- - Não há "índice perfeito" para aggregations de múltiplas colunas
-- - Solução: pré-calcular e armazenar resultado

-- Para Query 4: Análise por período
-- - Já cobre com idx_transactions_user_created
-- - Se usar frequentemente, considerar adicionar created_at ao JOIN
CREATE INDEX IF NOT EXISTS idx_users_state 
ON users(state);

-- ============================================================================
-- VALIDAÇÃO DA ESTRATÉGIA
-- ============================================================================

-- Query 1: Deve usar idx_transactions_user_created
EXPLAIN ANALYZE
SELECT id, amount, created_at, status
FROM transactions
WHERE user_id = 123
ORDER BY created_at DESC
LIMIT 50;

-- Query 2: Deve usar idx_transactions_fraud_state
EXPLAIN ANALYZE
SELECT id, user_id, amount, fraud_score
FROM transactions
WHERE location_state = 'SP' AND fraud_score > 0.8
ORDER BY fraud_score DESC;

-- Query 4: Deve usar índices criados
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
-- ANÁLISE DOS ÍNDICES CRIADOS
-- ============================================================================

-- Ver estatísticas de todos os índices
SELECT 
  tablename,
  indexname,
  idx_scan as scans,
  idx_tup_read as tuplas_lidas,
  pg_size_pretty(pg_relation_size(indexrelid)) as tamanho
FROM pg_stat_user_indexes
WHERE tablename IN ('transactions', 'users')
ORDER BY pg_relation_size(indexrelid) DESC;

-- ============================================================================
-- RESPOSTA DAS QUESTÕES FINAIS
-- ============================================================================
--
-- Q1: Tamanho total dos índices
-- - idx_transactions_user_created: ~15-20 MB (maior)
-- - idx_transactions_fraud_state: ~2-3 MB (menor, parcial)
-- - idx_users_state: ~1 MB
-- Total: ~20-25 MB para banco com 80k transações (aceitável)
--
-- Q2: Todos os índices sendo usados?
-- - Sim, todos devem ter idx_scan > 0 após executar as queries
-- - Se algum ficar com idx_scan = 0, pode remover
--
-- Q3: Há redundância?
-- - idx_transactions_user_created cobre primeira parte de ambos
-- - idx_transactions_fraud_state cobre caso específico
-- - Complementares, não redundantes
--
-- Q4: Se 10x mais dados (800k transações)?
-- - Mesma estratégia funciona
-- - Índices crescem proporcionalmente
-- - Pode considerar BRIN para series temporais
-- - Particionamento por data se escala ainda mais
--
-- Q5: Balanceando leitura vs escrita?
-- - 3 índices compostos = INSERT/UPDATE ~3x mais lento
-- - Trade-off: lê rápido, escreve um pouco mais lento
-- - Aceitável para maioria das aplicações (lê > escreve)

-- ============================================================================
-- MELHORIAS FUTURAS
-- ============================================================================

-- Se Query 3 (agregação) rodar frequentemente:
-- CREATE MATERIALIZED VIEW mv_transacoes_por_regiao_mes AS
-- SELECT 
--   location_state,
--   DATE_TRUNC('month', created_at)::DATE as mes,
--   COUNT(*) as total,
--   SUM(amount) as volume
-- FROM transactions
-- GROUP BY location_state, DATE_TRUNC('month', created_at);

-- Se dados crescerem muito (> 10M registros):
-- - Particionar transactions por data
-- - Usar BRIN index para coluna created_at
-- - Arquivar dados antigos

-- 💡 CONCLUSÃO:
-- Estratégia equilibrada: poucos índices bem-escolhidos
-- Cobre 99% dos casos de uso
-- Bom balanço entre leitura/escrita
-- Fácil de manter em produção
