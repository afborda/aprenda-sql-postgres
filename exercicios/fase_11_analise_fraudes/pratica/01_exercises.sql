-- Fase 11: Análise de Fraudes - Exercícios e Soluções

-- ✅ EXERCÍCIO 1: Detecção por Valor

-- Encontrar transações > 2x a média do usuário
WITH user_stats AS (
  SELECT 
    user_id,
    AVG(amount) as media_user,
    STDDEV(amount) as desvio
  FROM transactions
  GROUP BY user_id
)
SELECT 
  t.id,
  t.user_id,
  t.amount,
  us.media_user,
  ROUND(t.amount / NULLIF(us.media_user, 1), 2) as multiplicador,
  CASE 
    WHEN t.amount > us.media_user * 2 THEN 'ALTO RISCO'
    WHEN t.amount > us.media_user * 1.5 THEN 'MÉDIO RISCO'
    ELSE 'BAIXO RISCO'
  END as risco
FROM transactions t
JOIN user_stats us ON t.user_id = us.user_id
ORDER BY risco DESC, multiplicador DESC
LIMIT 100;

-- ✅ EXERCÍCIO 2: Padrões Suspeitos (múltiplas contas)

SELECT 
  u.id,
  u.full_name,
  COUNT(DISTINCT ua.id) as num_contas,
  COUNT(DISTINCT t.location_state) as num_estados,
  COUNT(t.id) as transacoes_30d,
  SUM(t.amount) as volume_30d
FROM users u
LEFT JOIN user_accounts ua ON u.id = ua.user_id
LEFT JOIN transactions t ON ua.id = t.id 
  AND t.created_at > CURRENT_DATE - INTERVAL '30 days'
GROUP BY u.id, u.full_name
HAVING COUNT(DISTINCT ua.id) > 2
ORDER BY num_contas DESC;

-- ✅ EXERCÍCIO 3: Z-Score

WITH stats AS (
  SELECT 
    user_id,
    AVG(amount)::NUMERIC as media,
    STDDEV(amount)::NUMERIC as desvio,
    COUNT(*) as total
  FROM transactions
  WHERE created_at > CURRENT_DATE - INTERVAL '90 days'
  GROUP BY user_id
  HAVING COUNT(*) > 10
)
SELECT 
  t.id,
  t.user_id,
  t.amount,
  s.media,
  s.desvio,
  ROUND(ABS((t.amount - s.media) / NULLIF(s.desvio, 1))::NUMERIC, 2) as z_score,
  CASE 
    WHEN ABS((t.amount - s.media) / NULLIF(s.desvio, 1)) > 3 THEN 'ALTO RISCO'
    WHEN ABS((t.amount - s.media) / NULLIF(s.desvio, 1)) > 2 THEN 'MÉDIO RISCO'
    ELSE 'NORMAL'
  END as status
FROM transactions t
JOIN stats s ON t.user_id = s.user_id
WHERE t.created_at > CURRENT_DATE - INTERVAL '30 days'
ORDER BY z_score DESC;

-- ✅ EXERCÍCIO 4: Análise Geográfica (estado impossível)

WITH trans_com_lag AS (
  SELECT 
    t.id,
    t.user_id,
    t.created_at,
    t.location_state,
    LAG(t.location_state) OVER (PARTITION BY t.user_id ORDER BY t.created_at) as estado_anterior,
    LAG(t.created_at) OVER (PARTITION BY t.user_id ORDER BY t.created_at) as trans_anterior,
    u.full_name
  FROM transactions t
  JOIN users u ON t.user_id = u.id
  WHERE t.created_at > CURRENT_DATE - INTERVAL '7 days'
)
SELECT 
  id,
  user_id,
  full_name,
  created_at,
  location_state,
  estado_anterior,
  EXTRACT(EPOCH FROM (created_at - trans_anterior))/3600 as horas_entre_trans,
  CASE 
    WHEN estado_anterior IS NOT NULL 
      AND estado_anterior != location_state
      AND EXTRACT(EPOCH FROM (created_at - trans_anterior))/3600 < 2
    THEN 'SUSPEITO: Transição rápida de estado'
    ELSE 'OK'
  END as alerta
