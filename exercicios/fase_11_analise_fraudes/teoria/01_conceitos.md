# Análise de Fraudes em SQL

## 🎯 O que é Fraude?

Transação que não foi autorizada pelo titular da conta. Tipos:
- **Roubo de identidade**: Usar dados de terceiro
- **Transações anormais**: Valores muito altos, localizações suspeitas
- **Account takeover**: Hacker acessa conta legítima
- **Teste de cartão**: Múltiplas pequenas transações
- **Chargeback**: Disputa da transação

## 📊 Técnicas de Detecção

### 1. Detecção por Valor

```sql
-- Transações acima da média histórica do usuário
SELECT 
  t.id,
  t.amount,
  u.full_name,
  (SELECT AVG(amount) FROM transactions WHERE user_id = t.user_id) as media,
  (SELECT STDDEV(amount) FROM transactions WHERE user_id = t.user_id) as desvio,
  CASE 
    WHEN t.amount > (SELECT AVG(amount) * 2 FROM transactions WHERE user_id = t.user_id)
    THEN 'SUSPEITO'
    ELSE 'OK'
  END as risco
FROM transactions t
JOIN users u ON t.user_id = u.id
WHERE t.created_at > CURRENT_DATE - INTERVAL '30 days'
```

### 2. Z-Score (Desvio Padrão)

```sql
-- Z-score > 3 significa muito fora da normal
WITH stats AS (
  SELECT 
    user_id,
    AVG(amount) as media,
    STDDEV(amount) as desvio
  FROM transactions
  GROUP BY user_id
)
SELECT 
  t.id,
  t.amount,
  s.media,
  s.desvio,
  ABS((t.amount - s.media) / NULLIF(s.desvio, 0)) as z_score,
  CASE 
    WHEN ABS((t.amount - s.media) / NULLIF(s.desvio, 0)) > 3 THEN 'ALTO RISCO'
    WHEN ABS((t.amount - s.media) / NULLIF(s.desvio, 0)) > 2 THEN 'MÉDIO RISCO'
    ELSE 'BAIXO RISCO'
  END as avaliacao
FROM transactions t
JOIN stats s ON t.user_id = s.user_id
```

### 3. Padrões Suspeitos

```sql
-- Múltiplas contas, múltiplos cartões, mesma pessoa
SELECT 
  u.full_name,
  COUNT(DISTINCT ua.account_number) as num_contas,
  COUNT(DISTINCT ua.id) as num_cartoes,
  COUNT(DISTINCT t.location_state) as num_estados,
  COUNT(t.id) as total_transacoes_30d
FROM users u
LEFT JOIN user_accounts ua ON u.id = ua.user_id
LEFT JOIN transactions t ON ua.id = t.id AND t.created_at > CURRENT_DATE - INTERVAL '30 days'
GROUP BY u.id, u.full_name
HAVING COUNT(DISTINCT ua.account_number) > 3  -- Múltiplas contas = suspeito
```

### 4. Velocidade Impossível

```sql
-- Transações em localizações distantes em tempo curto
WITH transacoes_ordenadas AS (
  SELECT 
    user_id,
    created_at,
    location_state,
    LAG(created_at) OVER (PARTITION BY user_id ORDER BY created_at) as trans_anterior,
    LAG(location_state) OVER (PARTITION BY user_id ORDER BY created_at) as estado_anterior
  FROM transactions
  WHERE created_at > CURRENT_DATE - INTERVAL '7 days'
)
SELECT 
  user_id,
  created_at,
  location_state,
  CASE 
    WHEN estado_anterior IS NOT NULL 
      AND estado_anterior != location_state
      AND (created_at - trans_anterior) < INTERVAL '2 hours'
    THEN 'VELOCIDADE IMPOSSÍVEL'
    ELSE 'OK'
  END as risco
FROM transacoes_ordenadas
WHERE estado_anterior IS NOT NULL
```

### 5. RFM (Recency, Frequency, Monetary)

```sql
-- Segmentar clientes por padrão de comportamento
WITH rfm AS (
  SELECT 
    user_id,
    DATEDIFF(day, MAX(created_at), TODAY()) as recency,  -- Dias desde última
    COUNT(*) as frequency,  -- Número de transações
    SUM(amount) as monetary  -- Total gasto
  FROM transactions
  WHERE created_at > CURRENT_DATE - INTERVAL '90 days'
  GROUP BY user_id
)
SELECT 
  user_id,
  recency,
  frequency,
  monetary,
  CASE 
    WHEN recency > 30 AND frequency < 2 THEN 'CHURNED'
    WHEN recency < 7 AND frequency > 10 AND monetary > 10000 THEN 'VIP'
    WHEN frequency > 50 AND monetary > 50000 THEN 'POWER USER'
    ELSE 'NORMAL'
  END as segmento
FROM rfm
```

### 6. Machine Learning: Isolation Forest

Muito complexo em SQL puro, mas conceito:
```sql
-- Encontrar outliers (anormais)
-- Usar desvio padrão, IQR, etc
WITH percentis AS (
  SELECT 
    user_id,
    amount,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY amount) as q1,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY amount) as q3
  FROM transactions
  GROUP BY user_id
)
SELECT 
  user_id,
  amount,
  q1, q3,
  (q3 - q1) * 1.5 as limite,
  CASE 
    WHEN amount > q3 + (q3 - q1) * 1.5 THEN 'OUTLIER'
    ELSE 'NORMAL'
  END as status
FROM percentis
```

---

**Próximo**: Vá para os exercícios práticos!
