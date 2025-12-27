-- Fase 9: Transactions e Locks
-- SOLUÇÃO: Exercício 1 - Transação Básica
--
-- Explicação detalhada

-- ✅ RESPOSTA:
-- Q1: Se você faz INSERT sem BEGIN, é uma transaction?
-- SIM! Cada SQL é implicitamente envolvida em uma transação
-- PostgreSQL faz: BEGIN; INSERT ...; COMMIT;

-- Q2: Se ROLLBACK no meio, volta tudo?
-- SIM! Volta para o estado do último COMMIT

-- Q3: Qual é a diferença de performance?
-- ROLLBACK é geralmente mais rápido:
-- - COMMIT: Escreve em WAL (write-ahead log), persiste
-- - ROLLBACK: Apenas descarta mudanças em memória

-- Q4: Pode ter COMMIT sem BEGIN?
-- SIM! Porque cada SQL isolada já é uma transação implícita

-- ✅ EXEMPLO PRÁTICO:

-- Teste 1: Verificar comportamento implícito
INSERT INTO users (full_name, email, state, cpf) 
VALUES ('Implicit User', 'implicit@test.com', 'SP', '12345678901234');
-- Automaticamente fez COMMIT!

-- Teste 2: Desfazer com ROLLBACK
BEGIN;
  INSERT INTO users (full_name, email, state, cpf) 
  VALUES ('Rollback User', 'rollback@test.com', 'SP', '12345678901235');
  ROLLBACK;
-- Usuário NÃO foi criado

-- Teste 3: Confirmar com COMMIT
BEGIN;
  INSERT INTO users (full_name, email, state, cpf) 
  VALUES ('Commit User', 'commit@test.com', 'SP', '12345678901236');
  COMMIT;
-- Usuário FOI criado

SELECT COUNT(*) FROM users WHERE email LIKE '%test.com%';
-- Deve conter 2: 'Implicit User' e 'Commit User'
