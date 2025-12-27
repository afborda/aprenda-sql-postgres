-- Fase 7: Performance e Otimização
-- SOLUÇÃO: Exercício 3 - Otimizar JOIN Entre Grandes Tabelas
--
-- Demonstração de otimização de JOINs

-- ✅ Passo 1: Criar índices necessários
CREATE INDEX IF NOT EXISTS idx_users_state 
ON users(state);

CREATE INDEX IF NOT EXISTS idx_transactions_user_id 
ON transactions(user_id);

CREATE INDEX IF NOT EXISTS idx_fraud_transaction_id 
ON fraud_data(transaction_id);

-- ✅ Passo 2: Executar query com EXPLAIN ANALYZE

EXPLAIN ANALYZE
SELECT 
  u.full_name,
  t.id,
  t.amount,
  COALESCE(f.fraud_score, 0) as risco
FROM users u
JOIN transactions t ON u.id = t.user_id
LEFT JOIN fraud_data f ON t.id = f.transaction_id
WHERE u.state = 'SP'
ORDER BY t.created_at DESC
LIMIT 1000;

-- 📊 ANÁLISE:
--
-- Antes dos índices:
-- - Seq Scan em users (varredura de 10k linhas)
-- - Seq Scan em transactions (varredura de 80k linhas)
-- - Seq Scan em fraud_data (varredura de 2k linhas)
-- - Total: muitas linhas intermediárias
--
-- Depois dos índices:
-- - Index Scan em users (apenas ~500 de SP)
-- - Nested Loop Join com Index Scan em transactions
-- - Hash Left Join com fraud_data
-- - Muito mais eficiente!

-- 🔧 Otimizações Aplicadas:
-- 1. Índice em WHERE (idx_users_state)
-- 2. Índice em JOIN ON (idx_transactions_user_id)
-- 3. Índice em LEFT JOIN ON (idx_fraud_transaction_id)

-- 💡 Quando diferentes tipos de JOIN aparecem:
-- 
-- - Hash Join: Bom quando uma tabela é muito maior
-- - Nested Loop: Bom quando há índice na tabela interna
-- - Merge Join: Bom quando ambas estão ordenadas
--
-- O PostgreSQL escolhe automaticamente baseado em custos!

-- ⚡ Dica Extra: Índice Composto
-- 
-- Se você sempre filtrar por state E fazer JOIN por user_id,
-- pode criar um índice composto (mais eficiente):
--
-- CREATE INDEX idx_users_state_id ON users(state, id);
--
-- Isso permite que uma única passagem de índice satisfaça 
-- tanto o WHERE quanto o JOIN ON!
