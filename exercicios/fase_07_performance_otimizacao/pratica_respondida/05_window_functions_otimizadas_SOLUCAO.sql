-- Fase 7: Performance e Otimização
-- SOLUÇÃO: Exercício 5 - Window Functions Otimizadas
--
-- Demonstração de por que window functions são melhores que subconsultas correladas

-- ❌ Abordagem 1: Subconsulta Correlada (MUITO LENTA!)
EXPLAIN ANALYZE
SELECT 
  t1.user_id,
  t1.id,
  t1.amount,
  t1.created_at,
  (
    SELECT COUNT(*) + 1
    FROM transactions t2
    WHERE t2.user_id = t1.user_id
      AND t2.created_at > t1.created_at
  ) as ranking
FROM transactions t1
WHERE t1.created_at > CURRENT_DATE - INTERVAL '30 days'
ORDER BY t1.user_id, t1.created_at DESC
LIMIT 1000;

-- Velocidade: ~5-10 segundos
-- Por quê? A subconsulta executa para CADA linha!

-- ✅ Abordagem 2: Window Function (RÁPIDA!)
EXPLAIN ANALYZE
SELECT 
  user_id,
  id,
  amount,
  created_at,
  ROW_NUMBER() OVER (
    PARTITION BY user_id 
    ORDER BY created_at DESC
  ) as ranking
FROM transactions
WHERE created_at > CURRENT_DATE - INTERVAL '30 days'
ORDER BY user_id, ranking
LIMIT 1000;

-- Velocidade: ~50-100ms
-- Por quê? Uma única passagem pelos dados!

-- 📊 Resultado: Window function é 50-100x mais rápida!

-- ✅ Abordagem 3: Window function com múltiplas agregações
EXPLAIN ANALYZE
SELECT 
  user_id,
  id,
  amount,
  created_at,
  ROW_NUMBER() OVER (
    PARTITION BY user_id 
    ORDER BY created_at DESC
  ) as ranking,
  SUM(amount) OVER (
    PARTITION BY user_id 
    ORDER BY created_at DESC
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) as cumulative_amount,
  AVG(amount) OVER (
    PARTITION BY user_id
  ) as user_avg,
  MAX(amount) OVER (
    PARTITION BY user_id
  ) as user_max
FROM transactions
WHERE created_at > CURRENT_DATE - INTERVAL '30 days'
ORDER BY user_id, created_at DESC
LIMIT 1000;

-- Velocidade: ~100-150ms
-- 
-- Mesmo com múltiplas window functions, é muito mais rápido
-- porque tudo é feito em uma única passagem (WindowAgg)!

-- 📋 ANÁLISE DO PLANO:
--
-- Abordagem 1 (Subconsulta):
--   - Seq Scan on transactions t1
--   - Subplan (executa para cada linha!) 
--     - Seq Scan on transactions t2 (com filter)
--   - Result: N * M operações (muito caro!)
--
-- Abordagem 2 (Window):
--   - WindowAgg (uma passagem só!)
--   - Sort (para ORDER BY)
--   - Seq Scan on transactions
--   - Result: N operações (muito rápido!)

-- 🎯 REGRA DE OURO:
--
-- Nunca use subconsulta correlada quando puder usar window function!
-- Window functions são quase sempre mais rápidas.

-- 💡 Casos de uso de window functions:
--
-- - Ranking (ROW_NUMBER, RANK, DENSE_RANK)
-- - Somatórios cumulativos (SUM ... OVER ... ORDER BY)
-- - Médias móveis (AVG ... OVER ... ROWS/RANGE)
-- - Desvios padrão (STDDEV ... OVER)
-- - LAG/LEAD para comparar linhas adjacentes
-- - FIRST_VALUE/LAST_VALUE para limites
