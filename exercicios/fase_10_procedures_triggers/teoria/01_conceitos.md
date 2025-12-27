# Stored Procedures e Triggers em PostgreSQL

## 📝 Stored Procedures - PL/pgSQL

### Anatomia de uma Procedure

```sql
CREATE OR REPLACE FUNCTION nome_funcao(
  param1 INT,
  param2 VARCHAR
)
RETURNS TABLE(col1 INT, col2 VARCHAR) AS $$
DECLARE
  -- Declarar variáveis aqui
  v_contador INT := 0;
BEGIN
  -- Lógica aqui
  SELECT * FROM tabela;
  
  RETURN;
EXCEPTION
  WHEN OTHERS THEN
    RAISE EXCEPTION 'Erro: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;
```

### Variáveis e Tipos

```sql
DECLARE
  v_numero INT := 0;
  v_texto VARCHAR := 'default';
  v_data DATE;
  v_linha users%ROWTYPE;  -- Mesmo tipo da tabela
BEGIN
  v_numero := 10;
  v_texto := 'novo valor';
END;
```

### Loops

```sql
DECLARE
  v_counter INT := 0;
BEGIN
  -- FOR loop
  FOR i IN 1..10 LOOP
    v_counter := v_counter + i;
  END LOOP;
  
  -- WHILE loop
  WHILE v_counter < 100 LOOP
    v_counter := v_counter + 1;
  END LOOP;
  
  -- FOREACH (arrays)
  FOREACH v_item IN ARRAY v_array LOOP
    RAISE NOTICE 'Item: %', v_item;
  END LOOP;
END;
```

## 🔔 Triggers

### Por que Triggers?

Automação! Executar lógica automaticamente quando dados mudam.

```sql
-- Exemplo: Auditoria automática
CREATE TRIGGER trigger_audit_updates
AFTER UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION registrar_auditoria();

-- Toda vez que UPDATE users, trigger executa automaticamente
```

### Anatomia de um Trigger

```sql
CREATE TRIGGER nome_trigger
BEFORE|AFTER INSERT|UPDATE|DELETE
ON tabela
FOR EACH ROW|STATEMENT
EXECUTE FUNCTION funcao_trigger();
```

### Timing

- **BEFORE**: Valida dados ANTES de inserir
- **AFTER**: Reage DEPOIS de inserir (auditoria)

### Scope

- **FOR EACH ROW**: Executa uma vez por linha modificada
- **FOR EACH STATEMENT**: Executa uma vez por SQL

## 📚 Exemplo Prático: Trigger de Auditoria

```sql
-- Tabela de auditoria
CREATE TABLE audit_log (
  id SERIAL PRIMARY KEY,
  tabela VARCHAR,
  operacao VARCHAR,  -- INSERT, UPDATE, DELETE
  linha_antiga JSONB,
  linha_nova JSONB,
  criado_em TIMESTAMP DEFAULT NOW()
);

-- Função trigger
CREATE OR REPLACE FUNCTION registrar_auditoria()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO audit_log (tabela, operacao, linha_antiga, linha_nova)
  VALUES (
    TG_TABLE_NAME,
    TG_OP,
    row_to_json(OLD),
    row_to_json(NEW)
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Criar trigger
CREATE TRIGGER users_audit
AFTER INSERT OR UPDATE OR DELETE ON users
FOR EACH ROW
EXECUTE FUNCTION registrar_auditoria();

-- Agora toda mudança em users é auditada automaticamente!
```

## 🛡️ Trigger BEFORE para Validação

```sql
CREATE OR REPLACE FUNCTION validar_usuario()
RETURNS TRIGGER AS $$
BEGIN
  -- Validar email
  IF NEW.email NOT LIKE '%@%' THEN
    RAISE EXCEPTION 'Email inválido: %', NEW.email;
  END IF;
  
  -- Validar CPF (muito simplificado)
  IF LENGTH(NEW.cpf) != 14 THEN
    RAISE EXCEPTION 'CPF deve ter 14 caracteres';
  END IF;
  
  RETURN NEW;  -- Permite INSERT/UPDATE
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_usuario
BEFORE INSERT OR UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION validar_usuario();
```

## 🚨 Tratamento de Erros

```sql
CREATE OR REPLACE FUNCTION operacao_critica()
RETURNS BOOLEAN AS $$
BEGIN
  BEGIN
    -- Operação que pode falhar
    UPDATE accounts SET balance = balance - 100 WHERE id = 1;
    
    RETURN true;
  EXCEPTION
    WHEN SQLSTATE '23503' THEN  -- Foreign key violation
      RAISE NOTICE 'Conta não existe';
      RETURN false;
    WHEN OTHERS THEN
      RAISE NOTICE 'Erro inesperado: %', SQLERRM;
      RETURN false;
  END;
END;
$$ LANGUAGE plpgsql;
```

## 💡 Quando Usar

**Procedures:**
- Lógica reutilizável
- Operações complexas
- Transações multi-step
- Validações complexas

**Triggers:**
- Auditoria automática
- Manutenção de dados (updated_at)
- Validações simples
- Replicação de dados

---

**Próximo**: Vá para os exercícios práticos!
