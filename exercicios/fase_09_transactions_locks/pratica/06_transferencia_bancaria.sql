-- Fase 9: Transactions e Locks
-- Exercício 6: Caso de Estudo - Transferência Bancária Segura
--
-- Objetivo: Implementar transação complexa e segura
--
-- Cenário: Transferência de dinheiro entre contas com validações

-- ✅ Procedimento de Transferência Segura

BEGIN;
  -- Nível de isolamento apropriado
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
  
  -- Validar conta de origem
  SELECT account_number, balance FROM user_accounts 
  WHERE user_id = 1 
  FOR UPDATE;
  -- Se não existe, erro
  -- Se existe, lock exclusivo
  
  -- Validar conta de destino
  SELECT account_number FROM user_accounts 
  WHERE user_id = 2 
  FOR UPDATE;
  
  -- Validar saldo suficiente
  -- (implementar em aplicação ou trigger)
  
  -- Efetuar transferência
  UPDATE user_accounts SET balance = balance - 100 WHERE user_id = 1;
  UPDATE user_accounts SET balance = balance + 100 WHERE user_id = 2;
  
  -- Log da transação
  INSERT INTO audit_log (user_id, action, details)
  VALUES (1, 'TRANSFER', '100 para user 2');
  
COMMIT;  -- Tudo ou nada!

-- Se algo falhar em qualquer ponto, ROLLBACK desfaz tudo

-- 📋 Questões:
-- Q1: Por que usar FOR UPDATE nas contas?
--     (Garantir que outra transação não modifica enquanto você lê)
-- Q2: Onde fazer validação de saldo?
--     (Aplicação ou trigger, antes de fazer UPDATE)
-- Q3: Como implementar retry se falhar?
--     (Aplicação com try/catch e retry com backoff exponencial)
-- Q4: Qual é o tempo ideal de transaction?
--     (Rapidíssimo, idealmente < 100ms)

-- 📊 Monitorar Transações Longas
SELECT 
  pid,
  usename,
  xact_start,
  EXTRACT(EPOCH FROM (NOW() - xact_start)) as duracao_segundos,
  query
FROM pg_stat_activity
WHERE xact_start IS NOT NULL
AND state = 'active'
ORDER BY xact_start;
