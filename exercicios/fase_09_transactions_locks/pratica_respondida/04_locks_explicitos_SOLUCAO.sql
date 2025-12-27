-- Fase 9 - SOLUÇÃO: Exercícios 4, 5, 6

-- ✅ EXERCÍCIO 4: FOR UPDATE, FOR SHARE, NOWAIT, SKIP LOCKED

BEGIN;
  -- FOR UPDATE = exclusivo
  SELECT * FROM user_accounts WHERE user_id = 1 FOR UPDATE;
  
  -- FOR SHARE = compartilhado
  SELECT * FROM user_accounts WHERE user_id = 2 FOR SHARE;
  
  -- NOWAIT = erro se bloqueado
  SELECT * FROM transactions WHERE user_id = 1 FOR UPDATE NOWAIT;
  
  -- SKIP LOCKED = ignora linhas bloqueadas
  SELECT * FROM transactions WHERE user_id IN (1,2) FOR UPDATE SKIP LOCKED;
COMMIT;

-- ✅ EXERCÍCIO 5: Evitar Deadlock
-- SEMPRE ORDENE OS LOCKS!

BEGIN;
  -- Regra: Sempre id = 1, depois id = 2
  SELECT * FROM users WHERE id = 1 FOR UPDATE;
  SELECT * FROM users WHERE id = 2 FOR UPDATE;
COMMIT;

-- ✅ EXERCÍCIO 6: Transferência com Validações

CREATE OR REPLACE FUNCTION transferir_saldo(
  p_user_origem INT,
  p_user_destino INT,
  p_amount NUMERIC
) RETURNS TABLE(sucesso BOOLEAN, mensagem TEXT) AS $$
BEGIN
  BEGIN
    -- Lock na origem
    PERFORM balance FROM user_accounts 
    WHERE user_id = p_user_origem 
    FOR UPDATE;
    
    -- Lock no destino
    PERFORM balance FROM user_accounts 
    WHERE user_id = p_user_destino 
    FOR UPDATE;
    
    -- Validar saldo
    IF (SELECT balance FROM user_accounts WHERE user_id = p_user_origem) < p_amount THEN
      RAISE EXCEPTION 'Saldo insuficiente';
    END IF;
    
    -- Efetuar transferência
    UPDATE user_accounts SET balance = balance - p_amount WHERE user_id = p_user_origem;
    UPDATE user_accounts SET balance = balance + p_amount WHERE user_id = p_user_destino;
    
    -- Log
    INSERT INTO audit_log (user_id, action, details)
    VALUES (p_user_origem, 'TRANSFER', FORMAT('%s para user %s', p_amount, p_user_destino));
    
    RETURN QUERY SELECT true, 'Transferência realizada com sucesso';
  EXCEPTION
    WHEN OTHERS THEN
      RETURN QUERY SELECT false, FORMAT('Erro: %s', SQLERRM);
  END;
END;
$$ LANGUAGE plpgsql;

-- Usar a função:
-- SELECT * FROM transferir_saldo(1, 2, 100);
