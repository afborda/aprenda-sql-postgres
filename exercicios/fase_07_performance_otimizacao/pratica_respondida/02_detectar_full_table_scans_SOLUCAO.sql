-- Fase 7: Performance e Otimização
-- SOLUÇÃO: Exercício 2 - Detectar Full Table Scans
--
-- Demonstração de como identificar e otimizar Seq Scans

-- 🔍 Query 1: Buscar transações de um usuário específico

-- ANTES: Sem índice
EXPLAIN ANALYZE
SELECT t.id, t.amount, t.created_at
FROM transactions t
WHERE t.user_id = 5
LIMIT 100;

-- DEPOIS: Com índice
CREATE INDEX IF NOT EXISTS idx_transactions_user_id 
ON transactions(user_id);

EXPLAIN ANALYZE
SELECT t.id, t.amount, t.created_at
FROM transactions t
WHERE t.user_id = 5
LIMIT 100;

-- ✅ ANÁLISE:
-- Q1: Antes usava Seq Scan, agora usa Index Scan
-- Q2: Antes precisava verificar ~80k linhas, agora apenas ~8 linhas (média por usuário)
-- Q3: Melhoria típica: 100-1000x mais rápido!

-- 🔍 Query 2: Buscar fraudes por estado

-- ANTES
EXPLAIN ANALYZE
SELECT 
  location_state,
  COUNT(*) as fraude_count
FROM transactions t
JOIN fraud_data f ON t.id = f.transaction_id
WHERE location_state IN ('SP', 'RJ', 'MG')
GROUP BY location_state;

-- DEPOIS: Criar índices apropriados
CREATE INDEX IF NOT EXISTS idx_transactions_state 
ON transactions(location_state);

CREATE INDEX IF NOT EXISTS idx_transactions_id 
ON transactions(id);

CREATE INDEX IF NOT EXISTS idx_fraud_transaction_id 
ON fraud_data(transaction_id);

-- Executar novamente
EXPLAIN ANALYZE
SELECT 
  location_state,
  COUNT(*) as fraude_count
FROM transactions t
JOIN fraud_data f ON t.id = f.transaction_id
WHERE location_state IN ('SP', 'RJ', 'MG')
GROUP BY location_state;

-- ✅ ANÁLISE:
-- - O plano deve usar Index Scan em vez de Seq Scan
-- - O JOIN deve ser mais rápido com índice em fraud_data(transaction_id)
-- - O WHERE deve filtrar mais rápido com índice em location_state

-- 💡 ESTRATÉGIA GERAL:
-- 1. Identifique colunas usadas em WHERE, JOIN ON, e GROUP BY
-- 2. Crie índices nessas colunas
-- 3. Use EXPLAIN ANALYZE para verificar se índices são usados
-- 4. Observe a redução de linhas processadas (rows)
