-- 01) CTE recursiva: série de datas
-- Objetivo: gerar uma série de datas de 1 ano atrás até hoje.

WITH RECURSIVE date_series AS (
  SELECT (CURRENT_DATE - INTERVAL '1 year')::date AS dt
  UNION ALL
  SELECT dt + INTERVAL '1 day'
  FROM date_series
  WHERE dt + INTERVAL '1 day' <= CURRENT_DATE
)
SELECT dt
FROM date_series
LIMIT 400;
