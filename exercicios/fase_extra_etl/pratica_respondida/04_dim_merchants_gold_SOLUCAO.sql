-- SOLUÇÃO 04
CREATE OR REPLACE VIEW dim_merchants AS
SELECT m.merchant,
       MIN(m.created_at) AS first_seen,
       MAX(m.created_at) AS last_seen,
       COUNT(*) AS tx_count,
       SUM(m.amount) AS tx_amount_sum
FROM silver_transactions m
GROUP BY m.merchant;
