-- Fase 9: Transactions e Locks
-- Exercício 5: Detectar e Evitar Deadlocks
--
-- Objetivo: Identificar deadlocks e implementar estratégias para evitar
--
-- Cenário: Duas transações disputando múltiplos locks

-- ✅ Cenário de Deadlock Potencial
-- (Você precisa rodar em 2 conexões simultâneas para ver deadlock)

-- CONEXÃO 1:
BEGIN;
  SELECT * FROM users WHERE id = 1 FOR UPDATE;
  -- Aguarda lock em user 2...
  SELECT * FROM users WHERE id = 2 FOR UPDATE;
COMMIT;

-- CONEXÃO 2 (ao mesmo tempo):
BEGIN;
  SELECT * FROM users WHERE id = 2 FOR UPDATE;
  -- Aguarda lock em user 1...
  SELECT * FROM users WHERE id = 1 FOR UPDATE;
COMMIT;

-- RESULTADO: DEADLOCK!
-- PostgreSQL aborta uma das transações

-- ✅ Solução: Sempre adquirir locks em ordem!

-- CONEXÃO 1 (CORRIGIDA):
BEGIN;
  SELECT * FROM users WHERE id = 1 FOR UPDATE;
  SELECT * FROM users WHERE id = 2 FOR UPDATE;
COMMIT;

-- CONEXÃO 2 (CORRIGIDA):
BEGIN;
  SELECT * FROM users WHERE id = 1 FOR UPDATE;  -- Mesma ordem!
  SELECT * FROM users WHERE id = 2 FOR UPDATE;
COMMIT;

-- Sem deadlock porque ordem é consistente!

-- 📋 Questões:
-- Q1: Por que deadlock acontece?
--     (Ciclagem: A aguarda B, B aguarda A)
// Q2: Como evitar?
--     (Sempre adquirir locks em ordem consistente)
-- Q3: PostgreSQL detecta automaticamente?
--     (Sim! E aborta uma transação)
-- Q4: Como tratar em aplicação?
--     (Implementar retry logic com exponential backoff)

-- 📊 Monitorar Deadlocks
SELECT 
  pid,
  usename,
  application_name,
  state,
  query,
  wait_event_type
FROM pg_stat_activity
WHERE wait_event_type IS NOT NULL;
