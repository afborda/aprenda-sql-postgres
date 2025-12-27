-- Fase 9: Transactions e Locks
-- Exercício 3: Locks Implícitos
--
-- Objetivo: Entender como PostgreSQL automaticamente adquire locks
--
-- Cenário: Operações causam locks automaticamente

-- ✅ Teste 1: SELECT não toma lock exclusivo
BEGIN;
  SELECT * FROM transactions WHERE user_id = 1 LIMIT 5;
  -- Apenas lock compartilhado (shared)
  -- Outras transações podem ler também
COMMIT;

-- ✅ Teste 2: UPDATE toma lock exclusivo
BEGIN;
  UPDATE transactions SET amount = 1000 WHERE id = 1;
  -- Lock exclusivo nesta linha
  -- Outras transações não podem acessar
COMMIT;

-- ✅ Teste 3: DELETE toma lock exclusivo
BEGIN;
  DELETE FROM transactions WHERE id = 2;
  -- Lock exclusivo nesta linha
COMMIT;

-- ✅ Teste 4: INSERT toma lock exclusivo
BEGIN;
  INSERT INTO transactions (user_id, amount, location_state)
  VALUES (1, 500, 'SP');
  -- Lock exclusivo na nova linha
COMMIT;

-- 📋 Questões:
-- Q1: SELECT sempre toma lock?
--     (Sim, shared lock)
-- Q2: Pode ter deadlock com SELECTs?
--     (Não, locks compartilhados não causam deadlock)
-- Q3: UPDATE bloqueia SELECTs?
--     (Depende do nível de isolamento, mas geralmente não completamente)
-- Q4: Como saber que linha está com lock?
--     (Ver com pg_stat_activity)
