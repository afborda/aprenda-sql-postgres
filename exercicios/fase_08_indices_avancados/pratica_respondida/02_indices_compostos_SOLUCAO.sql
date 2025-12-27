-- Fase 8: Índices Avançados
-- SOLUÇÃO: Exercício 2 - Índices Compostos
--
-- Um índice composto é muito melhor que dois separados!

-- ✅ Criar índice composto (A SOLUÇÃO)
CREATE INDEX IF NOT EXISTS idx_transactions_user_created 
ON transactions(user_id, created_at DESC);

EXPLAIN ANALYZE
SELECT id, amount, created_at 
FROM transactions 
WHERE user_id = 123
ORDER BY created_at DESC
LIMIT 50;

-- EXPLICAÇÃO:
-- O índice (user_id, created_at DESC) é perfeito para esta query:
-- 1. Filtra por user_id (primeira coluna do índice)
-- 2. Retorna já ordenado por created_at DESC (segunda coluna)
-- 3. Aplica LIMIT 50 (apenas 50 linhas)
-- 
-- Resultado: Uma única passagem pelo índice!
-- Sem JOIN de índices, sem sort adicional

-- RESPOSTA:
-- Q1: Índice composto tem muito menor custo (uma passagem vs múltiplas)
-- Q2: Porque a primeira coluna filtra, a segunda ordena - muito eficiente!
-- Q3: SIM! Ordem importa MUITO.
--     CREATE INDEX idx_... ON tabela(coluna_WHERE, coluna_ORDER_BY DESC)
-- Q4: Não, não funcionaria bem. As colunas precisam estar na ordem correta.

-- 💡 RESUMO:
-- - Índice composto: muito mais eficiente
-- - Ordem importa: WHERE colunas primeiro, ORDER BY depois
-- - Redução típica: 100-1000x mais rápido
