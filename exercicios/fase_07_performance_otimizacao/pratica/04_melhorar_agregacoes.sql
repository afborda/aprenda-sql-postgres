-- Fase 7: Performance e Otimização
-- Exercício 4: Melhorar Performance de Agregações
--
-- Objetivo: Otimizar queries com GROUP BY e agregações pesadas
--
-- Cenário: Relatório de vendas por região e período
-- Este tipo de query é comum e pode ser muito lenta com dados grandes

-- ❌ Versão 1: Sem otimização
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

-- 📋 Questões para análise:
-- Q1: Qual agregação é a mais cara?
-- Q2: O GROUP BY usa Hash Aggregate ou Sort Aggregate?
-- Q3: Quantas linhas intermediárias são processadas?
-- Q4: Como você melhoraria esta query?

-- 💡 Dica: Às vezes a melhor otimização é usar uma view materializada!

-- ✅ Versão 2: Usando Materialized View
-- CREATE MATERIALIZED VIEW mv_vendas_por_regiao AS
-- SELECT 
--   u.state as regiao,
--   DATE_TRUNC('month', t.created_at)::DATE as mes,
--   COUNT(*) as total_transacoes,
--   SUM(t.amount) as volume_total,
--   AVG(t.amount) as valor_medio
-- FROM users u
-- JOIN transactions t ON u.id = t.user_id
-- GROUP BY u.state, DATE_TRUNC('month', t.created_at);
-- 
-- CREATE INDEX idx_mv_vendas_regiao_mes ON mv_vendas_por_regiao(regiao, mes DESC);
-- 
-- -- Depois consultar é muito rápido:
-- SELECT * FROM mv_vendas_por_regiao ORDER BY regiao, mes DESC;

-- 📋 Sua tarefa:
-- 1. Analise o plano da Versão 1
-- 2. Identifique a operação mais cara
-- 3. Implemente a Versão 2 (view materializada)
-- 4. Compare as performances
-- 5. Qual versão você usaria em produção? Por quê?
