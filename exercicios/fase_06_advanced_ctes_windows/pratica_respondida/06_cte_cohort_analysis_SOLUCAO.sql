-- SOLUÇÃO 06
WITH user_cohorts AS (
  SELECT u.id,
         DATE_TRUNC('month', MIN(t.created_at))::date AS cohort_month
  FROM users u
  LEFT JOIN transactions t ON t.user_id = u.id AND t.status = 'completed'
  GROUP BY u.id
),
user_activity AS (
  SELECT uc.id,
         uc.cohort_month,
         DATE_TRUNC('month', t.created_at)::date AS activity_month,
         SUM(t.amount) AS monthly_amount
  FROM user_cohorts uc
  LEFT JOIN transactions t ON t.user_id = uc.id AND t.status = 'completed'
  GROUP BY uc.id, uc.cohort_month, DATE_TRUNC('month', t.created_at)::date
)
SELECT cohort_month,
       activity_month,
       COUNT(*) AS qtde_usuarios,
       SUM(monthly_amount) AS total_valor
FROM user_activity
WHERE activity_month IS NOT NULL
GROUP BY 1, 2
ORDER BY 1, 2
LIMIT 50;
