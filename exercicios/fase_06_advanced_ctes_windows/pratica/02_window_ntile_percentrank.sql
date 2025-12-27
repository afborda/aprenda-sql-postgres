-- 02) Window: NTILE e PERCENT_RANK
-- Objetivo: dividir transações em quartis por valor e calcular percentual de ranking.

WITH tx_ranked AS (
  SELECT id, amount, payment_method,
         NTILE(4) OVER (ORDER BY amount ASC) AS quartil,
         ROUND(100 * PERCENT_RANK() OVER (ORDER BY amount ASC), 2) AS pct_rank
  FROM transactions
  WHERE status = 'completed'
)
SELECT quartil, COUNT(*) AS qtde, MIN(amount) AS min_valor, MAX(amount) AS max_valor
FROM tx_ranked
GROUP BY quartil
ORDER BY quartil;
