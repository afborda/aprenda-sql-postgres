-- Fase 9 - SOLUÇÃO: Exercício 6

-- ✅ EXERCÍCIO 6: Transferência Bancária com Validações Completas

-- Versão 1: Transaction simples
BEGIN;
  -- Validar saldo
  IF (SELECT balance FROM user_accounts WHERE user_id = 1) < 100 THEN
    ROLLBACK;
  END IF;
  
  -- Locks ordenados
  SELECT * FROM user_accounts WHERE user_id = 1 FOR UPDATE;
  SELECT * FROM user_accounts WHERE user_id = 2 FOR UPDATE;
  
  -- Transferência
  UPDATE user_accounts SET balance = balance - 100 WHERE user_id = 1;
  UPDATE user_accounts SET balance = balance + 100 WHERE user_id = 2;
  
  -- Log
  INSERT INTO audit_log (user_id, action, details)
  VALUES (1, 'TRANSFER_OUT', 'User 2, Value 100');
  
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    RAISE NOTICE 'Erro: %', SQLERRM;
END;

-- Versão 2: Com retry em caso de deadlock
DO $$
DECLARE
  v_retry INT := 0;
  v_max_retries INT := 3;
  v_success BOOLEAN := false;
BEGIN
  WHILE v_retry < v_max_retries AND NOT v_success LOOP
    BEGIN
      BEGIN
        -- Locks sempre na mesma ordem
        SELECT 1 FROM user_accounts WHERE user_id = 1 FOR UPDATE;
        SELECT 1 FROM user_accounts WHERE user_id = 2 FOR UPDATE;
        
        -- Transferência
        UPDATE user_accounts SET balance = balance - 100 WHERE user_id = 1;
        UPDATE user_accounts SET balance = balance + 100 WHERE user_id = 2;
        
        COMMIT;
        v_success := true;
        RAISE NOTICE 'Transferência bem-sucedida';
      EXCEPTION
        WHEN SERIALIZATION_FAILURE OR DEADLOCK_DETECTED THEN
          -- Retry com backoff exponencial
          RAISE NOTICE 'Deadlock, tentando novamente (tentativa %/%)', v_retry + 1, v_max_retries;
          PERFORM pg_sleep(POWER(2, v_retry) * 0.1);  -- 0.1s, 0.2s, 0.4s
          v_retry := v_retry + 1;
      END;
    END LOOP;
  
  IF NOT v_success THEN
    RAISE EXCEPTION 'Falha após % tentativas', v_max_retries;
  END IF;
END;
$$;
