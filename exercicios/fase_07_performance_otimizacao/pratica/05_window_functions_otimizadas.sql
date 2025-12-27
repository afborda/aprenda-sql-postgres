-- Fase 7: Performance e Otimização
-- Exercício 5: Window Functions Otimizadas
--
-- Objetivo: Comparar performance de Window Functions vs outras abordagens
--
-- Cenário: Ranking de transações por usuário (mais recentes = melhor)
-- Window functions são poderosas mas podem ser lentas com dados mal otimizados

-- ❌ Abordagem 1: Subconsulta correlada (LENTA!)
EXPLAIN ANALYZE
SELECT 
  t1.user_id,
  t1.id,
  t1.amount,
  t1.created_at,
  (
    SELECT COUNT(*) + 1
    FROM transactions t2
    WHERE t2.user_id = t1.user_id
      AND t2.created_at > t1.created_at
  ) as ranking
FROM transactions t1
WHERE t1.created_at > CURRENT_DATE - INTERVAL '30 days'
ORDER BY t1.user_id, t1.created_at DESC
LIMIT 1000;

-- ✅ Abordagem 2: Window Function (RÁPIDA!)
EXPLAIN ANALYZE
SELECT 
  user_id,
  id,
  amount,
  created_at,
  ROW_NUMBER() OVER (
    PARTITION BY user_id 
    ORDER BY created_at DESC
  ) as ranking
FROM transactions
WHERE created_at > CURRENT_DATE - INTERVAL '30 days'
ORDER BY user_id, ranking
LIMIT 1000;

-- 📋 Questões para análise:
-- Q1: Qual abordagem é mais rápida? Quanto mais rápida?
-- Q2: Por que subconsultas correladas são tão lentas?
-- Q3: O que é melhor: múltiplas window functions ou uma única?

-- ✅ Abordagem 3: Window function com múltiplas agregações
EXPLAIN ANALYZE
SELECT 
  user_id,
  id,
  amount,
  created_at,
  ROW_NUMBER() OVER (
    PARTITION BY user_id 
    ORDER BY created_at DESC
  ) as ranking,
  SUM(amount) OVER (
    PARTITION BY user_id 
    ORDER BY created_at DESC
  ) as cumulative_amount,
  AVG(amount) OVER (
    PARTITION BY user_id
  ) as user_avg
FROM transactions
WHERE created_at > CURRENT_DATE - INTERVAL '30 days'
ORDER BY user_id, created_at DESC
LIMIT 1000;

-- 📋 Sua tarefa:
-- 1. Execute as 3 abordagens com EXPLAIN ANALYZE
-- 2. Anote os tempos de cada uma
-- 3. Qual é mais eficiente em termos de CPU/I/O?
-- 4. Quando você usaria cada abordagem?
-- 5. Se precisasse de ranking E cumulative_amount, qual estratégia escolheria?

-- 💡 Dica: Window functions geralmente requerem uma passagem completa dos dados
-- (WindowAgg no plano), enquanto subconsultas correladas fazem N passagens (N = número de linhas)
