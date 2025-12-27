-- SOLUÇÃO 05
CREATE OR REPLACE VIEW silver_accounts AS
WITH ranked AS (
  SELECT ua.*,
         ROW_NUMBER() OVER (
           PARTITION BY ua.account_number
           ORDER BY ua.updated_at DESC NULLS LAST, ua.id DESC
         ) AS rn
  FROM user_accounts ua
)
SELECT user_id,
       account_type,
       account_number,
       TRIM(account_holder) AS account_holder,
       card_last_digits,
       balance,
       COALESCE(credit_limit, 0) AS credit_limit,
       COALESCE(is_active, TRUE) AS is_active,
       created_at,
       updated_at
FROM ranked
WHERE rn = 1;
