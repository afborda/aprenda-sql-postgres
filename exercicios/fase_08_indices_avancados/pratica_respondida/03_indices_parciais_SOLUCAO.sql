-- Fase 8: Índices Avançados
-- SOLUÇÃO: Exercício 3 - Índices Parciais
--
-- Índices parciais cobrem apenas linhas que satisfazem uma condição
-- Reduzem espaço em disco e podem ser mais rápidos!

-- ✅ Criar índice parcial
CREATE INDEX IF NOT EXISTS idx_transactions_fraud 
ON transactions(user_id) 
WHERE fraud_score > 0.8;

-- EXPLICAÇÃO:
-- Este índice cobre apenas ~500 registros (fraudes)
-- Não cobre 79.5k transações normais
-- Resultado: índice muito menor!

-- TESTES:

-- Query 1: Buscar fraudes de usuário (USA o índice!)
EXPLAIN ANALYZE
SELECT * FROM transactions 
WHERE user_id = 123 
AND fraud_score > 0.8;

-- Query 2: Buscar todas as transações (NÃO usa índice parcial)
EXPLAIN ANALYZE
SELECT * FROM transactions 
WHERE user_id = 123;

-- RESPOSTA:
-- Q1: Índice parcial é muito menor (só cobre fraudes)
-- Q2: Sim, funciona bem com WHERE user_id = 123? 
--     NÃO! Precisa da condição fraud_score > 0.8 na query
-- Q3: Sim, com ambas as condições (user_id E fraud_score > 0.8)
-- Q4: Índice parcial quando:
--     - Você sempre filtra por condição específica
--     - Dados são altamente desequilibrados (99% normais, 1% fraude)
--     - Espaço em disco é crítico

-- 💡 EXEMPLO REAL:
-- CREATE INDEX idx_posts_active ON posts(id) WHERE deleted_at IS NULL;
-- Não indexa posts deletados, economiza espaço, mais rápido para ativos

-- 💡 RESUMO:
-- - Índice parcial: economiza espaço
-- - Precisa que query tenha a condição de filtro
-- - Muito útil para dados altamente seletivos
