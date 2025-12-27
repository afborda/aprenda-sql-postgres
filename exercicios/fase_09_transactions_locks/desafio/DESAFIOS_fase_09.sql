-- Fase 9: Transactions e Locks
-- DESAFIOS - 6 Casos de Estudo Reais

-- =============================================================================
-- DESAFIO 1: Garantir Consistência em Transferência Bancária
-- =============================================================================
--
-- Seus clientes reclamam que às vezes dinheiro "desaparece"
-- Implementar transferência segura que GARANTE consistência ACID

-- ❓ Sua tarefa:
-- 1. Criar função que transfere dinheiro
-- 2. Garantir atomicidade (tudo ou nada)
-- 3. Validar saldo antes de transferir
-- 4. Log de auditoria
-- 5. Testar com múltiplas transações simultâneas

-- =============================================================================
-- DESAFIO 2: Implementar Retry Logic para Deadlock
-- =============================================================================
--
-- Aplicação recebe "deadlock" às vezes
-- Implementar retry automático com backoff exponencial

-- ❓ Sua tarefa:
-- 1. Função que faz operação complexa (múltiplos UPDATEs)
-- 2. Se deadlock, retry automaticamente
-- 3. Máximo de 3 tentativas
-- 4. Exponential backoff: 0.1s, 0.2s, 0.4s
-- 5. Retornar status (sucesso/falha com mensagem)

-- =============================================================================
-- DESAFIO 3: Otimizar Locks para Alta Concorrência
-- =============================================================================
--
-- Sistema tem muitas transações simultâneas
-- Precisa maximizar throughput sem sacrificar consistência

-- ❓ Sua tarefa:
-- 1. Analisar cenário: 100 transações/segundo
-- 2. Qual nível de isolamento usar?
--    - READ COMMITTED (mais rápido)
--    - REPEATABLE READ (mais seguro)
--    - SERIALIZABLE (mais lento)
-- 3. Quando usar FOR UPDATE vs deixar implícito?
-- 4. Como minimizar lock contention?
-- 5. Quando usar SKIP LOCKED vs NOWAIT vs bloquear?

-- =============================================================================
-- DESAFIO 4: Encontrar Transações Longas e Abortar
-- =============================================================================
--
-- Algumas transações ficam presas por horas
-- Precisa monitorar e matar transações que demoram muito

-- ❓ Sua tarefa:
-- 1. Query para encontrar transações ativas há > 5 minutos
-- 2. Listar PID, user, query, duração
-- 3. Implementar função para abortar by PID
-- 4. Agendar verificação automática (cron)
-- 5. Alertar antes de matar (log)

-- Referência:
SELECT 
  pid,
  usename,
  xact_start,
  EXTRACT(EPOCH FROM (NOW() - xact_start)) as duracao_seg,
  query
FROM pg_stat_activity
WHERE xact_start IS NOT NULL
ORDER BY xact_start;

-- =============================================================================
-- DESAFIO 5: Resolver Deadlock em Cenário Real
-- =============================================================================
--
-- Seu sistema tem deadlock recorrente
-- Diagnosticar causa e implementar solução permanente

-- Cenário:
-- - Sistema de marketplace com múltiplos vendedores
-- - Cada venda atualiza: inventory, orders, transactions
-- - Deadlock ocasional entre vendedores

-- ❓ Sua tarefa:
-- 1. Reproduzir deadlock (criar cenário com 2 conexões)
-- 2. Identificar causa (ordem de locks diferente)
-- 3. Implementar solução (ordenar locks sempre)
-- 4. Testar com alta concorrência
-- 5. Documentar pattern para evitar no futuro

-- =============================================================================
-- DESAFIO 6: Arquitetura de Transações para Aplicação
-- =============================================================================
--
-- Desenhar estratégia de transações para nova aplicação
-- Considerar diferentes tipos de operações

-- Aplicação precisa suportar:
-- 1. Leitura de dados (SELECT simples)
-- 2. Escrita única (INSERT/UPDATE/DELETE)
-- 3. Transferências (múltiplos UPDATEs)
-- 4. Relatórios (agregações pesadas)
-- 5. Sincronização de dados (bulk updates)

-- ❓ Sua tarefa:
-- 1. Para cada tipo, qual nível de isolamento?
-- 2. Quais precisam de FOR UPDATE?
-- 3. Timeouts apropriados?
-- 4. Como estruturar retries?
-- 5. Monitoramento necessário?

-- Responda para cada:
-- - Tipo de operação
-- - Isolamento recomendado
-- - Locks necessários
-- - Timeout sugerido
-- - Handling de erro (retry? falhar rápido?)

-- =============================================================================
-- 📝 RESUMO DOS DESAFIOS:
-- =============================================================================
--
-- 1. Atomicidade: Garantir ACID
-- 2. Resiliência: Lidar com deadlocks
-- 3. Performance: Balancear locks vs speed
-- 4. Monitoramento: Encontrar problemas
-- 5. Debugging: Resolver deadlocks
-- 6. Arquitetura: Estratégia completa
--
-- 🎯 Meta: Pensar como DBA
-- Transações têm trade-offs entre segurança e performance
-- Escolha baseada em requisito específico da aplicação
