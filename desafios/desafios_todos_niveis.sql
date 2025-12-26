# 📝 Desafios SQL - Todos os Níveis

## 🎯 Como Usar Este Arquivo

Este arquivo contém desafios progressivos, organizados por nível:
- **Nível Básico (⭐):** Fase 1
- **Nível Intermediário (⭐⭐):** Fases 2-3
- **Nível Avançado (⭐⭐⭐):** Fases 4-6
- **Nível Expert (⭐⭐⭐⭐):** Fases 7-12

---

## ⭐ NÍVEL BÁSICO (Fase 1-2)

### Desafio 1: Cobertura Geográfica
**Contexto:** Marketing quer saber em quais cidades temos usuários
```sql
-- Retorne cidades únicas onde temos usuários
-- Ordenar alfabeticamente
-- Dica: Use DISTINCT

-- SUA RESPOSTA:
```

### Desafio 2: Usuários Inativos
**Contexto:** Retenção quer re-engajar usuários sem transações
```sql
-- Encontre usuários que NUNCA fizeram uma transação
-- Retorne: full_name, email
-- Ordenar por nome

-- SUA RESPOSTA:
```

### Desafio 3: Posts Virais
**Contexto:** Análise de conteúdo quer entender o que funciona
```sql
-- Encontre os 5 posts com MAIS visualizações
-- Retorne: title, views, likes

-- SUA RESPOSTA:
```

### Desafio 4: Fraude - Alto Valor
**Contexto:** Compliance precisa revisar manualmente transações > R$ 1000
```sql
-- Encontre todas as transações acima de R$ 1000
-- Retorne: user_id, amount, merchant, created_at
-- Ordenar por valor decrescente

-- SUA RESPOSTA:
```

### Desafio 5: Busca de Usuários
**Contexto:** Support precisa encontrar usuários por nome
```sql
-- Encontre usuários com "Silva" no nome
-- Retorne: full_name, email, state
-- Dica: Use LIKE

-- SUA RESPOSTA:
```

---

## ⭐⭐ NÍVEL INTERMEDIÁRIO (Fase 2-3)

### Desafio 6: Engajamento por Autor
**Contexto:** Saber quem são os criadores mais engajados
```sql
-- Para cada usuário, calcule:
-- - Total de posts
-- - Total de visualizações
-- - Total de likes nos posts
-- Ordenar por total de visualizações DESC
-- Dica: Use JOINs e GROUP BY

-- SUA RESPOSTA:
```

### Desafio 7: Análise de Métodos de Pagamento
**Contexto:** Produto quer entender preferências de pagamento
```sql
-- Para cada payment_method:
-- - Quantidade de transações
-- - Valor total transacionado
-- - Ticket médio
-- Ordenar por volume total DESC

-- SUA RESPOSTA:
```

### Desafio 8: Usuários por Padrão de Gasto
**Contexto:** CRM quer segmentar clientes por comportamento
```sql
-- Classifique usuários em grupos:
-- - "Alto valor" se transações > R$ 1500
-- - "Médio valor" se entre 500 e 1500
-- - "Baixo valor" se < 500
-- Retorne: full_name, total_transacionado, categoria
-- Dica: Use CASE WHEN

-- SUA RESPOSTA:
```

### Desafio 9: Fraudes por Região
**Contexto:** Compliance quer entender padrões geográficos
```sql
-- Para cada estado, retorne:
-- - Total de transações
-- - Total de fraudes confirmadas
-- - Taxa de fraude (%)
-- Ordenar por taxa de fraude DESC
-- Dica: Use LEFT JOIN e CASE

-- SUA RESPOSTA:
```

### Desafio 10: Posts Sem Comentários
**Contexto:** Content team quer reativar posts desengajados
```sql
-- Encontre posts que têm 0 comentários
-- Retorne: title, views, likes, created_at
-- Ordenar por views DESC
-- Dica: Use LEFT JOIN com HAVING

-- SUA RESPOSTA:
```

---

## ⭐⭐⭐ NÍVEL AVANÇADO (Fase 4-6)

### Desafio 11: Top Clientes com CTE
**Contexto:** VIP program quer identificar melhores clientes
```sql
-- Use CTE para calcular para cada usuário:
-- - Total de transações
-- - Volume total
-- - Média de transação
-- Depois filtre: volume > 2000 OU transações > 5
-- Retorne: full_name, total_transacoes, volume, media
-- Ordenar por volume DESC

-- SUA RESPOSTA:
```

### Desafio 12: Análise de Comportamento Longitudinal
**Contexto:** Product quer ver evolução de uso
```sql
-- Para cada usuário, retorne:
-- - Primeira transação (data)
-- - Última transação (data)
-- - Dias entre primeira e última
-- - Total de transações
-- Filtrar: dias >= 30
-- Ordenar por total de transações DESC

-- SUA RESPOSTA:
```