FROM trans_com_lag
WHERE estado_anterior IS NOT NULL
  AND estado_anterior != location_state
ORDER BY horas_entre_trans;

-- ✅ EXERCÍCIO 5: Mudança de Comportamento

WITH behavior_compare AS (
  SELECT 
    user_id,
    DATE_TRUNC('month', created_at)::DATE as mes,
    COUNT(*) as num_transacoes,
    AVG(amount) as valor_medio,
    MAX(amount) as valor_maximo
  FROM transactions
  WHERE created_at > CURRENT_DATE - INTERVAL '60 days'
  GROUP BY user_id, DATE_TRUNC('month', created_at)
)
SELECT 
  bc1.user_id,
  bc1.mes as mes_atual,
  bc2.mes as mes_anterior,
  bc1.num_transacoes as trans_atual,
  bc2.num_transacoes as trans_anterior,
  ROUND(100.0 * (bc1.num_transacoes - bc2.num_transacoes) / NULLIF(bc2.num_transacoes, 0), 0) as mudanca_pct,
  CASE 
    WHEN bc1.num_transacoes > bc2.num_transacoes * 3 THEN 'MUDANÇA SIGNIFICATIVA'
    WHEN bc1.valor_medio > bc2.valor_media * 2 THEN 'VALORES MAIS ALTOS'
    ELSE 'NORMAL'
  END as alerta
FROM behavior_compare bc1
LEFT JOIN behavior_compare bc2 ON bc1.user_id = bc2.user_id 
  AND bc1.mes = bc2.mes + INTERVAL '1 month'
WHERE bc2.mes IS NOT NULL
ORDER BY mudanca_pct DESC;

-- ✅ EXERCÍCIO 6: Caso Completo - Scoring de Risco

CREATE OR REPLACE FUNCTION calcular_score_fraude(p_user_id INT)
RETURNS TABLE(
  user_id INT,
  score_final INT,
  risco_geral VARCHAR,
  detalhes JSONB
) AS $$
DECLARE
  v_score INT := 0;
  v_score_valor INT := 0;
  v_score_patron INT := 0;
  v_score_geogr INT := 0;
  v_detalhes JSONB := '{}'::JSONB;
BEGIN
  -- Score por valor
  SELECT COUNT(*)::INT * 20 INTO v_score_valor
  FROM transactions
  WHERE user_id = p_user_id
    AND created_at > CURRENT_DATE - INTERVAL '30 days'
    AND amount > (SELECT AVG(amount) * 2 FROM transactions WHERE user_id = p_user_id);
  
  -- Score por padrão
  SELECT COUNT(DISTINCT account_number)::INT * 15 INTO v_score_patron
  FROM user_accounts
  WHERE user_id = p_user_id;
  
  -- Score geográfico
  SELECT COUNT(DISTINCT location_state)::INT * 10 INTO v_score_geogr
  FROM transactions
  WHERE user_id = p_user_id
    AND created_at > CURRENT_DATE - INTERVAL '7 days';
  
  v_score := v_score_valor + v_score_patron + v_score_geogr;
  
  v_detalhes := jsonb_build_object(
    'valor_score', v_score_valor,
    'patron_score', v_score_patron,
    'geogr_score', v_score_geogr
  );
  
  RETURN QUERY SELECT 
    p_user_id,
    v_score,
    CASE 
      WHEN v_score >= 70 THEN 'ALTO'
      WHEN v_score >= 40 THEN 'MÉDIO'
      ELSE 'BAIXO'
    END,
    v_detalhes;
END;
$$ LANGUAGE plpgsql;

-- SELECT * FROM calcular_score_fraude(1);
