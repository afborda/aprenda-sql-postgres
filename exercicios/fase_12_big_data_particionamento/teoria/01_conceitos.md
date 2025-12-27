# Big Data e Particionamento em PostgreSQL

## 🎯 Por que Particionar?

Quando tabela fica muito grande (bilhões de rows):
- **Queries ficam lentas**: Índices não ajudam tanto
- **Maintenance fica lento**: VACUUM, ANALYZE, etc
- **Backup fica impossível**: Terabytes em poucos minutos
- **Arquivamento**: Precisa deletar dados antigos

**Solução: Particionamento!**

## 📊 Tipos de Particionamento

### 1. Range Partitioning (Por Intervalo)

```sql
-- Particionar transações por DATA
CREATE TABLE transactions (
  id BIGSERIAL PRIMARY KEY,
  user_id INT,
  amount NUMERIC,
  created_at TIMESTAMP
) PARTITION BY RANGE (DATE_TRUNC('month', created_at));

-- Criar partições (mensais)
CREATE TABLE transactions_2024_01 PARTITION OF transactions
FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');

CREATE TABLE transactions_2024_02 PARTITION OF transactions
FOR VALUES FROM ('2024-02-01') TO ('2024-03-01');
```

**Vantagem**: Excelente para séries temporais (logs, transações)  
**Desvantagem**: Precisa criar novas partições periodicamente

### 2. List Partitioning (Por Categoria)

```sql
-- Particionar por estado/região
CREATE TABLE transactions (
  id BIGSERIAL PRIMARY KEY,
  user_id INT,
  amount NUMERIC,
  location_state VARCHAR
) PARTITION BY LIST (location_state);

-- Criar partições por estado
CREATE TABLE transactions_sp PARTITION OF transactions
FOR VALUES IN ('SP', 'SP-METRO');

CREATE TABLE transactions_rj PARTITION OF transactions
FOR VALUES IN ('RJ', 'RJ-METRO');

CREATE TABLE transactions_outros PARTITION OF transactions
FOR VALUES IN (DEFAULT);  -- Todos os outros
```

**Vantagem**: Bom para dados categóricos  
**Desvantagem**: Partições podem ficar desequilibradas

### 3. Hash Partitioning (Distribuição)

```sql
-- Distribuir uniformemente por hash
CREATE TABLE transactions (
  id BIGSERIAL PRIMARY KEY,
  user_id INT,
  amount NUMERIC,
  created_at TIMESTAMP
) PARTITION BY HASH (user_id);

-- Criar 4 partições
CREATE TABLE transactions_0 PARTITION OF transactions
FOR VALUES WITH (MODULUS 4, REMAINDER 0);

CREATE TABLE transactions_1 PARTITION OF transactions
FOR VALUES WITH (MODULUS 4, REMAINDER 1);

-- ... etc até REMAINDER 3
```

**Vantagem**: Distribuição uniforme, boa escalabilidade  
**Desvantagem**: Mais complexo de consultar

## 🔧 Manutenção de Partições

### Criar Nova Partição Mensalmente

```sql
-- Script para rodar todo mês
CREATE TABLE transactions_2024_12 PARTITION OF transactions
FOR VALUES FROM ('2024-12-01') TO ('2025-01-01');

-- Index na nova partição
CREATE INDEX transactions_2024_12_user_id
ON transactions_2024_12(user_id);
```

### Arquivar Dados Antigos

```sql
-- Mover partição antiga para storage mais lento
ALTER TABLE transactions_2023_01 SET TABLESPACE archive_storage;

-- Ou deletar dados bem antigos
DROP TABLE IF EXISTS transactions_2020_01;  -- Deleta tudo do mês
```

### Manutenção Automática

```sql
-- Função para criar partições automaticamente
CREATE OR REPLACE FUNCTION criar_particao_proxima_mes()
RETURNS VOID AS $$
DECLARE
  v_mes_prox DATE := DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month';
  v_mes_prox_2 DATE := v_mes_prox + INTERVAL '1 month';
  v_nome_tabela TEXT;
BEGIN
  v_nome_tabela := FORMAT('transactions_%s', TO_CHAR(v_mes_prox, 'YYYY_MM'));
  
  EXECUTE FORMAT(
    'CREATE TABLE %I PARTITION OF transactions FOR VALUES FROM (%L) TO (%L)',
    v_nome_tabela,
    v_mes_prox,
    v_mes_prox_2
  );
  
  RAISE NOTICE 'Partição % criada', v_nome_tabela;
END;
$$ LANGUAGE plpgsql;

-- Agendar (cron): 1º dia de cada mês
-- 0 0 1 * * psql -d banco -c "SELECT criar_particao_proxima_mes();"
```

## ⚡ Queries com Partições

### Partition Pruning (Automático!)

```sql
-- PostgreSQL automaticamente procura só em:
-- transactions_2024_01, transactions_2024_02
SELECT * FROM transactions
WHERE created_at BETWEEN '2024-01-01' AND '2024-02-28';
-- Query fica 10-100x mais rápida!
```

### Consultar Múltiplas Partições

```sql
-- Procura em todas (mais lento, mas necessário)
SELECT * FROM transactions WHERE user_id = 123;

-- Resultado: Combina dados de todas as partições
```

## 📈 Performance com Partições

| Tamanho | Sem Partição | Com Partição | Ganho |
|---------|-------------|-------------|-------|
| 100M rows | 1s | 0.1s | 10x |
| 1B rows | 10s | 0.2s | 50x |
| 10B rows | 100s | 0.5s | 200x |

## 💡 Quando Particionar?

✅ **Particione se:**
- Tabela > 10-20GB
- Dados históricos (séries temporais)
- Precisa arquivar periodicamente
- Precisa manter performance com crescimento

❌ **Não particione se:**
- Tabela < 5GB
- Queries acessam múltiplas partições sempre
- Dados são pequenos e estáticos

---

**Próximo**: Vá para os exercícios práticos!
