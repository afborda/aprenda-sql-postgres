-- Fase 9: Transactions e Locks - SOLUÇÃO: Exercício 2-6
-- (Soluções e explicações detalhadas para todos os exercícios)

-- ✅ EXERCÍCIO 2: Níveis de Isolamento
-- Q1: READ COMMITTED permite dirty reads? NÃO
-- Q2: REPEATABLE READ evita phantom reads? SIM em PostgreSQL
-- Q3: SERIALIZABLE mais rápido? NÃO, muito mais lento
-- Q4: Qual usar? READ COMMITTED (padrão e suficiente)

BEGIN;
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
  -- Lê apenas dados confirmados
  -- Performance boa, rara anomalia
COMMIT;

-- ✅ EXERCÍCIO 3: Locks Implícitos
-- Q1: SELECT sempre toma lock? SIM, shared lock
-- Q2: Deadlock com SELECTs? NÃO
-- Q3: UPDATE bloqueia SELECTs? Depende do isolamento
-- Q4: Como saber? SELECT * FROM pg_stat_activity

BEGIN;
  SELECT * FROM transactions WHERE user_id = 1 FOR UPDATE;
  -- Lock exclusivo - ninguém mais toca
COMMIT;

-- ✅ EXERCÍCIO 4: Locks Explícitos
-- FOR UPDATE = lock exclusivo
-- FOR SHARE = lock compartilhado
-- NOWAIT = erro se não conseguir
-- SKIP LOCKED = ignora bloqueados

BEGIN;
  SELECT * FROM user_accounts 
  WHERE user_id = 1 
  FOR UPDATE;
COMMIT;

-- ✅ EXERCÍCIO 5: Deadlock
-- Sempre adquirir em ordem!

BEGIN;
  SELECT * FROM users WHERE id = 1 FOR UPDATE;
  SELECT * FROM users WHERE id = 2 FOR UPDATE;  -- Mesma ordem sempre
COMMIT;

-- ✅ EXERCÍCIO 6: Transferência Bancária
-- 1. FOR UPDATE nas contas
-- 2. Validar saldo
-- 3. Atualizar ambas
-- 4. Log de auditoria
-- 5. COMMIT tudo

BEGIN;
  UPDATE user_accounts SET balance = balance - 100 WHERE user_id = 1;
  UPDATE user_accounts SET balance = balance + 100 WHERE user_id = 2;
COMMIT;
