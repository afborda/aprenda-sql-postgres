-- SOLUÇÃO 04
WITH daily AS (
  SELECT DATE_TRUNC('day', t.created_at)::date AS dt,
         SUM(t.amount) AS total_dia
  FROM transactions t
  WHERE t.status = 'completed'
  GROUP BY 1
)
SELECT dt,
       total_dia,
       ROUND(AVG(total_dia) OVER (ORDER BY dt ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) AS media_movel_7d
FROM daily
ORDER BY dt;
