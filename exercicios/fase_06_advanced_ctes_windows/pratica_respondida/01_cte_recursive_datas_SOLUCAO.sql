-- SOLUÇÃO 01
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
