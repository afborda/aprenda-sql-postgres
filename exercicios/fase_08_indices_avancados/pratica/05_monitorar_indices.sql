-- Fase 8: Índices Avançados
-- Exercício 5: Monitorar Índices - Encontrar Não Usados
--
-- Objetivo: Identificar e remover índices que não trazem benefício
--
-- Cenário: Banco de dados em produção com muitos índices
-- Alguns podem estar inativos e desperdiçando espaço/performance de escrita

-- 📊 Query para encontrar índices NÃO usados
SELECT 
  schemaname,
  tablename,
  indexname,
  idx_scan as total_scans,
  idx_tup_read as tuplas_lidas,
  idx_tup_fetch as tuplas_retornadas,
  pg_size_pretty(pg_relation_size(indexrelid)) as tamanho
FROM pg_stat_user_indexes
ORDER BY idx_scan ASC, pg_relation_size(indexrelid) DESC;

-- 📋 Questões:
-- Q1: Quais índices têm idx_scan = 0 (nunca foram usados)?
-- Q2: Qual é o maior índice não usado? Quanto espaço desperdiça?
-- Q3: Como você removeria um índice não usado?
-- Q4: Qual é o risco de remover um índice que acha que não usa?

-- 💡 Dica: Índices não usados:
-- - Desperdiçam espaço em disco
-- - Atrasam INSERT/UPDATE/DELETE (precisa atualizar índice)
-- - Devem ser removidos!

-- ✅ Como remover índice seguro
-- DROP INDEX IF EXISTS idx_name;

-- 📊 Bonus: Encontrar os MAIORES índices
SELECT 
  schemaname,
  tablename,
  indexname,
  pg_size_pretty(pg_relation_size(indexrelid)) as tamanho,
  idx_scan as scans
FROM pg_stat_user_indexes
ORDER BY pg_relation_size(indexrelid) DESC
LIMIT 10;

-- 📋 Questões:
-- Q1: Os maiores índices são os mais usados?
-- Q2: Se um índice é grande E não é usado, remove?
-- Q3: Como você equilibraria tamanho vs utilidade?
