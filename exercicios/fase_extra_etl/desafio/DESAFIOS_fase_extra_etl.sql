-- DESAFIOS — Fase Extra (ETL na Prática)
-- Resolva os 6 desafios abaixo. Onde indicado, crie VIEWs.

-- 01) silver_accounts: deduplicar por account_number, manter a conta mais recente (updated_at/id);
--     normalizar account_holder (TRIM), garantir is_active boolean, preencher credit_limit NULL com 0.
--     (Crie VIEW silver_accounts)

-- 02) Detecção de outliers: transações com valor fora do padrão por usuário.
--     Calcule z-score por usuário e marque outliers (|z| > 3) em uma VIEW silver_tx_outliers.

-- 03) Auditoria de integridade referencial: transações com user_id inexistente em users.
--     Crie uma VIEW bronze_referential_issues listando transações órfãs.

-- 04) Carga incremental: crie um script SQL que popula silver_transactions_incremental com base
--     em um watermark (último created_at carregado), permitindo reexecução idempotente.

-- 05) Top merchants por UF: em gold_top_merchants_por_uf, mostre os 3 merchants com maior valor
--     total por estado (use window function ROW_NUMBER()).

-- 06) Dashboard de qualidade: crie uma VIEW dq_dashboard com métricas agregadas:
--     invalid_email_count, duplicate_cpf_count, future_tx_count, negative_tx_count, orphan_tx_count.

-- Esqueleto sugerido:
-- CREATE OR REPLACE VIEW silver_accounts AS
-- WITH ranked AS (
--   SELECT ua.*, ROW_NUMBER() OVER (PARTITION BY ua.account_number ORDER BY ua.updated_at DESC NULLS LAST, ua.id DESC) rn
--   FROM user_accounts ua
-- )
-- SELECT user_id,
--        account_type,
--        account_number,
--        TRIM(account_holder) AS account_holder,
--        card_last_digits,
--        balance,
--        COALESCE(credit_limit, 0) AS credit_limit,
--        COALESCE(is_active, TRUE) AS is_active,
--        created_at,
--        updated_at
-- FROM ranked
-- WHERE rn = 1;

-- Para os demais, adapte as ideias das práticas Silver/Gold e as funções window.
