-- 01) CTE: totais por UF
-- Objetivo: calcular total de valor por estado (UF) e listar top 5.

WITH per_state AS (
  SELECT t.location_state AS uf,
         SUM(t.amount) AS total_valor
  FROM transactions t
  WHERE t.status = 'completed'
  GROUP BY t.location_state
)
SELECT uf, total_valor
FROM per_state
ORDER BY total_valor DESC
LIMIT 5;
