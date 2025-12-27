-- 06) Subconsulta correlacionada: fraudes acima da média do usuário
-- Objetivo: listar fraudes com score acima da média do mesmo usuário.

SELECT f.id AS fraud_id,
       f.user_id,
       f.transaction_id,
       f.fraud_score
FROM fraud_data f
WHERE f.fraud_score > (
  SELECT AVG(f2.fraud_score)
  FROM fraud_data f2
  WHERE f2.user_id = f.user_id
);