### Desafio 13: Detecção de Anomalias
**Contexto:** Fraude precisa encontrar outliers
```sql
-- Calcule para cada usuário:
-- - Média de valor de transação
-- - Desvio padrão
-- Depois encontre transações que são > 3x desvio padrão
-- Retorne: user_id, amount, avg_user, stdev_user, z_score
-- Dica: Use WITH para cálculos

-- SUA RESPOSTA:
```

### Desafio 14: Ranking com Window Functions
**Contexto:** Relatório executivo quer Top 10
```sql
-- Use window functions para:
-- - Rankear usuários por volume de transações
-- - Retorne ranking, user, volume, percentual do total
-- Apenas Top 5
-- Dica: Use ROW_NUMBER() OVER (ORDER BY ... DESC)

-- SUA RESPOSTA:
```

### Desafio 15: Análise de Crescimento
**Contexto:** Quer ver velocidade de crescimento
```sql
-- Calcule para cada usuário:
-- - Número de transação (1ª, 2ª, 3ª...)
-- - Valor acumulado até aquele momento
-- - Diferença com transação anterior
-- Ordene por usuário e data

-- SUA RESPOSTA:
```

---

## ⭐⭐⭐⭐ NÍVEL EXPERT (Fase 7-12)

### Desafio 16: Otimização com EXPLAIN
**Contexto:** Performance quer melhorar query lenta
```sql
-- Use EXPLAIN ANALYZE para entender:
-- - Qual é o custo estimado?
-- - Quantas linhas são lidas?
-- - Qual tipo de scan é usado?
--
-- Query ANTES (lenta):
SELECT u.full_name, COUNT(t.id)
FROM users u, transactions t
WHERE u.id = t.user_id
GROUP BY u.full_name;

-- Reescreva de forma OTIMIZADA:
-- SUA RESPOSTA:
```

### Desafio 17: Índices Estratégicos
**Contexto:** Precisa criar índices para melhorar performance
```sql
-- Identifique 3 índices que melhorariam performance:
-- 1. Qual tabela? Qual coluna? Por quê?
-- 2. Qual tabela? Qual coluna? Por quê?
-- 3. Qual tabela? Qual coluna? Por quê?

-- Crie os índices:
-- CREATE INDEX ...

-- SUA RESPOSTA:
```

### Desafio 18: Detecção de Padrões Complexos
**Contexto:** Fraude quer encontrar casos sofisticados
```sql
-- Encontre padrões de fraude:
-- 1. Múltiplas transações em cidades diferentes em < 2 horas
-- 2. Valor > 2000 vindo de novo usuário (< 5 transações)
-- 3. Transação durante madrugada (00-05h) de novo usuário
--
-- Retorne: user_id, fraud_type, transaction_id, score
-- Dica: Combine CTEs, Window Functions e CASE

-- SUA RESPOSTA:
```

### Desafio 19: Materializar Dados para Dashboard
**Contexto:** BI precisa de view materializada rápida
```sql
-- Crie uma MATERIALIZED VIEW que consolidar:
-- - Data
-- - Estado
-- - Total de usuários ativos
-- - Total de transações
-- - Volume total
-- - Taxa de fraude
--
-- A view deve ser refreshável e ter índices

-- SUA RESPOSTA:
```

### Desafio 20: Trigger para Auditoria
**Contexto:** Compliance precisa rastrear mudanças
```sql
-- Crie uma função e trigger que:
-- - Registre TODA mudança em usuarios (INSERT, UPDATE, DELETE)
-- - Salve dados antigos e novos
-- - Registre timestamp e tipo de operação
--
-- Use JSON para armazenar dados

-- SUA RESPOSTA:
```

---

## 🎯 Como Resolver Desafios

### Passo 1: Entender
- Leia o contexto de negócio
- Identifique que dados você precisa
- Esboce a solução mentalmente

### Passo 2: Explorar
- Rode `SELECT COUNT(*) FROM` para cada tabela
- Veja `SELECT * LIMIT 1` de cada tabela
- Entenda as colunas e relacionamentos

### Passo 3: Construir
- Comece simples (apenas SELECT)
- Adicione WHERE
- Depois JOINs
- Depois GROUP BY
- Depois ORDER BY

### Passo 4: Validar
- A query retorna números sensatos?
- Os valores estão no range esperado?
- As colunas fazem sentido?

### Passo 5: Otimizar
- Use EXPLAIN ANALYZE
- Identifique Seq Scans que podem virar Index Scans
- Mude a ordem de condições se necessário

---

## 📊 Distribuição de Dificuldade

```
Básico (5):       ████░░░░░░░░░░░░░░░░  25%
Intermediário (5): ████░░░░░░░░░░░░░░░░  25%
Avançado (5):     ████░░░░░░░░░░░░░░░░  25%
Expert (5):       ████░░░░░░░░░░░░░░░░  25%
```

---

## 🚀 Próximas Fases

Desafios para fases futuras (em desenvolvimento):
- Desafios 21-30: Stored Procedures e Triggers
- Desafios 31-40: Análise de Fraudes Avançada
- Desafios 41-50: Big Data e Particionamento

---

**Bom desafio!** 💪
