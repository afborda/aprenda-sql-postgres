-- Fase 8: Índices Avançados
-- SOLUÇÃO: Exercício 5 - Monitorar Índices
--
-- Removem índices não usados economiza espaço e melhora performance!

-- ✅ Query para encontrar índices não usados
SELECT 
  schemaname,
  tablename,
  indexname,
  idx_scan as total_scans,
  pg_size_pretty(pg_relation_size(indexrelid)) as tamanho
FROM pg_stat_user_indexes
WHERE schemaname = 'public'
ORDER BY idx_scan ASC;

-- RESPOSTA:
-- Q1: Qualquer índice com idx_scan = 0 nunca foi usado
-- Q2: O maior índice não usado é desperdício de espaço
-- Q3: DROP INDEX IF EXISTS idx_name;
-- Q4: Risco: Se aplicação usar depois, query fica lenta
--     Solução: Monitorar por 1-2 semanas antes de remover

-- ✅ Ver os MAIORES índices
SELECT 
  schemaname,
  tablename,
  indexname,
  pg_size_pretty(pg_relation_size(indexrelid)) as tamanho,
  idx_scan as scans
FROM pg_stat_user_indexes
WHERE schemaname = 'public'
ORDER BY pg_relation_size(indexrelid) DESC;

-- RESPOSTA:
-- Q1: Não necessariamente! Grandes índices podem ser antigos
-- Q2: Sim, remove! Economiza espaço e acelera INSERTs
-- Q3: Balanço: guardar índices úteis, remover inúteis

-- 💡 ESTRATÉGIA DE MONITORAMENTO:
-- 1. Executar esta query mensalmente
-- 2. Marcar índices não usados
-- 3. Deixar em produção por 1-2 semanas
-- 4. Se ainda não foi usado, remover
-- 5. Ganho: menos espaço, INSERTs mais rápidos

-- ✅ Script para encontrar candidatos a remoção
SELECT 
  schemaname,
  tablename,
  indexname,
  pg_size_pretty(pg_relation_size(indexrelid)) as tamanho,
  idx_scan,
  CASE 
    WHEN idx_scan = 0 THEN 'REMOVER!'
    WHEN idx_scan < 10 THEN 'PODE REMOVER'
    ELSE 'MANTER'
  END as recomendacao
FROM pg_stat_user_indexes
WHERE schemaname = 'public'
ORDER BY idx_scan ASC;

-- 💡 RESUMO:
-- - Monitorar índices regularmente
-- - Remover não usados (economiza 5-30% de espaço!)
-- - Melhora performance de INSERTs
-- - Sempre fazer em horário de baixo uso
