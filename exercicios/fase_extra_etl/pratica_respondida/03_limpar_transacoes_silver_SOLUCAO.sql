-- SOLUÇÃO 03
CREATE OR REPLACE VIEW silver_transactions AS
SELECT t.id, t.user_id, t.amount, t.transaction_type, t.merchant, t.payment_method,
       t.location_city, t.location_state,
       t.ip_address,
       LOWER(TRIM(t.device_type)) AS device_type,
       t.status,
       t.created_at
FROM transactions t
WHERE t.amount > 0
  AND t.status IN ('completed','pending','failed')
  AND t.created_at <= NOW();
