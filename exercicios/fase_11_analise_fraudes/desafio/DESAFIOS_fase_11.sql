-- Fase 11: Análise de Fraudes - DESAFIOS completos

-- DESAFIO 1: Dashboard de Fraude em Tempo Real

CREATE OR REPLACE VIEW dashboard_fraude AS
WITH fraude_hoje AS (
  SELECT COUNT(*) as total_alertas
  FROM fraud_data
  WHERE DATE(created_at) = CURRENT_DATE
),
valor_risco AS (
  SELECT SUM(t.amount) as valor_em_risco
  FROM transactions t
  JOIN fraud_data f ON t.id = f.transaction_id
  WHERE DATE(f.created_at) = CURRENT_DATE
),
top_suspeitos AS (
  SELECT user_id, COUNT(*) as num_alertas
  FROM fraud_data
  WHERE DATE(created_at) = CURRENT_DATE
  GROUP BY user_id
  ORDER BY num_alertas DESC
  LIMIT 10
)
SELECT 
  (SELECT total_alertas FROM fraude_hoje) as alertas_hoje,
  ROUND(100.0 * (SELECT total_alertas FROM fraude_hoje) / 
    NULLIF(COUNT(*) FILTER (WHERE DATE(created_at) = CURRENT_DATE), 0), 2) as pct_fraude,
  (SELECT valor_em_risco FROM valor_risco) as valor_em_risco
FROM transactions;

-- DESAFIO 2: Modelo Predictivo Simples

CREATE OR REPLACE FUNCTION probabilidade_fraude(p_user_id INT)
RETURNS NUMERIC AS $$
DECLARE
  v_fraudes_anteriores INT;
  v_transacoes_total INT;
  v_probabilidade NUMERIC;
BEGIN
  SELECT COUNT(*) INTO v_fraudes_anteriores
  FROM fraud_data
  WHERE transaction_id IN (
    SELECT id FROM transactions WHERE user_id = p_user_id
  );
  
  SELECT COUNT(*) INTO v_transacoes_total
  FROM transactions
  WHERE user_id = p_user_id;
  
  v_probabilidade := ROUND(
    100.0 * v_fraudes_anteriores / NULLIF(v_transacoes_total, 1),
    2
  );
  
  RETURN v_probabilidade;
END;
$$ LANGUAGE plpgsql;

-- DESAFIO 3: Account Takeover Detection

CREATE OR REPLACE FUNCTION detectar_account_takeover(p_user_id INT)
RETURNS TABLE(
  risco VARCHAR,
  evidencia TEXT[]
) AS $$
DECLARE
  v_evidencias TEXT[] := ARRAY[]::TEXT[];
  v_mudanca_freq NUMERIC;
  v_mudanca_valor NUMERIC;
  v_novos_estados INT;
BEGIN
  -- Mudança de frequência
  WITH freq_mes AS (
    SELECT 
      DATE_TRUNC('month', created_at)::DATE as mes,
      COUNT(*) as count
    FROM transactions
    WHERE user_id = p_user_id
      AND created_at > CURRENT_DATE - INTERVAL '60 days'
    GROUP BY DATE_TRUNC('month', created_at)
  )
  SELECT 
    ROUND(100.0 * (
      LAG(count) OVER (ORDER BY mes) - count
    ) / NULLIF(count, 0), 0)
  INTO v_mudanca_freq
  FROM freq_mes
  ORDER BY mes DESC
  LIMIT 1;
  
  IF v_mudanca_freq > 200 THEN
    v_evidencias := array_append(v_evidencias, 'Mudança >200% em frequência');
  END IF;
  
  -- Novos estados em curto tempo
  SELECT COUNT(DISTINCT location_state)
  INTO v_novos_estados
  FROM transactions
  WHERE user_id = p_user_id
    AND created_at > CURRENT_DATE - INTERVAL '7 days';
  
  IF v_novos_estados > 5 THEN
    v_evidencias := array_append(v_evidencias, FORMAT('Transações em %s estados em 7 dias', v_novos_estados));
  END IF;
  
  RETURN QUERY SELECT 
    CASE 
      WHEN array_length(v_evidencias, 1) >= 2 THEN 'ALTO RISCO'
      WHEN array_length(v_evidencias, 1) = 1 THEN 'MÉDIO RISCO'
      ELSE 'BAIXO RISCO'
    END,
    v_evidencias;
END;
$$ LANGUAGE plpgsql;

-- DESAFIO 5: RFM para Fraude

CREATE OR REPLACE VIEW rfm_fraude_risk AS
WITH rfm AS (
  SELECT 
    user_id,
    EXTRACT(DAY FROM (CURRENT_DATE - MAX(created_at))) as recency,
    COUNT(*) as frequency,
    SUM(amount) as monetary
  FROM transactions
  WHERE created_at > CURRENT_DATE - INTERVAL '90 days'
  GROUP BY user_id
)
SELECT 
  r.user_id,
  r.recency,
  r.frequency,
  r.monetary,
  CASE 
    WHEN r.recency > 30 AND r.frequency = 0 THEN 'CHURNED'
    WHEN r.recency > 30 AND r.frequency < 2 AND r.monetary > 50000 THEN 'ALTO RISCO'
    WHEN r.frequency > 20 AND r.monetary > 100000 THEN 'POWER USER'
    ELSE 'NORMAL'
  END as segmento,
  (SELECT COUNT(*) FROM fraud_data f 
   WHERE f.transaction_id IN (
     SELECT id FROM transactions WHERE user_id = r.user_id
   )) as num_fraudes_historia
FROM rfm r;

-- DESAFIO 6: Sistema Completo com Alertas

CREATE TABLE fraud_alerts (
  id SERIAL PRIMARY KEY,
  user_id INT,
  transaction_id INT,
  tipo_alerta VARCHAR,
  score INT,
  status VARCHAR DEFAULT 'NOVO',
  criado_em TIMESTAMP DEFAULT NOW(),
  resolvido_em TIMESTAMP
);

CREATE OR REPLACE FUNCTION verificar_transacao_fraude(p_transaction_id INT)
RETURNS VOID AS $$
DECLARE
  v_user_id INT;
  v_amount NUMERIC;
  v_score INT := 0;
  v_tipo VARCHAR;
BEGIN
  SELECT user_id, amount INTO v_user_id, v_amount
  FROM transactions
  WHERE id = p_transaction_id;
  
  -- Scoring
  IF v_amount > (SELECT AVG(amount) * 2 FROM transactions WHERE user_id = v_user_id) THEN
    v_score := v_score + 30;
    v_tipo := 'VALOR_ANORMAL';
  END IF;
  
  -- Se score alto, criar alerta
  IF v_score > 50 THEN
    INSERT INTO fraud_alerts (user_id, transaction_id, tipo_alerta, score)
    VALUES (v_user_id, p_transaction_id, v_tipo, v_score);
  END IF;
END;
$$ LANGUAGE plpgsql;

-- Trigger para executar verificação
CREATE TRIGGER check_fraud_on_transaction
AFTER INSERT ON transactions
FOR EACH ROW
EXECUTE FUNCTION verificar_transacao_fraude(NEW.id);
