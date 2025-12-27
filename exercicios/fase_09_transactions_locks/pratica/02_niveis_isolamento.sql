-- Fase 9: Transactions e Locks
-- Exercício 2: Níveis de Isolamento
--
-- Objetivo: Entender diferenças entre READ COMMITTED e SERIALIZABLE
--
-- Cenário: Duas transações tentam ler/atualizar mesmo registro

-- ✅ Setup: Criar conta de teste
BEGIN;
  INSERT INTO user_accounts (user_id, account_number)
  VALUES (1, 'TEST-ISOLATION');
COMMIT;

-- 📊 Teste 1: READ COMMITTED (padrão)
BEGIN;
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
  SELECT * FROM user_accounts WHERE account_number = 'TEST-ISOLATION';
  -- Neste nível, se outra transação atualizar, você vê mudança depois
COMMIT;

-- 📊 Teste 2: REPEATABLE READ
BEGIN;
  SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
  SELECT * FROM user_accounts WHERE account_number = 'TEST-ISOLATION';
  -- Snapshot da transação - vê sempre mesma versão
COMMIT;

-- 📊 Teste 3: SERIALIZABLE
BEGIN;
  SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
  SELECT * FROM user_accounts WHERE account_number = 'TEST-ISOLATION';
  -- Mais restritivo - comporta como sequencial
COMMIT;

-- 📋 Questões:
-- Q1: READ COMMITTED permite dirty reads?
--     (Não, só lê dados confirmados)
-- Q2: REPEATABLE READ garante que não há phantom reads?
--     (Não totalmente, mas em PostgreSQL sim)
-- Q3: SERIALIZABLE é mais rápido que READ COMMITTED?
--     (Não! Muito mais lento por ser mais restritivo)
-- Q4: Qual nível usar em produção?
--     (READ COMMITTED é padrão e suficiente para maioria)
