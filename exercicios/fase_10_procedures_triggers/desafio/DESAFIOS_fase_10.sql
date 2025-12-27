-- Fase 10: Stored Procedures e Triggers - DESAFIOS

-- DESAFIO 1: Procedure com Múltiplos Outputs
-- ❓ Criar função que retorna análise completa de usuário

-- DESAFIO 2: Trigger para Updated_at Automático
-- Toda vez que UPDATE tabela, coluna updated_at muda automaticamente

-- DESAFIO 3: Cascade Delete com Trigger
-- Quando deletar usuário, deletar todas suas transações automaticamente
-- (Alternativa a Foreign Key CASCADE)

-- DESAFIO 4: Validação Complexa
-- Implementar regras de negócio em trigger:
-- - Email único (mas já pode ter constraint)
-- - CPF válido (algoritmo checksum)
-- - Saldo nunca negativo
-- - Valores de transação limites

-- DESAFIO 5: Performance de Triggers
-- Sistema recebe 1000 inserts/segundo
-- Trigger está lento (logging, auditoria)
-- Otimizar para não criar gargalo

-- DESAFIO 6: Auditoria com Versioning
-- Manter histórico completo de todas as mudanças
-- Poder restaurar para qualquer ponto no tempo
-- Quem fez a mudança (CURRENT_USER)
-- Quando (timestamp)
-- Antes/Depois dos dados

-- =============================================================================

-- Exemplo DESAFIO 1: Análise de Usuário

CREATE OR REPLACE FUNCTION analise_usuario(p_id INT)
RETURNS TABLE(
  user_id INT,
  nome VARCHAR,
  total_transacoes INT,
  volume_total NUMERIC,
  valor_medio NUMERIC,
  ultima_transacao TIMESTAMP
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    u.id,
    u.full_name,
    COUNT(t.id)::INT,
    SUM(t.amount),
    AVG(t.amount),
    MAX(t.created_at)
  FROM users u
  LEFT JOIN transactions t ON u.id = t.user_id
  WHERE u.id = p_id
  GROUP BY u.id, u.full_name;
END;
$$ LANGUAGE plpgsql;

-- Exemplo DESAFIO 2: Updated_at Automático

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at := NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER users_updated_at BEFORE UPDATE ON users
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- Exemplo DESAFIO 3: Cascade Delete

CREATE OR REPLACE FUNCTION delete_user_cascade()
RETURNS TRIGGER AS $$
BEGIN
  DELETE FROM transactions WHERE user_id = OLD.id;
  DELETE FROM user_accounts WHERE user_id = OLD.id;
  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER users_cascade_delete BEFORE DELETE ON users
FOR EACH ROW EXECUTE FUNCTION delete_user_cascade();

-- Exemplo DESAFIO 4: Validação Complexa

CREATE OR REPLACE FUNCTION validate_transaction()
RETURNS TRIGGER AS $$
DECLARE
  v_user_balance NUMERIC;
  v_max_amount NUMERIC := 1000000;
BEGIN
  -- Validar amount
  IF NEW.amount <= 0 OR NEW.amount > v_max_amount THEN
    RAISE EXCEPTION 'Amount % inválido', NEW.amount;
  END IF;
  
  -- Validar user existe
  IF NOT EXISTS(SELECT 1 FROM users WHERE id = NEW.user_id) THEN
    RAISE EXCEPTION 'User % não existe', NEW.user_id;
  END IF;
  
  -- Validar saldo
  SELECT balance INTO v_user_balance FROM user_accounts WHERE user_id = NEW.user_id;
  IF v_user_balance < NEW.amount THEN
    RAISE EXCEPTION 'Saldo insuficiente';
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_transaction BEFORE INSERT ON transactions
FOR EACH ROW EXECUTE FUNCTION validate_transaction();

-- Exemplo DESAFIO 6: Auditoria com Versioning

CREATE TABLE users_history (
  id SERIAL PRIMARY KEY,
  user_id INT,
  original_id INT,
  full_name VARCHAR,
  email VARCHAR,
  cpf VARCHAR,
  operacao VARCHAR,
  usuario VARCHAR,
  criado_em TIMESTAMP
);

CREATE OR REPLACE FUNCTION audit_users()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO users_history (
    user_id, original_id, full_name, email, cpf,
    operacao, usuario, criado_em
  ) VALUES (
    CASE WHEN TG_OP = 'DELETE' THEN OLD.id ELSE NEW.id END,
    CASE WHEN TG_OP = 'DELETE' THEN OLD.id ELSE NEW.id END,
    CASE WHEN TG_OP = 'DELETE' THEN OLD.full_name ELSE NEW.full_name END,
    CASE WHEN TG_OP = 'DELETE' THEN OLD.email ELSE NEW.email END,
    CASE WHEN TG_OP = 'DELETE' THEN OLD.cpf ELSE NEW.cpf END,
    TG_OP,
    CURRENT_USER,
    NOW()
  );
  IF TG_OP = 'DELETE' THEN
    RETURN OLD;
  ELSE
    RETURN NEW;
  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER users_history AFTER INSERT OR UPDATE OR DELETE ON users
FOR EACH ROW EXECUTE FUNCTION audit_users();
