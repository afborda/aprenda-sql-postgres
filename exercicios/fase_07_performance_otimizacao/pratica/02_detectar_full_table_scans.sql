-- Fase 7: Performance e Otimização
-- Exercício 2: Detectar Full Table Scans
--
-- Objetivo: Identificar e otimizar queries que fazem varredura completa
--
-- Problema: Estas queries fazem Seq Scan (varredura sequencial)
-- Seu trabalho: Identificar por quê e sugerir otimizações
--
-- Query 1: Buscar transações de um usuário específico

EXPLAIN ANALYZE
SELECT t.id, t.amount, t.created_at
FROM transactions t
WHERE t.user_id = 5
LIMIT 100;

-- 📋 Questões:
-- Q1: Usa Seq Scan ou Index Scan?
-- Q2: Quantas linhas precisou verificar para retornar 100?
-- Q3: Crie um índice e execute novamente - qual é a diferença?

-- Query 2: Buscar fraudes por estado

EXPLAIN ANALYZE
SELECT 
  location_state,
  COUNT(*) as fraude_count
FROM transactions t
JOIN fraud_data f ON t.id = f.transaction_id
WHERE location_state IN ('SP', 'RJ', 'MG')
GROUP BY location_state;

-- 📋 Questões:
-- Q1: Quais índices seriam úteis aqui?
-- Q2: O JOIN está otimizado?
-- Q3: Qual operação consome mais tempo?

-- Sugestão de índices:
-- CREATE INDEX idx_transactions_user_id ON transactions(user_id);
-- CREATE INDEX idx_transactions_state ON transactions(location_state);
-- CREATE INDEX idx_fraud_transaction_id ON fraud_data(transaction_id);
