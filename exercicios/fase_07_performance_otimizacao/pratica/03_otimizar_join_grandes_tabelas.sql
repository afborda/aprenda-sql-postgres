-- Fase 7: Performance e Otimização
-- Exercício 3: Otimizar JOIN Entre Grandes Tabelas
--
-- Objetivo: Comparar diferentes estratégias de JOIN e suas performances
--
-- Cenário: Análise de transações com detalhes de usuário e fraude
-- Este JOIN conecta 3 tabelas com potencial para muitas linhas

-- ❌ Versão 1: JOIN Ineficiente (sem índices apropriados)
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

-- ✅ Versão 2: COM índices apropriados
-- Antes de executar, crie estes índices:
-- CREATE INDEX idx_users_state ON users(state);
-- CREATE INDEX idx_transactions_user_id ON transactions(user_id);
-- CREATE INDEX idx_fraud_transaction_id ON fraud_data(transaction_id);

-- Depois execute novamente acima com EXPLAIN ANALYZE

-- 📋 Sua tarefa:
-- 1. Execute versão 1 com EXPLAIN ANALYZE
-- 2. Anote o tempo de execução e tipo de JOIN (Hash Join? Nested Loop?)
-- 3. Crie os índices sugeridos
-- 4. Execute novamente
-- 5. Compare: 
--    - Qual versão é mais rápida?
--    - O tipo de JOIN mudou?
--    - Qual é o percentual de melhoria?

-- Questões importantes:
-- Q1: Qual é a diferença entre Hash Join e Nested Loop Join?
-- Q2: Por que os índices ajudaram?
-- Q3: O ORDER BY está sendo otimizado?
-- Q4: Há algum "Filter" desnecessário no plano?
