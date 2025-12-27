-- Fase 10 - SOLUÇÕES e Desafios compilados

-- ✅ SOLUÇÕES: Exercícios 1-6

-- Exercício 1: Procedure Básica - SOLUÇÃO
CREATE OR REPLACE FUNCTION get_user(p_id INT)
RETURNS TABLE(id INT, name VARCHAR, email VARCHAR) AS $$
BEGIN
  RETURN QUERY SELECT u.id, u.full_name, u.email FROM users u WHERE u.id = p_id;
END;
$$ LANGUAGE plpgsql;

-- Exercício 2: Loops - SOLUÇÃO
CREATE OR REPLACE FUNCTION count_large_transactions(p_user_id INT)
RETURNS INT AS $$
DECLARE
  v_count INT := 0;
BEGIN
  FOR v_trans IN SELECT * FROM transactions WHERE user_id = p_user_id LOOP
    IF v_trans.amount > 1000 THEN
      v_count := v_count + 1;
    END IF;
  END LOOP;
  RETURN v_count;
END;
$$ LANGUAGE plpgsql;

-- Exercício 3-6: Triggers - SOLUÇÕES

CREATE OR REPLACE FUNCTION log_changes()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO audit_log (tabela, operacao, usuario)
  VALUES (TG_TABLE_NAME, TG_OP, CURRENT_USER);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION validate_user_data()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.email NOT LIKE '%@%' THEN
    RAISE EXCEPTION 'Email inválido';
  END IF;
  IF LENGTH(COALESCE(NEW.cpf, '')) < 14 THEN
    RAISE EXCEPTION 'CPF inválido';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- DESAFIOS: Fase 10

-- DESAFIO 1: Procedure com Múltiplos Outputs
-- CREATE OR REPLACE FUNCTION analyze_user(p_id INT)
-- RETURNS TABLE (total_trans INT, volume_total NUMERIC, email VARCHAR)

-- DESAFIO 2: Trigger para Updated_at
-- Atualizar timestamp automaticamente em cada UPDATE

-- DESAFIO 3: Cascade Deletes com Triggers
-- Deletar dados relacionados automaticamente

-- DESAFIO 4: Validação Complexa em Trigger
-- Validar CPF, Email, e regras de negócio

-- DESAFIO 5: Performance de Triggers
-- Otimizar triggers para alta frequência

-- DESAFIO 6: Auditoria Completa
-- Sistema de auditoria com versioning
