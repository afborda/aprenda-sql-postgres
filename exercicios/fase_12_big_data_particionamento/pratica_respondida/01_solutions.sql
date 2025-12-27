-- Fase 12: Big Data e Particionamento - SOLUÇÕES e DESAFIOS

-- ✅ SOLUÇÕES Exercícios 1-6

-- Exercício 1: Range - SOLUÇÃO
-- Use para dados históricos (logs, transações, eventos)
-- Benefício: Partition pruning automático para queries com datas

-- Exercício 2: List - SOLUÇÃO
-- Use para categorias (estados, regiões, tipos)
-- Benefício: Fácil manutenção, queries por categoria são rápidas

-- Exercício 3: Hash - SOLUÇÃO
-- Use para distribuição uniforme (escalabilidade)
-- Benefício: Partições sempre equilibradas

-- Exercício 4: Manutenção - SOLUÇÃO
-- Criar script que roda 1º dia de cada mês
-- Adicionar indexes em novas partições

-- Exercício 5: Performance - SOLUÇÃO
-- SELECT * FROM transactions_partitioned
-- WHERE created_at >= '2024-01-01' AND created_at < '2024-02-01'
-- Procura só 1 partição = 10-100x mais rápido

-- Exercício 6: Arquivar - SOLUÇÃO
-- DROP TABLE IF EXISTS trans_2020_*  (deletar dados muito antigos)
-- ALTER TABLE ... SET TABLESPACE ... (mover para storage mais lento)

-- =============================================================================
-- DESAFIOS: Fase 12 - Big Data e Particionamento

-- DESAFIO 1: Estratégia de Particionamento para 1TB
-- Banco tem 1TB de transações (5 anos de dados)
-- Como particionar? Range por data? Hash? Combo?

-- DESAFIO 2: Automação de Partições
-- Criar função que automaticamente cria novas partições
-- Agendar para rodar todo mês

-- DESAFIO 3: Migração de Tabela Não Particionada
-- Tabela transactions existe, 100GB
-- Migrar para versão particionada SEM downtime

-- DESAFIO 4: Limpeza e Arquivamento
-- Implementar política de retenção
-- Dados > 5 anos: arquivar ou deletar
-- Dados 1-5 anos: storage mais lento

-- DESAFIO 5: Performance Tuning com Partições
-- Consulta antiga: 10s em tabela 100GB
-- Com partição: 0.5s
-- Documentar melhoria e padrão

-- DESAFIO 6: Replicação de Partições
-- Replicar dados em outro banco (backup)
-- Sincronizar partições automaticamente
-- Failover rápido

-- =============================================================================

-- Exemplo DESAFIO 1: Estratégia para 1TB

-- Opção 1: Range por mês (60 partições)
-- Vantagem: Partition pruning excelente, fácil manutenção
-- Desvantagem: Partições podem ficar grandes se muitos dados

-- Opção 2: Range por mês + Hash por user_id (240 partições)
-- Vantagem: Distribuição uniforme, máxima escalabilidade
-- Desvantagem: Mais complexo, mais partições

-- Recomendação: Range por mês

-- Exemplo DESAFIO 2: Automação

CREATE OR REPLACE FUNCTION criar_proxima_particao()
RETURNS VOID AS $$
DECLARE
  v_mes_prox DATE := DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month';
  v_mes_prox_2 DATE := v_mes_prox + INTERVAL '1 month';
  v_nome_tabela TEXT := FORMAT('trans_%s', TO_CHAR(v_mes_prox, 'YYYY_MM'));
BEGIN
  -- Criar partição
  EXECUTE FORMAT(
    'CREATE TABLE IF NOT EXISTS %I PARTITION OF transactions_partitioned ' ||
    'FOR VALUES FROM (%L) TO (%L)',
    v_nome_tabela,
    v_mes_prox,
    v_mes_prox_2
  );
  
  -- Criar índices
  EXECUTE FORMAT(
    'CREATE INDEX IF NOT EXISTS %I ON %I(user_id)',
    v_nome_tabela || '_user_idx',
    v_nome_tabela
  );
  
  RAISE NOTICE 'Partição % criada com sucesso', v_nome_tabela;
END;
$$ LANGUAGE plpgsql;

-- DESAFIO 3: Migração SEM Downtime

-- Step 1: Criar tabela nova particionada (paralelo)
-- CREATE TABLE transactions_new (...) PARTITION BY RANGE (...);

-- Step 2: Copiar dados antigos (em background)
-- INSERT INTO transactions_new SELECT * FROM transactions WHERE created_at < '2024-01-01';

-- Step 3: Copiar dados novos com trigger
-- CREATE TRIGGER copy_to_new AFTER INSERT ON transactions ...

-- Step 4: Verificar se tudo foi copiado
-- SELECT COUNT(*) FROM transactions vs transactions_new

-- Step 5: Renomear tabelas
-- ALTER TABLE transactions RENAME TO transactions_old;
-- ALTER TABLE transactions_new RENAME TO transactions;

-- DESAFIO 4: Política de Retenção

CREATE OR REPLACE FUNCTION limpeza_dados_antigos()
RETURNS VOID AS $$
DECLARE
  v_mes_5_anos_atras DATE := CURRENT_DATE - INTERVAL '5 years';
BEGIN
  -- Deletar partições > 5 anos
  DELETE FROM transactions_partitioned
  WHERE created_at < v_mes_5_anos_atras;
  
  RAISE NOTICE 'Dados anteriores a % deletados', v_mes_5_anos_atras;
END;
$$ LANGUAGE plpgsql;

-- Agendar: cron job todo início de ano
-- 0 0 1 1 * psql -d banco -c "SELECT limpeza_dados_antigos();"

-- DESAFIO 6: Replicação

-- Usar pglogical ou similar
-- CREATE LOGICAL SLOT ...
-- PUBLICATION (padrão no PG10+)
-- SUBSCRIPTION (no servidor replica)

-- Exemplo simples: Backup de partição
-- pg_dump --table="trans_2024_01" ... | psql -h backup-server ...
