-- SOLUÇÃO 02
SELECT u.id, u.full_name,
       COALESCE(SUM(t.amount), 0) AS total_usuario
FROM users u
LEFT JOIN transactions t
  ON t.user_id = u.id AND t.status = 'completed'
GROUP BY u.id, u.full_name
HAVING COALESCE(SUM(t.amount), 0) > (
  SELECT AVG(total_per_user)
  FROM (
    SELECT u2.id, COALESCE(SUM(t2.amount), 0) AS total_per_user
    FROM users u2
    LEFT JOIN transactions t2
      ON t2.user_id = u2.id AND t2.status = 'completed'
    GROUP BY u2.id
  ) s
);
