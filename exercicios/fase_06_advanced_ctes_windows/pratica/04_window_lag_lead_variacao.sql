-- 04) Window: LAG/LEAD com diferenças entre períodos
-- Objetivo: comparar valor diário com dia anterior e mostrar diferença.

WITH daily_summary AS (
  SELECT DATE_TRUNC('day', t.created_at)::date AS dt,
         SUM(t.amount) AS total_dia
  FROM transactions t
  WHERE t.status = 'completed'
  GROUP BY 1
)
SELECT dt,
       total_dia,
       LAG(total_dia) OVER (ORDER BY dt) AS total_dia_anterior,
       ROUND(total_dia - LAG(total_dia) OVER (ORDER BY dt), 2) AS diferenca,
       ROUND(100 * (total_dia - LAG(total_dia) OVER (ORDER BY dt)) / LAG(total_dia) OVER (ORDER BY dt), 2) AS pct_variacao
FROM daily_summary
ORDER BY dt DESC
LIMIT 30;
