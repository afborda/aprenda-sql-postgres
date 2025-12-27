# Transactions e Locks em PostgreSQL

## 🎯 O que é uma Transaction?

Uma transaction é um **grupo de operações SQL que devem ser executadas como uma unidade atômica**:
- Ou todas executam e são salvas (COMMIT)
- Ou nenhuma executa (ROLLBACK)

Não há meio termo!

## 🏦 Exemplo Clássico: Transferência Bancária

```sql
-- ❌ SEM transaction (PERIGOSO!)
UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
-- Falha aqui! Banco perdeu dinheiro!
UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;

-- ✅ COM transaction (SEGURO!)
BEGIN;
  UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
  UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;
COMMIT;  -- Só persiste se TUDO deu certo

-- Se algo falhar:
ROLLBACK;  -- Desfaz tudo
```

## 📋 Sintaxe Básica

```sql
-- Iniciar transação
BEGIN;

-- Suas operações SQL aqui
INSERT INTO ...
UPDATE ...
DELETE ...

-- Opção 1: Salvar mudanças
COMMIT;

-- Opção 2: Desfazer mudanças
ROLLBACK;
```

## 🔐 Propriedades ACID

### A - Atomicidade
Tudo ou nada. Não há estado intermediário.

```sql
BEGIN;
  INSERT INTO users VALUES (1, 'João');
  INSERT INTO users VALUES (2, 'Maria');
COMMIT;  -- Ou ambos entram, ou nenhum entra
```

### C - Consistência
Banco sempre em estado válido. Constraints e triggers são respeitados.

```sql
BEGIN;
  INSERT INTO transactions (user_id, amount) VALUES (999, 100);
  -- Falha! user_id 999 não existe (FK constraint)
  -- Transação inteira é desfeita
ROLLBACK;
```

### I - Isolamento
Transações simultâneas não interferem uma na outra.

```sql
-- Transação 1: Lê balance = 100
-- Transação 2: Também lê balance = 100
-- Transação 1: Escreve balance = 150
-- Transação 2: Escreve balance = 150
-- Problema: perder atualização!
-- Solução: níveis de isolamento
```

### D - Durabilidade
Uma vez que COMMIT, os dados são permanentes (mesmo com crash).

```sql
BEGIN;
  UPDATE accounts SET balance = 200;
COMMIT;  -- Agora é permanente
-- Mesmo se cair a energia, dados estão salvos
```

## 🎚️ Níveis de Isolamento

### 1. READ UNCOMMITTED (Inseguro)
```sql
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
-- Lê dados não confirmados (dirty reads)
-- Raro usar em produção
```

### 2. READ COMMITTED (Padrão)
```sql
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- Só lê dados confirmados
-- Pode ter phantom reads
-- Recomendado para maioria dos casos
```

### 3. REPEATABLE READ
```sql
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
-- Snapshot da transação no momento de BEGIN
-- Evita dirty reads e non-repeatable reads
-- Pode ter phantom reads
```

### 4. SERIALIZABLE (Mais seguro e lento)
```sql
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- Comporta-se como se transações rodassem sequencialmente
-- Evita ALL anomalias
-- Mais lento por isso
-- Use apenas se realmente precisa
```

## 🔒 Locks

### Tipos de Locks

**Shared Lock (S)**
- Múltiplas transações podem ter
- Usada para leituras
- Não bloqueia outras leituras
- Bloqueia escritas

**Exclusive Lock (X)**
- Apenas uma transação pode ter
- Usada para escritas
- Bloqueia leituras E escritas
- Garantida isolamento completo

### Locks Implícitos (Automáticos)
```sql
BEGIN;
  SELECT * FROM users;  -- Shared lock automático
  UPDATE users SET name = 'João' WHERE id = 1;  -- Exclusive lock automático
COMMIT;
```

### Locks Explícitos (Manual)
```sql
BEGIN;
  -- Ler com lock exclusivo (ninguém mais pode tocar)
  SELECT * FROM users WHERE id = 1 FOR UPDATE;
  
  -- Ler com lock compartilhado
  SELECT * FROM users WHERE id = 2 FOR SHARE;
COMMIT;
```

## 💥 Deadlock

Deadlock acontece quando:
- Transação A aguarda lock de Transação B
- Transação B aguarda lock de Transação A
- Infinito esperando!

```sql
-- ❌ Cenário de Deadlock

-- Transação 1:
BEGIN;
  UPDATE users SET balance = balance - 100 WHERE id = 1;
  -- Aguarda lock na conta 2...
  UPDATE accounts SET balance = balance + 100 WHERE id = 2;
COMMIT;

-- Transação 2 (simultânea):
BEGIN;
  UPDATE accounts SET balance = balance - 50 WHERE id = 2;
  -- Aguarda lock na conta 1...
  UPDATE users SET balance = balance + 50 WHERE id = 1;
COMMIT;

-- DEADLOCK! PostgreSQL detecta e aborta uma transação

-- ✅ Solução: Ordenar sempre igual!
-- Sempre faça atualizações em ordem: id 1, depois id 2
```

## 🔍 Monitorar Transações

```sql
-- Ver transações ativas
SELECT 
  pid,
  usename,
  application_name,
  state,
  query,
  xact_start
FROM pg_stat_activity
WHERE state != 'idle';

-- Ver locks
SELECT 
  pid,
  usename,
  relation::regclass,
  locktype,
  mode
FROM pg_locks
WHERE NOT granted;  -- Locks aguardando
```

## ⚡ Boas Práticas

✅ **Faça:**
- Manter transações curtas
- Commitar frequentemente
- Usar índices para queries
- Ordenar locks sempre igual
- Monitorar locks com pg_stat_activity

❌ **Não faça:**
- Manter transação aberta enquanto processa em aplicação
- Usar SERIALIZABLE por padrão
- Tomar locks desnecessários
- Ignorar deadlocks (tratá-los com retry)
- Esquecer de COMMIT/ROLLBACK

---

**Próximo**: Vá para os exercícios práticos!
