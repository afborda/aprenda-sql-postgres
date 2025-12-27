-- Fase 7: Performance e Otimização
-- SOLUÇÃO: Exercício 1 - Analisar Plano de Execução Básico
--
-- Esta é a query com análise detalhada

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

-- 📊 ANÁLISE DA SAÍDA:
--
-- A saída típica será algo como:
-- 
-- Limit  (cost=0.00..0.50 rows=10 width=...)
--   ->  Sort  (cost=..cost..|rows|width)
--         ->  HashAggregate  (cost=...|rows|width)
--               ->  Hash Left Join  (cost=...|rows|width)
--
-- INTERPRETAÇÃO:
--
-- 1. LIMIT é a operação externa
--    - Custo: 0.00..0.50 (muito baixo porque só retorna 10 linhas)
--    - rows: 10
--
-- 2. SORT vem depois
--    - Ordena por total_transacoes DESC
--    - Se não houvesse ORDER BY, seria mais rápido
--
-- 3. HashAggregate é onde acontece o GROUP BY
--    - Agrupa por u.id, u.full_name
--    - Calcula COUNT(t.id)
--    - Este é geralmente a operação mais cara
--
-- 4. Hash Left Join combina as tabelas
--    - users (tabela direita, precisa ser construída em hash)
--    - transactions (tabela esquerda, stream)
--    - Custo depende se há índice em transactions.user_id

-- 📋 RESPOSTAS:
--
-- Q1: Qual é o custo total estimado?
-- A: Varia com volume de dados, mas tipicamente 1000-5000 unidades
--
-- Q2: Há algum "Seq Scan"? Em qual tabela?
-- A: Provavelmente em ambas (users e transactions) sem índices apropriados
--    Com índices, pode ser Index Scan
--
-- Q3: Qual operação consome mais recurso?
-- A: HashAggregate geralmente, depois Hash Left Join
--
-- Q4: ORDER BY e LIMIT estão otimizados?
-- A: LIMIT reduz significativamente o custo (apenas 10 linhas retornadas)
--    ORDER BY acontece antes (mais caro), mas necessário
--
-- Q5: Se tivesse índice em transactions(user_id), seria usado?
-- A: SIM! O plano mudaria para Index Scan em vez de Seq Scan

-- 🎯 MELHORIA COM ÍNDICE:

-- Criar índice
CREATE INDEX IF NOT EXISTS idx_transactions_user_id 
ON transactions(user_id);

-- Executar novamente com EXPLAIN ANALYZE
-- O plano deve mostrar "Index Scan" em vez de "Seq Scan"
-- O custo total deve ser menor
