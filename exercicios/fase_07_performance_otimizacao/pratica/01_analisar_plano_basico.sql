-- Fase 7: Performance e Otimização
-- Exercício 1: Analisar Plano de Execução Básico
--
-- Objetivo: Ler EXPLAIN ANALYZE e entender como o PostgreSQL executa queries
--
-- Instruções:
-- 1. Execute a query com EXPLAIN ANALYZE
-- 2. Observe cada linha do plano
-- 3. Responda às questões abaixo
--
-- Query: Quantas transações cada usuário tem?

EXPLAIN ANALYZE
SELECT 
  u.id,
  u.full_name,
  COUNT(t.id) as total_transacoes
FROM users u
LEFT JOIN transactions t ON u.id = t.user_id
GROUP BY u.id, u.full_name
ORDER BY total_transacoes DESC
LIMIT 10;

-- 📋 Questões para análise:
-- Q1: Qual é o custo total estimado (cost)?
-- Q2: Há algum "Seq Scan"? Se sim, em qual tabela?
-- Q3: Qual operação consome mais recurso?
-- Q4: O ORDER BY e LIMIT estão sendo aplicados eficientemente?
-- Q5: Se tivesse um índice em transactions(user_id), seria usado?

-- Dica: Para comparar antes/depois, execute novamente após criar o índice:
-- CREATE INDEX idx_transactions_user_id ON transactions(user_id);
-- EXPLAIN ANALYZE SELECT ...
