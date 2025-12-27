# Índices Avançados em PostgreSQL

## 🎯 Por que Índices?

Índices são estruturas de dados que permitem encontrar registros rapidamente sem varredura completa da tabela.

Sem índice: procura cada linha até achar (Seq Scan)  
Com índice: salta direto para os registros desejados (Index Scan)

## 📚 Tipos de Índices em PostgreSQL

### 1️⃣ BTREE (Balanced Tree) - O Padrão

**O que é**: Árvore equilibrada que mantém dados ordenados

**Quando usar**: 
- Igualdade (=)
- Comparações (<, >, <=, >=)
- Intervalo (BETWEEN)
- Ordenação (ORDER BY)
- Prefixo (LIKE 'abc%')

```sql
-- Sintaxe
CREATE INDEX idx_users_email ON users(email);

-- Resultado em EXPLAIN ANALYZE
-- Index Scan using idx_users_email on users
-- Filter: (email = 'joao@example.com')
```

**Vantagem**: Versátil, funciona com quase tudo  
**Desvantagem**: Menos eficiente para igualdade que HASH

---

### 2️⃣ HASH

**O que é**: Função hash que mapeia valor → posição

**Quando usar**:
- Apenas igualdade (=)
- Nunca para ranges ou ORDER BY

```sql
-- Sintaxe
CREATE INDEX idx_users_username USING HASH ON users(username);

-- Melhor para:
SELECT * FROM users WHERE username = 'joao';
```

**Vantagem**: Muito rápido para igualdade  
**Desvantagem**: Não funciona com ranges, NÃO é WAL-safe (evitar em versões antigas)

---

### 3️⃣ GIST (Generalized Search Tree)

**O que é**: Árvore genérica que pode armazenar qualquer tipo de dado

**Quando usar**:
- Dados geométricos (pontos, caixas, circulos)
- Dados de texto completo (full-text search)
- Dados customizados

```sql
-- Exemplo com dados geométricos:
CREATE TABLE locations (
  id SERIAL PRIMARY KEY,
  geom GEOMETRY
);

CREATE INDEX idx_locations_geom ON locations USING GIST(geom);

-- Buscar dentro de caixa delimitadora
SELECT * FROM locations 
WHERE geom && 'BOX(0 0, 100 100)'::box;
```

**Vantagem**: Flexível para tipos customizados  
**Desvantagem**: Mais lento que especializado

---

### 4️⃣ BRIN (Block Range Index)

**O que é**: Índice que agrupa blocos consecutivos

**Quando usar**:
- Séries de tempo grandes (milhões de registros)
- Dados naturalmente ordenados
- Quando espaço em disco é crítico

```sql
-- Exemplo: transações (naturalmente ordenadas por data)
CREATE INDEX idx_transactions_created_at_brin 
ON transactions USING BRIN(created_at);

-- Muito menor que BTREE (centenas de KB vs dezenas de MB)
-- Quase tão rápido para ranges
```

**Vantagem**: Extremamente compacto  
**Desvantagem**: Só funciona bem se dados são naturalmente ordenados

---

### 5️⃣ GIN (Generalized Inverted Index)

**O que é**: Índice invertido para arrays e documentos

**Quando usar**:
- Busca full-text (tsvector)
- Arrays
- JSON/JSONB

```sql
-- Exemplo com JSONB
CREATE TABLE eventos (
  id SERIAL PRIMARY KEY,
  dados JSONB
);

CREATE INDEX idx_eventos_dados ON eventos USING GIN(dados);

-- Busca rápida em JSON
SELECT * FROM eventos 
WHERE dados @> '{"tipo": "login"}';
```

**Vantagem**: Muito rápido para buscas complexas  
**Desvantagem**: Consome mais espaço, INSERT/UPDATE mais lentos

---

## 🔗 Índices Compostos (Multi-Coluna)

Índice que cobre múltiplas colunas. **Muito eficiente!**

```sql
-- Sintaxe
CREATE INDEX idx_transactions_user_created 
ON transactions(user_id, created_at DESC);

-- Use quando:
-- - Filtra por user_id E ordena por created_at
-- - Múltiplos WHERE em colunas juntas

-- Esta query usa o índice eficientemente:
SELECT * FROM transactions 
WHERE user_id = 123
ORDER BY created_at DESC;
```

