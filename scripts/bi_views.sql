-- Views para BI (camada gold) sobre o seed limpo

CREATE OR REPLACE VIEW v_tx_daily AS
SELECT
  DATE(created_at) AS dia,
  COUNT(*) AS qtd_tx,
  SUM(amount) AS valor_total,
  AVG(amount) AS ticket_medio
FROM transactions
GROUP BY 1;

CREATE OR REPLACE VIEW v_tx_state AS
SELECT
  location_state AS uf,
  COUNT(*) AS qtd_tx,
  SUM(amount) AS valor_total,
  AVG(amount) AS ticket_medio
FROM transactions
GROUP BY 1;

CREATE OR REPLACE VIEW v_tx_payment_method AS
SELECT
  payment_method,
  COUNT(*) AS qtd_tx,
  SUM(amount) AS valor_total,
  AVG(amount) AS ticket_medio
FROM transactions
GROUP BY 1;

CREATE OR REPLACE VIEW v_tx_merchant AS
SELECT
  merchant,
  COUNT(*) AS qtd_tx,
  SUM(amount) AS valor_total,
  AVG(amount) AS ticket_medio
FROM transactions
GROUP BY 1
ORDER BY valor_total DESC;

CREATE OR REPLACE VIEW v_fraud_rates AS
SELECT
  DATE(t.created_at) AS dia,
  COUNT(*) AS tx_total,
  SUM(CASE WHEN f.is_fraud THEN 1 ELSE 0 END) AS fraudes,
  ROUND(100.0 * SUM(CASE WHEN f.is_fraud THEN 1 ELSE 0 END) / NULLIF(COUNT(*),0), 2) AS taxa_fraude_pct
FROM transactions t
LEFT JOIN fraud_data f ON f.transaction_id = t.id
GROUP BY 1
ORDER BY dia;
