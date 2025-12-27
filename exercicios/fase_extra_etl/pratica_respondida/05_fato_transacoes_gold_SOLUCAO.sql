-- SOLUÇÃO 05
CREATE OR REPLACE VIEW fato_transacoes AS
SELECT DATE_TRUNC('day', st.created_at) AS dt,
       st.location_state AS uf,
       st.payment_method,
       st.transaction_type,
       COUNT(*) AS qtde_transacoes,
       SUM(st.amount) AS valor_total,
       AVG(st.amount) AS valor_medio
FROM silver_transactions st
GROUP BY 1,2,3,4;
