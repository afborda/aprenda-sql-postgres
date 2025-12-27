-- 05) LATERAL: top-3 transações por usuário
-- Objetivo: listar os 3 maiores valores de transação de cada usuário usando LATERAL.

SELECT u.id, u.full_name, t.amount, t.created_at
FROM users u
CROSS JOIN LATERAL (
  SELECT amount, created_at
  FROM transactions
  WHERE user_id = u.id AND status = 'completed'
  ORDER BY amount DESC
  LIMIT 3
) t
ORDER BY u.id, t.amount DESC;
