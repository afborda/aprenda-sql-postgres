# Performance e Otimização de Queries

## 🎯 O que é Performance em SQL?

Performance é sobre **usar recursos eficientemente** - menos CPU, memória e I/O significa queries mais rápidas.

## 📊 EXPLAIN ANALYZE - Seu Melhor Amigo

O `EXPLAIN ANALYZE` mostra como o PostgreSQL executa sua query:

```sql
EXPLAIN ANALYZE
SELECT u.full_name, COUNT(*) as total_transacoes
FROM users u
JOIN transactions t ON u.id = t.user_id
GROUP BY u.full_name
ORDER BY total_transacoes DESC;
```

### Interpretando a Saída

```
Limit  (cost=1000.00..1000.05 rows=5 width=40)
  ->  Sort  (cost=1000.00..1000.05 rows=10 width=40)
        Sort Key: (count(*)) DESC
        ->  HashAggregate  (cost=900.00..910.00 rows=10 width=40)
              Group Key: u.full_name
              ->  Hash Join  (cost=100.00..800.00 rows=1000 width=32)
                    Hash Cond: (t.user_id = u.id)
                    ->  Seq Scan on transactions t  (cost=0.00..500.00 rows=10000 width=8)
                    ->  Hash  (cost=50.00..50.00 rows=100 width=32)
                          ->  Seq Scan on users u  (cost=0.00..50.00 rows=100 width=32)
```

**O que observar:**
- `cost` - Quanto recurso será usado (estimado)
- `rows` - Quantas linhas passarão por cada etapa
- `Seq Scan` - Varredura sequencial (pode ser lenta com tabelas grandes)
- `Index Scan` - Varredura por índice (geralmente mais rápida)
- `Hash Join` vs `Nested Loop` - Diferentes estratégias

## 🔴 Problemas Comuns

### 1. Full Table Scan Desnecessário

```sql
-- ❌ Ruim: sem índice, varredura completa
EXPLAIN ANALYZE
SELECT * FROM users WHERE email = 'joao@example.com';
```

Solução: Criar índice
```sql
CREATE INDEX idx_users_email ON users(email);
```

### 2. JOIN Sem Índice na Foreign Key

```sql
-- ❌ Ruim: sem índice em transactions.user_id
EXPLAIN ANALYZE
SELECT u.full_name, COUNT(*) 
FROM users u
JOIN transactions t ON u.id = t.user_id
GROUP BY u.full_name;
```

### 3. ORDER BY Sem Índice

```sql
-- ❌ Ruim: sort lento
EXPLAIN ANALYZE
SELECT * FROM transactions 
ORDER BY created_at DESC 
LIMIT 100;
```

Solução:
```sql
CREATE INDEX idx_transactions_created_at DESC 
ON transactions(created_at DESC);
```

## ⚡ Estratégias de Otimização

### 1. Use Índices Apropriados
```sql
-- Indices em colunas de filtro
CREATE INDEX idx_transactions_user_id ON transactions(user_id);
CREATE INDEX idx_transactions_state ON transactions(location_state);
```

### 2. Evite Cálculos em Colunas Indexadas
```sql
-- ❌ Ruim: não usa índice
SELECT * FROM transactions 
WHERE EXTRACT(YEAR FROM created_at) = 2024;

-- ✅ Melhor: usa índice se existir
SELECT * FROM transactions 
WHERE created_at >= '2024-01-01' AND created_at < '2025-01-01';
```

### 3. Use Aliases para Clareza
```sql
-- Mais fácil de ler e debugar
SELECT 
  u.id as user_id,
  u.full_name as nome_usuario,
  COUNT(t.id) as total_transacoes
FROM users u
LEFT JOIN transactions t ON u.id = t.user_id
GROUP BY u.id, u.full_name;
```

### 4. Considere Materialized Views para Agregações Pesadas
```sql
CREATE MATERIALIZED VIEW mv_transacoes_por_usuario AS
SELECT 
  user_id,
  COUNT(*) as total_transacoes,
  SUM(amount) as volume_total,
  AVG(amount) as valor_medio,
  MAX(created_at) as ultima_transacao
FROM transactions
GROUP BY user_id;

-- Depois consultar é rápido
SELECT * FROM mv_transacoes_por_usuario 
WHERE total_transacoes > 100;
```

## 📈 Benchmarking - Meça Antes e Depois

```sql
-- Medir tempo de execução
\timing on

-- Sua query aqui
SELECT * FROM transactions WHERE user_id = 123;

-- Resultado: Tempo decorrido: XXX ms
```

## 🎓 Conceitos Importantes

**Seq Scan vs Index Scan:**
- Seq Scan: lê toda a tabela linearmente
- Index Scan: usa índice (geralmente mais rápido)
- Às vezes Seq Scan é melhor em tabelas pequenas!

**Cost Model:**
- `cost=0.00..50.00` significa entre 0 e 50 unidades de custo
- Unidades são relativas, não em ms
- Ajuste com `seq_page_cost`, `random_page_cost`, etc.

**Selectivity:**
- Quão poucos registros a query retorna?
- Alta selectivity (poucos registros) = índice é bom
- Baixa selectivity (muitos registros) = full scan pode ser melhor

## 🔧 Variação: CTEs vs Subconsultas vs Window Functions

```sql
-- Mesmo resultado, diferente performance!

-- Opção 1: CTE
WITH user_totals AS (
  SELECT user_id, COUNT(*) as cnt
  FROM transactions
  GROUP BY user_id
)
SELECT * FROM user_totals WHERE cnt > 100;

-- Opção 2: Subconsulta
SELECT * FROM (
  SELECT user_id, COUNT(*) as cnt
  FROM transactions
  GROUP BY user_id
) t WHERE cnt > 100;

-- Opção 3: Window Function + Filter
SELECT DISTINCT user_id 
FROM (
  SELECT user_id, COUNT(*) OVER (PARTITION BY user_id) as cnt
  FROM transactions
) t 
WHERE cnt > 100;
```

Use `EXPLAIN ANALYZE` para comparar!

## 💡 Dica de Ouro

**Sempre otimize as piores queries primeiro!** Use:

```sql
-- Ver queries mais lentas (em alguns clientes como pgAdmin)
SELECT query, mean_exec_time, calls
FROM pg_stat_statements
ORDER BY mean_exec_time DESC
LIMIT 10;
```

---

**Próximo**: Vá para os exercícios práticos!
