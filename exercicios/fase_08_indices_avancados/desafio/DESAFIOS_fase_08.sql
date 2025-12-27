-- Fase 8: Índices Avançados
-- DESAFIOS - 6 Casos de Estudo Reais
--
-- Estes desafios aplicam conceitos de índices a situações produção

-- =============================================================================
-- DESAFIO 1: Otimizar Índices para Query Complexa
-- =============================================================================
--
-- Uma query de dashboard de compliance está lenta.
-- Seu trabalho: criar estratégia de índices.

EXPLAIN ANALYZE
SELECT 
  u.state,
  u.city,
  COUNT(DISTINCT t.id) as transacoes,
  COUNT(DISTINCT CASE WHEN f.fraud_score > 0.9 THEN t.id END) as fraudes_altas,
  SUM(t.amount) as volume,
  MAX(t.created_at) as ultima_transacao
FROM users u
JOIN transactions t ON u.id = t.user_id
LEFT JOIN fraud_data f ON t.id = f.transaction_id
WHERE t.created_at > CURRENT_DATE - INTERVAL '30 days'
  AND u.state IN ('SP', 'RJ', 'MG')
GROUP BY u.state, u.city
HAVING COUNT(DISTINCT t.id) > 50;

-- ❓ Sua tarefa:
-- 1. Que índices você criaria?
-- 2. Seria índice composto ou separados?
-- 3. Há lugar para índice parcial?
-- 4. Compare performance antes/depois com EXPLAIN ANALYZE

-- =============================================================================
-- DESAFIO 2: Encontrar e Remover Índices Redundantes
-- =============================================================================
--
-- Banco em produção tem muitos índices, alguns redundantes
-- Seu trabalho: identificar e sugerir remoções