**Ordem importa!**
- Coluna de filtro primeiro
- Coluna de ordenação depois
- Ou colunas mais seletivas primeiro

---

## 📋 Índices Parciais

Índice que cobre apenas ALGUMAS linhas (reduz tamanho!)

```sql
-- Exemplo: indexar apenas fraudes
CREATE INDEX idx_transactions_fraud 
ON transactions(user_id) 
WHERE fraud_score > 0.8;

-- Muito menor que indexar tudo
-- Mas apenas funciona para queries que filtram por fraud_score > 0.8

-- Esta query usa o índice:
SELECT * FROM transactions 
WHERE user_id = 123 
AND fraud_score > 0.8;

-- Esta query NÃO usa:
SELECT * FROM transactions 
WHERE user_id = 123 
AND fraud_score > 0.5;
```

**Vantagem**: Índices muito menores  
**Desvantagem**: Menos flexível

---

## 🧮 Índices em Expressões

Índice que cobre um CÁLCULO ou FUNÇÃO

```sql
-- Problema: EXTRACT não pode usar índice normal
CREATE INDEX idx_transactions_year 
ON transactions(EXTRACT(YEAR FROM created_at));

-- Melhor abordagem: usar BETWEEN
-- Mas se precisar indexar função:

CREATE INDEX idx_users_lower_email 
ON users(LOWER(email));

-- Agora esta query usa o índice:
SELECT * FROM users 
WHERE LOWER(email) = 'joao@example.com';
```

**Vantagem**: Permite indexar cálculos  
**Desvantagem**: Query precisa usar mesma expressão exatamente

---

## 🔍 Monitorando Índices

### Encontrar Índices Não Usados

```sql
SELECT 
  schemaname,
  tablename,
  indexname,
  idx_scan,
  idx_tup_read,
  idx_tup_fetch
FROM pg_stat_user_indexes
WHERE idx_scan = 0  -- Nunca foi usado!
ORDER BY pg_relation_size(indexrelid) DESC;
```

### Tamanho dos Índices

```sql
SELECT 
  schemaname,
  tablename,
  indexname,
  pg_size_pretty(pg_relation_size(indexrelid)) as tamanho
FROM pg_stat_user_indexes
ORDER BY pg_relation_size(indexrelid) DESC;
```

### Índices Duplicados

```sql
-- Encontrar índices que cobrem as mesmas colunas
SELECT 
  t1.indexname,
  t1.indexdef
FROM pg_indexes t1
WHERE t1.tablename = 'transactions'
ORDER BY t1.indexname;
```

---

## ⚡ Trade-offs: Leitura vs Escrita

**Mais índices = Leituras mais rápidas, Escritas mais lentas**

Razão: INSERT/UPDATE/DELETE precisam atualizar todos os índices

```
INSERT/UPDATE/DELETE precisa:
1. Modificar a tabela
2. Atualizar TODOS os índices  ← Caro!
3. Atualizar índices de integridade referencial

SELECT pode:
1. Escolher qualquer índice (ou nenhum)
```

**Estratégia**:
- Desenvolvimento: muitos índices (testa vários caminhos)
- Produção: índices necessários apenas
- Tabelas que crescem muito: menos índices (inserts são críticos)
- Tabelas que são lidas muito: mais índices (reads são críticos)

---

## 📊 Checklist: Estratégia de Índices

Para cada tabela, faça:

- [ ] Identificar colunas usadas em WHERE
- [ ] Identificar colunas usadas em JOIN ON
- [ ] Identificar colunas usadas em ORDER BY
- [ ] Criar índice para cada? Ou índices compostos?
- [ ] Há índices não usados? (remover!)
- [ ] Balancear: quantos índices vs performance de escrita
- [ ] Monitor: pg_stat_user_indexes regularmente
- [ ] Teste: EXPLAIN ANALYZE antes e depois

---

## 🎯 Boas Práticas

✅ **Faça:**
- Criar índice em Foreign Keys (JOIN ON)
- Usar índices compostos em vez de múltiplos
- Monitorar índices regularmente
- Remover índices não usados
- Benchmarkar antes de criar índice

❌ **Não faça:**
- Indexar toda coluna (aumenta overhead)
- Usar HASH a menos que saiba o que está fazendo
- Esquecer de indexar Foreign Keys
- Acreditar que índices resolvem tudo
- Deixar índices não usados ocupando espaço

---

**Próximo**: Vá para os exercícios práticos!
