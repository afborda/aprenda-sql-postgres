-- Fase 8: Índices Avançados
-- Exercício 2: Índices Compostos (Multi-Coluna)
--
-- Objetivo: Entender como indexar múltiplas colunas eficientemente
--
-- Cenário: Query que sempre filtra por user_id E ordena por created_at
-- Um índice composto é muito mais eficiente que dois índices separados!

-- ❌ Versão 1: Sem índices
EXPLAIN ANALYZE
SELECT id, amount, created_at 
FROM transactions 
WHERE user_id = 123
ORDER BY created_at DESC
LIMIT 50;

-- ✅ Versão 2: Dois índices separados
CREATE INDEX IF NOT EXISTS idx_transactions_user_id 
ON transactions(user_id);

CREATE INDEX IF NOT EXISTS idx_transactions_created_at_desc 
ON transactions(created_at DESC);

EXPLAIN ANALYZE
SELECT id, amount, created_at 
FROM transactions 
WHERE user_id = 123
ORDER BY created_at DESC
LIMIT 50;

-- ✅ Versão 3: Um índice composto (MUITO MELHOR!)
-- DROP INDEX IF EXISTS idx_transactions_user_id, idx_transactions_created_at_desc;

CREATE INDEX IF NOT EXISTS idx_transactions_user_created 
ON transactions(user_id, created_at DESC);

EXPLAIN ANALYZE
SELECT id, amount, created_at 
FROM transactions 
WHERE user_id = 123
ORDER BY created_at DESC
LIMIT 50;

-- 📋 Questões:
-- Q1: Qual versão tem menor custo?
-- Q2: Por que o índice composto é melhor?
-- Q3: Importa a ordem das colunas no índice composto?
-- Q4: Se a query filtrar por created_at E ordenar por user_id,
--     o índice ainda funcionaria bem?

-- 💡 Dica: Ordem no índice composto importa!
-- CREATE INDEX idx_... ON tabela(coluna_WHERE, coluna_ORDER_BY DESC)
