-- Fase 7: Performance e Otimização
-- SOLUÇÃO: Exercício 4 - Melhorar Performance de Agregações
--
-- Demonstração de otimizações para agregações pesadas

-- 📊 Versão 1: Query original (sem otimizações)
EXPLAIN ANALYZE
SELECT 
  u.state as regiao,
  DATE_TRUNC('month', t.created_at)::DATE as mes,
  COUNT(*) as total_transacoes,
  SUM(t.amount) as volume_total,
  AVG(t.amount) as valor_medio,
  MIN(t.amount) as valor_minimo,
  MAX(t.amount) as valor_maximo
FROM users u
JOIN transactions t ON u.id = t.user_id
GROUP BY u.state, DATE_TRUNC('month', t.created_at)
ORDER BY regiao, mes DESC;

-- ✅ Versão 2: Com índices
CREATE INDEX IF NOT EXISTS idx_transactions_user_id 
ON transactions(user_id);

CREATE INDEX IF NOT EXISTS idx_transactions_created_at 
ON transactions(created_at DESC);

-- Executar novamente - deve ser mais rápido

-- ✅ Versão 3: Usando Materialized View (MELHOR PARA DASHBOARDS!)
-- 
-- Esta é a verdadeira solução para agregações pesadas que precisam
-- ser consultadas frequentemente (como dashboards)

-- Criar a view materializada
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_relatorio_vendas_regiao AS
SELECT 
  u.state as regiao,
  DATE_TRUNC('month', t.created_at)::DATE as mes,
  COUNT(*) as total_transacoes,
  SUM(t.amount) as volume_total,
  AVG(t.amount)::NUMERIC(10,2) as valor_medio,
  MIN(t.amount) as valor_minimo,
  MAX(t.amount) as valor_maximo
FROM users u
JOIN transactions t ON u.id = t.user_id
GROUP BY u.state, DATE_TRUNC('month', t.created_at);

-- Criar índice na view
CREATE INDEX IF NOT EXISTS idx_mv_vendas_regiao_mes 
ON mv_relatorio_vendas_regiao(regiao, mes DESC);

-- Agora a consulta é INSTANTÂNEA!
EXPLAIN ANALYZE
SELECT * FROM mv_relatorio_vendas_regiao 
ORDER BY regiao, mes DESC;

-- 📈 COMPARAÇÃO:
-- 
-- Versão 1 (query direta):     ~500-1000ms
-- Versão 2 (com índices):      ~200-400ms
-- Versão 3 (materialized view): ~1-5ms
--
-- A Versão 3 é ~100-1000x mais rápida!
-- 
-- Custo: Precisa atualizar a view periodicamente
-- (geralmente via cron job ou trigger)

-- 🔄 Como atualizar a view:
-- 
-- REFRESH MATERIALIZED VIEW mv_relatorio_vendas_regiao;
-- 
-- Se quiser sem bloquear leituras:
-- REFRESH MATERIALIZED VIEW CONCURRENTLY mv_relatorio_vendas_regiao;

-- 💡 Quando usar cada abordagem:
--
-- 1. Query direta (V1):
--    - Dados precisam estar sempre atualizados (tempo real)
--    - Consultas pouco frequentes
--
-- 2. Com índices (V2):
--    - Bom balanço de performance e atualização
--    - Dados podem ter alguns segundos de atraso aceitável
--
-- 3. Materialized View (V3):
--    - Dashboards que consultam frequentemente
--    - Relatórios que não precisam estar sempre atualizados
--    - Dados podem ter minutos de atraso
--    - Economia MASSIVA de CPU/I/O
