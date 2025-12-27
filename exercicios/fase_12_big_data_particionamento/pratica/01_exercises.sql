-- Fase 12: Big Data e Particionamento - Exercícios

-- ✅ EXERCÍCIO 1: Range Partitioning por Data

-- Criar tabela particionada
CREATE TABLE IF NOT EXISTS transactions_partitioned (
  id BIGSERIAL,
  user_id INT,
  amount NUMERIC,
  created_at TIMESTAMP,
  PRIMARY KEY (id, created_at)
) PARTITION BY RANGE (DATE_TRUNC('month', created_at));

-- Criar algumas partições
CREATE TABLE IF NOT EXISTS trans_2024_01 PARTITION OF transactions_partitioned
FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');

CREATE TABLE IF NOT EXISTS trans_2024_02 PARTITION OF transactions_partitioned
FOR VALUES FROM ('2024-02-01') TO ('2024-03-01');

-- ✅ EXERCÍCIO 2: List Partitioning por Estado

CREATE TABLE IF NOT EXISTS transactions_by_state (
  id BIGSERIAL PRIMARY KEY,
  user_id INT,
  amount NUMERIC,
  location_state VARCHAR,
  created_at TIMESTAMP
) PARTITION BY LIST (location_state);

CREATE TABLE trans_sp PARTITION OF transactions_by_state
FOR VALUES IN ('SP');

CREATE TABLE trans_rj PARTITION OF transactions_by_state
FOR VALUES IN ('RJ', 'RJ-METRO');

CREATE TABLE trans_outros PARTITION OF transactions_by_state
FOR VALUES IN (DEFAULT);

-- ✅ EXERCÍCIO 3: Hash Partitioning

CREATE TABLE IF NOT EXISTS transactions_hash (
  id BIGSERIAL PRIMARY KEY,
  user_id INT,
  amount NUMERIC,
  created_at TIMESTAMP
) PARTITION BY HASH (user_id);

CREATE TABLE trans_h0 PARTITION OF transactions_hash
FOR VALUES WITH (MODULUS 4, REMAINDER 0);

CREATE TABLE trans_h1 PARTITION OF transactions_hash
FOR VALUES WITH (MODULUS 4, REMAINDER 1);

CREATE TABLE trans_h2 PARTITION OF transactions_hash
FOR VALUES WITH (MODULUS 4, REMAINDER 2);

CREATE TABLE trans_h3 PARTITION OF transactions_hash
FOR VALUES WITH (MODULUS 4, REMAINDER 3);

-- ✅ EXERCÍCIO 4: Manutenção de Partições

-- Ver partições existentes
SELECT 
  schemaname,
  tablename,
  pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as tamanho
FROM pg_tables
WHERE tablename LIKE 'trans_%'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;

-- Criar partição nova
CREATE TABLE IF NOT EXISTS trans_2024_03 PARTITION OF transactions_partitioned
FOR VALUES FROM ('2024-03-01') TO ('2024-04-01');

-- ✅ EXERCÍCIO 5: Performance - Partition Pruning

-- Query que usa partition pruning (rápido!)
-- SELECT * FROM transactions_partitioned
-- WHERE created_at BETWEEN '2024-01-01' AND '2024-01-31';
-- Procura só em trans_2024_01

-- ✅ EXERCÍCIO 6: Arquivar Dados Antigos

-- Mover partição antiga para tablespace diferente
ALTER TABLE IF EXISTS trans_2023_12 SET TABLESPACE archive;

-- Ou deletar completamente
DROP TABLE IF EXISTS trans_2023_01;
