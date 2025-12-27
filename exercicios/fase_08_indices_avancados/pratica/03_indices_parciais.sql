-- Fase 8: Índices Avançados
-- Exercício 3: Índices Parciais
--
-- Objetivo: Criar índices que cobrem apenas ALGUMAS linhas
--
-- Cenário: A maioria das transações não é fraude
-- Indexar apenas fraudes economiza espaço e acelera buscas de fraude!

-- ❌ Versão 1: Índice normal (cobre todas as linhas)
CREATE INDEX IF NOT EXISTS idx_transactions_full 
ON transactions(user_id);

-- Tamanho: ??? bytes (cobre todos os 80k registros)

-- ✅ Versão 2: Índice parcial (cobre apenas fraudes)
CREATE INDEX IF NOT EXISTS idx_transactions_fraud 
ON transactions(user_id) 
WHERE fraud_score > 0.8;

-- Tamanho: bem menor! Cobre apenas ~500 registros

-- 📋 Questões:
-- Q1: Qual índice é menor em bytes?
-- Q2: Este índice parcial funcionaria bem para:
--     SELECT * FROM transactions WHERE user_id = 123?
--     (dica: precisa checar WHERE clause)
-- Q3: Ele funcionaria para:
--     SELECT * FROM transactions WHERE user_id = 123 AND fraud_score > 0.8?
-- Q4: Quando você criaria índice parcial vs normal?

-- 💡 Caso de uso: Índices parciais para dados com alta seletividade
-- Exemplo: deleted = false em tabela com soft deletes
-- CREATE INDEX idx_users_active ON users(id) WHERE deleted = FALSE;
