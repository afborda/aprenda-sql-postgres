-- Fase 9 - SOLUÇÃO: Exercícios 3-6 (compilados)

-- ✅ EXERCÍCIO 3: Locks Implícitos - SOLUÇÃO
-- SELECT = shared lock
-- UPDATE = exclusive lock
-- DELETE = exclusive lock
-- INSERT = exclusive lock

-- ✅ EXERCÍCIO 4: Locks Explícitos - SOLUÇÃO
-- FOR UPDATE NOWAIT = exclusivo, erro se bloqueado
-- FOR UPDATE SKIP LOCKED = exclusivo, ignora bloqueados
-- FOR SHARE = compartilhado

BEGIN;
  SELECT * FROM transactions 
  WHERE user_id = 1 
  FOR UPDATE NOWAIT;
COMMIT;

-- ✅ EXERCÍCIO 5: Deadlock - SOLUÇÃO
-- Causa: Ordem diferente de locks
-- Solução: SEMPRE mesma ordem

-- Regra ouro: Se precisa de locks A e B, SEMPRE:
-- LOCK A primeiro, depois B
-- Em todas as transações

-- ✅ EXERCÍCIO 6: Transferência - SOLUÇÃO

DECLARE
  v_saldo_origem NUMERIC;
BEGIN
  BEGIN
    SELECT balance INTO v_saldo_origem 
    FROM user_accounts 
    WHERE user_id = 1 
    FOR UPDATE;
    
    IF v_saldo_origem < 100 THEN
      RAISE EXCEPTION 'Saldo insuficiente';
    END IF;
    
    UPDATE user_accounts SET balance = balance - 100 WHERE user_id = 1;
    UPDATE user_accounts SET balance = balance + 100 WHERE user_id = 2;
    
    INSERT INTO audit_log (user_id, action, details)
    VALUES (1, 'TRANSFER', '100 para user 2');
  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'Erro na transferência: %', SQLERRM;
  END;
END;
