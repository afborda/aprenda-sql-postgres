-- Fase 9 - SOLUÇÃO: Exercícios 5 e 6

-- ✅ EXERCÍCIO 5: Deadlock - SOLUÇÃO

-- Regra fundamental:
-- Se transação A adquire locks em ordem [1, 2]
-- Todas as transações devem adquirir em ordem [1, 2, 3, ...]
-- Nunca inverter a ordem!

BEGIN;
  SELECT * FROM users WHERE id = 1 FOR UPDATE;  -- Sempre primeiro
  SELECT * FROM users WHERE id = 2 FOR UPDATE;  -- Sempre segundo
  SELECT * FROM users WHERE id = 3 FOR UPDATE;  -- Sempre terceiro
COMMIT;

-- ✅ EXERCÍCIO 6: Transferência Bancária Segura

CREATE OR REPLACE FUNCTION safe_transfer(
  sender_id INT,
  receiver_id INT,
  amount NUMERIC,
  OUT success BOOLEAN,
  OUT message TEXT
) AS $$
BEGIN
  -- Garantir ordem: sempre menor ID primeiro
  -- Evita deadlock ao ordem ser consistente
  
  BEGIN
    IF sender_id = receiver_id THEN
      success := false;
      message := 'Não é possível transferir para si mesmo';
      RETURN;
    END IF;
    
    IF amount <= 0 THEN
      success := false;
      message := 'Valor deve ser positivo';
      RETURN;
    END IF;
    
    -- Adquirir locks em ordem consistente
    IF sender_id < receiver_id THEN
      PERFORM 1 FROM user_accounts WHERE user_id = sender_id FOR UPDATE;
      PERFORM 1 FROM user_accounts WHERE user_id = receiver_id FOR UPDATE;
    ELSE
      PERFORM 1 FROM user_accounts WHERE user_id = receiver_id FOR UPDATE;
      PERFORM 1 FROM user_accounts WHERE user_id = sender_id FOR UPDATE;
    END IF;
    
    -- Validar saldo
    IF (SELECT balance FROM user_accounts WHERE user_id = sender_id) < amount THEN
      success := false;
      message := 'Saldo insuficiente';
      RETURN;
    END IF;
    
    -- Efetuar transferência
    UPDATE user_accounts SET balance = balance - amount WHERE user_id = sender_id;
    UPDATE user_accounts SET balance = balance + amount WHERE user_id = receiver_id;
    
    success := true;
    message := 'Transferência realizada com sucesso';
    
  EXCEPTION WHEN OTHERS THEN
    success := false;
    message := SQLERRM;
  END;
END;
$$ LANGUAGE plpgsql;

-- Teste:
-- SELECT * FROM safe_transfer(1, 2, 100);
-- SELECT * FROM safe_transfer(2, 1, 50);  -- Ordem diferente, sem deadlock
