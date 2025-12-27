-- Fase 7: Performance e Otimização
-- SOLUÇÃO: Exercício 6 - Análise Completa de Query Lenta
--
-- Diagnóstico e otimização de um dashboard de fraude complexo

-- ✅ PASSO 1: Criar os índices necessários
CREATE INDEX IF NOT EXISTS idx_users_state 
ON users(state);

CREATE INDEX IF NOT EXISTS idx_users_city 
ON users(city);

CREATE INDEX IF NOT EXISTS idx_transactions_user_id 
ON transactions(user_id);

CREATE INDEX IF NOT EXISTS idx_transactions_created_at 
ON transactions(created_at DESC);

CREATE INDEX IF NOT EXISTS idx_transactions_amount 
ON transactions(amount);

CREATE INDEX IF NOT EXISTS idx_fraud_transaction_id 
ON fraud_data(transaction_id);

CREATE INDEX IF NOT EXISTS idx_fraud_score 
ON fraud_data(fraud_score);

-- ✅ PASSO 2: Versão otimizada da query
EXPLAIN ANALYZE
SELECT 
  u.state,
  u.city,
  COUNT(DISTINCT t.id) as total_transacoes,
  COUNT(DISTINCT CASE WHEN f.fraud_score > 0.8 THEN t.id END) as fraude_alta,
  COUNT(DISTINCT CASE WHEN f.fraud_score BETWEEN 0.6 AND 0.8 THEN t.id END) as fraude_media,
  SUM(CASE WHEN f.fraud_score > 0.8 THEN t.amount ELSE 0 END) as valor_fraude_alta,
  SUM(CASE WHEN f.fraud_score BETWEEN 0.6 AND 0.8 THEN t.amount ELSE 0 END) as valor_fraude_media,
  SUM(t.amount) as volume_total,
  ROUND(100.0 * COUNT(DISTINCT CASE WHEN f.fraud_score > 0.8 THEN t.id END) 
        / NULLIF(COUNT(DISTINCT t.id), 0), 2) as percentual_fraude_alta
FROM users u
JOIN transactions t ON u.id = t.user_id
LEFT JOIN fraud_data f ON t.id = f.transaction_id
WHERE t.created_at > CURRENT_DATE - INTERVAL '30 days'
  AND u.state IN ('SP', 'RJ', 'MG', 'BH', 'SC', 'RS')
GROUP BY u.state, u.city
HAVING COUNT(DISTINCT t.id) > 10
ORDER BY fraude_alta DESC, percentual_fraude_alta DESC;

-- ✅ PASSO 3: Versão com Materialized View (MELHOR!)
-- 
-- Para dashboards em tempo real, a melhor solução é uma view materializada
-- que é atualizada periodicamente (por exemplo, a cada 5-15 minutos)

CREATE MATERIALIZED VIEW IF NOT EXISTS mv_dashboard_fraude_regiao AS
SELECT 
  u.state,
  u.city,
  COUNT(DISTINCT t.id) as total_transacoes,
  COUNT(DISTINCT CASE WHEN f.fraud_score > 0.8 THEN t.id END) as fraude_alta,
  COUNT(DISTINCT CASE WHEN f.fraud_score BETWEEN 0.6 AND 0.8 THEN t.id END) as fraude_media,
  SUM(CASE WHEN f.fraud_score > 0.8 THEN t.amount ELSE 0 END)::NUMERIC(15,2) as valor_fraude_alta,
  SUM(CASE WHEN f.fraud_score BETWEEN 0.6 AND 0.8 THEN t.amount ELSE 0 END)::NUMERIC(15,2) as valor_fraude_media,
  SUM(t.amount)::NUMERIC(15,2) as volume_total,
  ROUND(100.0 * COUNT(DISTINCT CASE WHEN f.fraud_score > 0.8 THEN t.id END) 
        / NULLIF(COUNT(DISTINCT t.id), 0), 2) as percentual_fraude_alta,
  CURRENT_TIMESTAMP as last_updated
FROM users u
JOIN transactions t ON u.id = t.user_id
LEFT JOIN fraud_data f ON t.id = f.transaction_id
WHERE t.created_at > CURRENT_DATE - INTERVAL '30 days'
  AND u.state IN ('SP', 'RJ', 'MG', 'BH', 'SC', 'RS')
GROUP BY u.state, u.city
HAVING COUNT(DISTINCT t.id) > 10;

-- Criar índice na view para ainda mais performance
CREATE INDEX IF NOT EXISTS idx_mv_fraude_state_city 
ON mv_dashboard_fraude_regiao(state, city);

CREATE INDEX IF NOT EXISTS idx_mv_fraude_alta_desc 
ON mv_dashboard_fraude_regiao(fraude_alta DESC);

-- Agora a consulta ao dashboard é INSTANTÂNEA!
EXPLAIN ANALYZE
SELECT * FROM mv_dashboard_fraude_regiao
ORDER BY fraude_alta DESC, percentual_fraude_alta DESC;

-- ✅ PASSO 4: Criar função para atualizar a view
CREATE OR REPLACE FUNCTION refresh_fraude_views()
RETURNS void AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY mv_dashboard_fraude_regiao;
  -- CONCURRENTLY permite que outras queries leiam enquanto atualiza
END;
$$ LANGUAGE plpgsql;

-- Agendar atualização automática (exemplo com cron job externo):
-- */5 * * * * psql -d seu_banco -c "SELECT refresh_fraude_views();"

-- 📊 RESULTADOS ESPERADOS:
--
-- Query direta (sem otimizações):        ~2-5 segundos
-- Query com índices:                     ~500-1000ms
-- Query com Materialized View:           ~1-5ms (até 1000x mais rápida!)

-- 💡 APRENDIZADOS PRINCIPALES:
--
-- 1. Índices são essenciais (especialmente em JOINs e WHERE)
-- 2. Para dados que não precisam estar em tempo real: use views materializadas
-- 3. DISTINCT é caro - considere alternativas
-- 4. CASE dentro de agregações funciona mas pode ser lento
-- 5. Múltiplos JOINs + agregações = considere pré-calcular
--
-- 6. Trade-offs:
--    - Dashboard em tempo real: query + índices
--    - Dashboard que pode ter 5-15 min de atraso: materialized view
--    - Relatórios noturnos: query pesada sem limite de tempo

-- 🎯 PARA PRODUÇÃO:
--
-- 1. Começar com query otimizada + índices
-- 2. Se ainda for lenta, criar materialized view
-- 3. Agendar refresh automático (cron ou scheduler)
-- 4. Monitorar performance com pg_stat_statements
-- 5. Ajustar conforme necessário
