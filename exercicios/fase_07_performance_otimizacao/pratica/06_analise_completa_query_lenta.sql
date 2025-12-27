-- Fase 7: Performance e Otimização
-- Exercício 6: Análise Completa de Query Lenta - Caso de Estudo
--
-- Objetivo: Fazer diagnóstico completo e otimizar uma query complexa
--
-- Cenário: Dashboard de fraude em tempo real
-- Requisito: Deve retornar resultado em < 1 segundo
-- Problema: Está muito lento!

-- 🚨 A Query Problemática
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
        / COUNT(DISTINCT t.id), 2) as percentual_fraude_alta
FROM users u
JOIN transactions t ON u.id = t.user_id
LEFT JOIN fraud_data f ON t.id = f.transaction_id
WHERE t.created_at > CURRENT_DATE - INTERVAL '30 days'
  AND u.state IN ('SP', 'RJ', 'MG', 'BH', 'SC', 'RS')
GROUP BY u.state, u.city
HAVING COUNT(DISTINCT t.id) > 10
ORDER BY fraude_alta DESC, percentual_fraude_alta DESC;

-- 📊 Tarefa de Diagnóstico:
-- 
-- 1. ANALISAR:
--    Q1: Qual é o custo total estimado?
--    Q2: Há múltiplos Seq Scans? Em quais tabelas?
--    Q3: Quantas linhas intermediárias são processadas?
--    Q4: Qual operação consome mais tempo?
--
-- 2. OTIMIZAR (crie estes índices):
--    CREATE INDEX idx_users_state ON users(state);
--    CREATE INDEX idx_transactions_user_id ON transactions(user_id);
--    CREATE INDEX idx_transactions_created_at ON transactions(created_at DESC);
--    CREATE INDEX idx_fraud_transaction_id ON fraud_data(transaction_id);
--    CREATE INDEX idx_fraud_score ON fraud_data(fraud_score);
--
-- 3. REFATORAR (considere):
--    - Usar DISTINCT ON em vez de DISTINCT dentro de CASE?
--    - Usar view materializada para dados do último mês?
--    - Dividir em múltiplas queries menores?
--
-- 4. COMPARAR:
--    - Qual foi a melhoria de performance?
--    - O plano de execução mudou?
--    - Quais índices foram realmente usados?
--
-- 5. REFLETIR:
--    - Esta query é boa para dashboard em tempo real?
--    - Qual seria a melhor arquitetura?
--    - Como você garantiria performance mesmo com 1M de registros?

-- 💡 Ideias de Melhoria:
-- - Criar uma tabela agregada (fact table) atualizada periodicamente
-- - Usar MATERIALIZED VIEW para precalcular valores
-- - Particionar a tabela transactions por data
-- - Usar índices compostos (multi-coluna)
-- - Considerar cache em aplicação (Redis)
