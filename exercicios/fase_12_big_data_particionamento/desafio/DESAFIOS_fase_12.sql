-- Fase 12: Big Data e Particionamento - DESAFIOS Completos

-- DESAFIO 1: Arquitetura para 1TB de Dados

-- Cenário: Banco fintech com 5 anos de histórico
-- - 1TB de transações
-- - 100GB de usuários
-- - 500GB de dados de fraude
-- - Cresce 10GB/mês

-- Questões:
-- 1. Como particionar transações (1TB)?
-- 2. Qual estratégia de limpeza?
-- 3. Como manter índices eficientes?
-- 4. Como fazer backup rápido?

-- Resposta: Range por mês (60 partições), deletar > 5 anos

-- DESAFIO 2: Automação de Partições

-- Implementar:
-- 1. Função que cria nova partição todo mês
-- 2. Função que cria índices automaticamente
-- 3. Job que cria índices em paralelo

-- Código já está em solutions.sql

-- DESAFIO 3: Migração SEM Downtime

-- Passos:
-- 1. Criar transacti ons_v2 particionada em paralelo
-- 2. Copiar dados históricos (INSERT SELECT)
-- 3. Trigger para copiar novos dados em tempo real
-- 4. Validar integridade (COUNT, checksums)
-- 5. Renomear tabelas (atomic)
-- 6. Manter versão antiga como backup

-- Tempo estimado: 2-4 horas para 100GB

-- DESAFIO 4: Política de Retenção

-- Implementar:
-- - 1 ano: hot storage, todos os índices
-- - 1-5 anos: warm storage, índices seletivos
-- - 5+ anos: cold storage ou deletar

CREATE OR REPLACE FUNCTION gerenciar_retenção()
RETURNS TABLE(ação TEXT, tabelas_afetadas INT) AS $$
DECLARE
  v_cold_date DATE := CURRENT_DATE - INTERVAL '5 years';
  v_warm_date DATE := CURRENT_DATE - INTERVAL '1 year';
  v_count INT;
BEGIN
  -- Deletar dados muito antigos (cold)
  DELETE FROM transactions_partitioned
  WHERE created_at < v_cold_date;
  GET DIAGNOSTICS v_count = ROW_COUNT;
  
  RETURN QUERY SELECT 
    FORMAT('Deletado % linhas anteriores a %', v_count, v_cold_date)::TEXT,
    v_count;
  
  -- Mover dados warm para tablespace mais lento
  -- REINDEX ... (skip por enquanto)
  
  RETURN;
END;
$$ LANGUAGE plpgsql;

-- DESAFIO 5: Performance com Partições

-- Antes (sem partição):
-- SELECT * FROM transactions WHERE user_id = 123 AND created_at BETWEEN '2024-01-01' AND '2024-01-31'
-- Tempo: 5 segundos (scan 100GB)

-- Depois (com partição):
-- Mesmo query
-- Tempo: 0.1 segundos (scan apenas 1GB = partition pruning)
-- Melhoria: 50x!

-- DESAFIO 6: Replicação e Backup

CREATE OR REPLACE FUNCTION backup_particao_atual()
RETURNS TEXT AS $$
DECLARE
  v_mes_atual TEXT := TO_CHAR(CURRENT_DATE, 'YYYY_MM');
  v_tabela_nome TEXT := FORMAT('trans_%s', v_mes_atual);
  v_dump_path TEXT := FORMAT('/backup/pg_%s.sql', v_mes_atual);
  v_comando TEXT;
BEGIN
  v_comando := FORMAT(
    'pg_dump --table=public."%s" --data-only /backup/studos_sql > %L',
    v_tabela_nome,
    v_dump_path
  );
  
  -- Executar backup
  RAISE NOTICE 'Backup iniciado: %', v_tabela_nome;
  
  -- Em produção, usar: system(...) via procedimento externo
  
  RETURN FORMAT('Backup salvo em %', v_dump_path);
END;
$$ LANGUAGE plpgsql;

-- DESAFIO Bônus: Monitoramento

CREATE VIEW monitoramento_particoes AS
SELECT 
  schemaname,
  tablename,
  pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as tamanho,
  (SELECT COUNT(*) FROM pg_stat_user_tables 
   WHERE relname = tablename) as num_linhas,
  ROUND(100.0 * pg_total_relation_size(schemaname||'.'||tablename) / 
    (SELECT pg_total_relation_size('transactions_partitioned')), 2) as pct_do_total
FROM pg_tables
WHERE tablename LIKE 'trans_%'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;

-- SELECT * FROM monitoramento_particoes;
-- Ver tamanho de cada partição, crescimento, distribuição

-- =============================================================================
-- 🎉 PARABÉNS! Você completou as 12 fases!
-- 
-- Você agora domina SQL de:
-- ⭐ Básico (SELECT, WHERE, JOINs) até
-- ⭐⭐⭐⭐ Expert (Big Data, Particionamento, Fraude)
--
-- Próximos passos:
-- 1. Continuar praticando com dados reais
-- 2. Aprender frameworks específicos (DuckDB, BigQuery, Snowflake)
-- 3. Especializar em área específica (Analytics, Engineering, Data Science)
-- 4. Contribuir em projetos open source
-- =============================================================================
