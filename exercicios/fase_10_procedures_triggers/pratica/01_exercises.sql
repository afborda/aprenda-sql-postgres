-- Fase 10: Stored Procedures e Triggers
-- Exercícios 1-6 (compilados)

-- ✅ EXERCÍCIO 1: Procedure Básica

CREATE OR REPLACE FUNCTION obter_usuario_por_id(p_id INT)
RETURNS TABLE(id INT, nome VARCHAR, email VARCHAR) AS $$
BEGIN
  RETURN QUERY SELECT u.id, u.full_name, u.email FROM users u WHERE u.id = p_id;
END;
$$ LANGUAGE plpgsql;

-- SELECT * FROM obter_usuario_por_id(1);

-- ✅ EXERCÍCIO 2: Loops e Condicionais

CREATE OR REPLACE FUNCTION contar_transacoes(p_user_id INT)
RETURNS INT AS $$
DECLARE
  v_count INT := 0;
  v_row RECORD;
BEGIN
  FOR v_row IN SELECT * FROM transactions WHERE user_id = p_user_id LOOP
    IF v_row.amount > 1000 THEN
      v_count := v_count + 1;
    END IF;
  END LOOP;
  RETURN v_count;
END;
$$ LANGUAGE plpgsql;

-- ✅ EXERCÍCIO 3: Trigger de Auditoria

CREATE TABLE audit_log (
  id SERIAL PRIMARY KEY,
  tabela VARCHAR,
  operacao VARCHAR,
  usuario VARCHAR,
  criado_em TIMESTAMP DEFAULT NOW()
);

CREATE OR REPLACE FUNCTION audit_trigger()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO audit_log (tabela, operacao, usuario)
  VALUES (TG_TABLE_NAME, TG_OP, CURRENT_USER);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER users_audit AFTER INSERT OR UPDATE ON users
FOR EACH ROW EXECUTE FUNCTION audit_trigger();

-- ✅ EXERCÍCIO 4: Trigger BEFORE para Validação

CREATE OR REPLACE FUNCTION validar_email()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.email NOT LIKE '%@%' THEN
    RAISE EXCEPTION 'Email inválido';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_email BEFORE INSERT OR UPDATE ON users
FOR EACH ROW EXECUTE FUNCTION validar_email();

-- ✅ EXERCÍCIO 5: Trigger com Transaction

CREATE OR REPLACE FUNCTION atualizar_transacao()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE users SET updated_at = NOW() WHERE id = NEW.user_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER transaction_update AFTER INSERT ON transactions
FOR EACH ROW EXECUTE FUNCTION atualizar_transacao();

-- ✅ EXERCÍCIO 6: Caso de Estudo Completo

CREATE OR REPLACE FUNCTION registrar_transacao(
  p_user_id INT,
  p_amount NUMERIC,
  p_location_state VARCHAR
)
RETURNS TABLE(sucesso BOOLEAN, mensagem VARCHAR) AS $$
BEGIN
  BEGIN
    IF p_amount <= 0 THEN
      RETURN QUERY SELECT false, 'Valor deve ser positivo';
      RETURN;
    END IF;
    
    INSERT INTO transactions (user_id, amount, location_state)
    VALUES (p_user_id, p_amount, p_location_state);
    
    INSERT INTO audit_log (tabela, operacao, usuario)
    VALUES ('transactions', 'INSERT', CURRENT_USER);
    
    RETURN QUERY SELECT true, 'Transação registrada';
  EXCEPTION WHEN OTHERS THEN
    RETURN QUERY SELECT false, SQLERRM;
  END;
END;
$$ LANGUAGE plpgsql;
