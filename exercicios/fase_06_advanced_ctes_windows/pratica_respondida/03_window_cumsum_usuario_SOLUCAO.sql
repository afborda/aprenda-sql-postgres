-- SOLUÇÃO 03
WITH user_tx_ordered AS (
  SELECT user_id, created_at, amount,
         SUM(amount) OVER (
           PARTITION BY user_id
           ORDER BY created_at ASC
         ) AS saldo_cumulativo
  FROM transactions
  WHERE status = 'completed'
  ORDER BY user_id, created_at DESC
  LIMIT 1000
)
SELECT user_id, created_at, amount, saldo_cumulativo
FROM user_tx_ordered
LIMIT 50;