-- Simular múltiplos índices (alguns redundantes)
CREATE INDEX IF NOT EXISTS idx_trans_user_id ON transactions(user_id);
CREATE INDEX IF NOT EXISTS idx_trans_user_state ON transactions(user_id, location_state);
CREATE INDEX IF NOT EXISTS idx_trans_state ON transactions(location_state);
CREATE INDEX IF NOT EXISTS idx_trans_created ON transactions(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_trans_amount ON transactions(amount);

-- ❓ Sua tarefa:
-- 1. Qual é a relação entre idx_trans_user_id e idx_trans_user_state?
--    (dica: índices compostos podem cobrir simples)
-- 2. idx_trans_user_state cobre idx_trans_user_id?
-- 3. Quais índices você removeria?
-- 4. Quanto espaço economizaria?

-- Query para encontrar índices:
SELECT indexname, indexdef 
FROM pg_indexes 
WHERE tablename = 'transactions'
ORDER BY indexname;

-- =============================================================================
-- DESAFIO 3: Criar Estratégia de Índices para Novo Schema
-- =============================================================================
--
-- Você está designado a criar índices para nova aplicação
-- Requisito: Suportar estas operações de forma rápida

-- Op 1: Buscar transações recentes de usuário (query comum)
-- Op 2: Buscar todas as fraudes de um período
-- Op 3: Relatório de vendas por estado
-- Op 4: Análise de usuários inativos

-- ❓ Sua tarefa:
-- 1. Escrever as 4 queries esperadas
-- 2. Propor estratégia de índices (com justificativa)
-- 3. Considerar trade-offs (espaço vs performance)
-- 4. Implementar e testar

-- Sua estratégia:
-- Op 1: CREATE INDEX idx_... ON transactions(user_id, created_at DESC);
-- Op 2: CREATE INDEX idx_... ON fraud_data(...) WHERE ...;
-- Op 3: Considerar MATERIALIZED VIEW?
-- Op 4: Pensar em quais colunas seriam usadas em WHERE

-- =============================================================================
-- DESAFIO 4: Identificar Índices Prejudiciais para Escrita
-- =============================================================================
--
-- Sistema de logs precisa inserir MUITOS registros rapidamente
-- Tem muitos índices que desaceleram inserts

-- Simular tabela com muitos índices
CREATE TABLE IF NOT EXISTS audit_log (
  id SERIAL PRIMARY KEY,
  user_id INT,
  action VARCHAR(50),
  resource_id INT,
  created_at TIMESTAMP,
  details JSONB
);

CREATE INDEX IF NOT EXISTS idx_audit_user ON audit_log(user_id);
CREATE INDEX IF NOT EXISTS idx_audit_resource ON audit_log(resource_id);
CREATE INDEX IF NOT EXISTS idx_audit_action ON audit_log(action);
CREATE INDEX IF NOT EXISTS idx_audit_created ON audit_log(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_audit_details ON audit_log USING GIN(details);

-- ❓ Sua tarefa:
-- 1. Qual é o custo em performance de INSERT com tantos índices?
-- 2. Se recebe 1000 inserts/segundo, qual índice remove primeiro?
-- 3. Há índices que NUNCA serão consultados?
-- 4. Estratégia: qual seria o mínimo necessário?

-- Teste: Quantos índices realmente precisa?
-- SELECT * FROM audit_log WHERE user_id = X;
-- SELECT * FROM audit_log WHERE created_at > '2024-01-01';
-- Outros queries? Que você conhece de aplicação?

-- =============================================================================
-- DESAFIO 5: Análise de Tamanho e Impacto de Índices
-- =============================================================================
--
-- Seu diretor pergunta: "Quanto espaço ocupam todos os índices?"
-- "Podemos removê-los para economizar espaço?"

-- ❓ Sua tarefa:
-- 1. Calcular tamanho total de todos os índices
-- 2. Calcular tamanho das tabelas
-- 3. Porcentagem de índices vs tabelas
-- 4. Qual índice ocupa mais espaço?
-- 5. Qual índice traz mais benefício vs tamanho?

-- Queries úteis:
SELECT 
  schemaname,
  tablename,
  indexname,
  pg_size_pretty(pg_relation_size(indexrelid)) as tamanho
FROM pg_stat_user_indexes
WHERE schemaname = 'public'
ORDER BY pg_relation_size(indexrelid) DESC;

SELECT 
  schemaname,
  tablename,
  pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as tamanho_total
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;

-- =============================================================================
-- DESAFIO 6: Migrar para Índices Melhores - Caso de Produção
-- =============================================================================
--
-- Sistema atual tem índices antigos, não otimizados
-- Precisa migrar para novos índices SEM downtime

-- Estratégia:
-- 1. Criar novos índices (CONCURRENTLY para não bloquear)
-- 2. Rodar EXPLAIN ANALYZE para verificar uso
-- 3. Monitorar por 1-2 semanas
-- 4. Remover índices antigos
-- 5. Verificar performance melhorou

-- ✅ Passo 1: Criar novos índices SEM bloquear
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_new_transactions_user_created 
ON transactions(user_id, created_at DESC);

-- ✅ Passo 2: Monitorar uso do novo índice
SELECT 
  indexname,
  idx_scan,
  idx_tup_read
FROM pg_stat_user_indexes
WHERE indexname LIKE 'idx_new%'
ORDER BY idx_scan DESC;

-- ✅ Passo 3: Se novo índice está sendo usado bem...
-- DROP INDEX CONCURRENTLY IF EXISTS idx_old_transactions_user_id;

-- ❓ Sua tarefa:
-- 1. Planejar migração de índices (qual remover, qual adicionar)
-- 2. Implementar usando CONCURRENTLY
-- 3. Documentar antes/depois performance
-- 4. Considerar janela de manutenção

-- =============================================================================
-- 📝 RESUMO DOS DESAFIOS:
-- =============================================================================
--
-- 1. Otimizar: Escolher certo índice para query
-- 2. Remover redundância: Menos índices, mesmo resultado
-- 3. Estratégia: Planejar desde o início
-- 4. Prejudicial: Saber quando menos é mais
-- 5. Análise: Dados para decisões
-- 6. Migração: Melhorar sem downtime
--
-- 🎯 Meta: Pensar como DBA!
-- Índices têm trade-offs, sempre há balanço entre:
-- - Velocidade de leitura
-- - Velocidade de escrita
-- - Espaço em disco
-- - Complexidade de manutenção
