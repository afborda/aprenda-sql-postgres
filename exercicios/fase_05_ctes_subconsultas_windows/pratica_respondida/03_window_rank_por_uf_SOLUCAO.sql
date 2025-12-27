-- SOLUÇÃO 03
WITH user_totals AS (
  SELECT u.id, u.full_name, u.state,
         SUM(t.amount) AS total_valor
  FROM users u
  JOIN transactions t
    ON t.user_id = u.id AND t.status = 'completed'
  GROUP BY u.id, u.full_name, u.state
)
SELECT id, full_name, state, total_valor,
       ROW_NUMBER() OVER (PARTITION BY state ORDER BY total_valor DESC) AS rn
FROM user_totals
WHERE total_valor IS NOT NULL
ORDER BY state, rn
LIMIT 100;
