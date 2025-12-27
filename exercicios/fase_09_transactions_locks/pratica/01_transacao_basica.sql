-- Fase 9: Transactions e Locks
-- Exercício 1: Transação Básica - COMMIT e ROLLBACK
--
-- Objetivo: Entender como commits e rollbacks funcionam
--
-- Cenário: Simular criação e cancelamento de usuário

-- ✅ Exemplo 1: Transaction que é COMMITADA
BEGIN;
  INSERT INTO users (full_name, email, state, cpf)
  VALUES ('Test User', 'test@example.com', 'SP', '12345678901234');
COMMIT;
-- Usuário foi criado permanentemente!

-- ✅ Exemplo 2: Transaction que é ROLLBACK
BEGIN;
  INSERT INTO users (full_name, email, state, cpf)
  VALUES ('Test User 2', 'test2@example.com', 'RJ', '12345678901235');
ROLLBACK;
-- Usuário NÃO foi criado (voltou atrás)

-- ✅ Exemplo 3: Transaction com múltiplas operações
BEGIN;
  INSERT INTO users (full_name, email, state, cpf)
  VALUES ('João Silva', 'joao@example.com', 'SP', '12345678901236');
  
  INSERT INTO user_accounts (user_id, account_number)
  VALUES (LASTVAL(), 'ACC-001');
COMMIT;
-- Ambos são criados ou nenhum é criado (atomicidade!)

-- 📋 Questões:
-- Q1: Se você faz INSERT sem BEGIN, é uma transaction?
--     (Sim! Cada SQL isolada é uma transação por padrão)
-- Q2: Se ROLLBACK no meio, volta tudo?
--     (Sim! Volta até o último COMMIT)
-- Q3: Qual é a diferença de performance entre COMMIT e ROLLBACK?
--     (ROLLBACK é mais rápido, não precisa persistir)
-- Q4: Pode ter COMMIT sem BEGIN?
--     (Sim, cada SQL é transação implícita)
