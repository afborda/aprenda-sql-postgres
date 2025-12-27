-- Fase 9: Transactions e Locks
-- Exercício 4: Locks Explícitos (FOR UPDATE, FOR SHARE)
--
-- Objetivo: Adquirir locks manualmente para operações críticas
--
-- Cenário: Garantir exclusividade ao atualizar conta

-- ✅ Teste 1: SELECT FOR UPDATE (lock exclusivo)
BEGIN;
  -- Reservar esta conta para atualização
  SELECT account_number FROM user_accounts 
  WHERE user_id = 1 
  FOR UPDATE;
  
  -- Outras transações esperam aqui se tentarem UPDATE na mesma conta
  UPDATE user_accounts SET account_number = 'NEW-ACC' WHERE user_id = 1;
COMMIT;

-- ✅ Teste 2: SELECT FOR SHARE (lock compartilhado)
BEGIN;
  -- Reservar para leitura (outras transações podem ler)
  SELECT * FROM transactions 
  WHERE user_id = 1 
  FOR SHARE;
  
  -- Outras transações podem fazer SELECT também
  -- Mas não podem UPDATE enquanto você tiver lock
COMMIT;

-- ✅ Teste 3: SELECT FOR UPDATE NOWAIT (não esperar)
BEGIN;
  -- Tenta adquirir lock, se não conseguir retorna erro imediatamente
  SELECT * FROM transactions 
  WHERE user_id = 1 LIMIT 1
  FOR UPDATE NOWAIT;
  -- Se outra transação tiver lock, erro: "could not obtain lock"
COMMIT;

-- ✅ Teste 4: SELECT FOR UPDATE SKIP LOCKED (pular bloqueados)
BEGIN;
  -- Adquire lock apenas nas linhas que consegue
  SELECT * FROM transactions 
  WHERE user_id = 1
  FOR UPDATE SKIP LOCKED;
  -- Se linha 1 está bloqueada, pula e toma lock nas outras
COMMIT;

-- 📋 Questões:
-- Q1: Qual é a diferença entre FOR UPDATE e FOR SHARE?
--     (UPDATE é exclusivo, SHARE permite leituras concorrentes)
-- Q2: NOWAIT vs SKIP LOCKED - quando usar cada um?
--     (NOWAIT = erro se bloqueado; SKIP = ignora bloqueados)
-- Q3: FOR UPDATE bloqueia outras transações?
--     (Sim, elas esperam o lock ser liberado)
// Q4: Como implementar timeout nos locks?
--     (NOWAIT ou aplicação com retry)
