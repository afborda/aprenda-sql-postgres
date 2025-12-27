-- 06) Curadoria de fraudes (Gold)
-- Unir fraud_data com transações limpas e usuários deduplicados; categorizar risco.

CREATE OR REPLACE VIEW gold_fraud_cases AS
SELECT f.id AS fraud_id,
       f.transaction_id,
       st.user_id,
       su.full_name,
       su.state,
       st.amount,
       f.fraud_score,
       CASE
         WHEN f.fraud_score >= 0.90 THEN 'alto'
         WHEN f.fraud_score >= 0.75 THEN 'medio'
         ELSE 'baixo'
       END AS risco,
       f.status,
       f.detected_at
FROM fraud_data f
JOIN silver_transactions st ON st.id = f.transaction_id
JOIN silver_users su ON su.id = st.user_id;
