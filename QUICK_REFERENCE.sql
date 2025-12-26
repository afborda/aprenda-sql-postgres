-- ==============================================
-- QUICK REFERENCE: Comandos SQL Essenciais
-- Cole e execute conforme necessário
-- ==============================================

-- ==============================================
-- 1. VERIFICAR ESTRUTURA DO BANCO
-- ==============================================

-- Listar todas as tabelas
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public';

-- Ver estrutura de uma tabela
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'users';

-- Contar registros em cada tabela
SELECT 'users' as table_name, COUNT(*) FROM users
UNION ALL
SELECT 'posts', COUNT(*) FROM posts
UNION ALL
SELECT 'comments', COUNT(*) FROM comments
UNION ALL
SELECT 'transactions', COUNT(*) FROM transactions
UNION ALL
SELECT 'fraud_data', COUNT(*) FROM fraud_data
UNION ALL
SELECT 'user_accounts', COUNT(*) FROM user_accounts;

-- ==============================================
-- 2. EXPLORAR DADOS
-- ==============================================

-- Ver primeiros registros
SELECT * FROM users LIMIT 5;

-- Ver tipos de dados
SELECT * FROM transactions LIMIT 1;

-- Valores únicos de uma coluna
SELECT DISTINCT state FROM users ORDER BY state;

-- Valores únicos de transaction_type
SELECT DISTINCT transaction_type FROM transactions;

-- Range de datas
SELECT MIN(created_at), MAX(created_at) FROM transactions;

-- Range de valores
SELECT MIN(amount), MAX(amount) FROM transactions;

-- ==============================================
-- 3. QUERIES COMUM - COPIAR E USAR
-- ==============================================

-- Usuários por estado
SELECT 
    state, 
    COUNT(*) as qtd 
FROM users 
GROUP BY state 
ORDER BY qtd DESC;

-- Posts mais visualizados
SELECT 
    title, 
    views, 
    likes, 
    views + likes as engagement
FROM posts
ORDER BY views DESC
LIMIT 10;

-- Transações por tipo
SELECT 
    transaction_type,
    COUNT(*) as qtd,
    SUM(amount) as total,
    AVG(amount) as media
FROM transactions
GROUP BY transaction_type
ORDER BY total DESC;

-- Usuários com mais transações
SELECT 
    u.full_name,
    COUNT(t.id) as transacoes,
    SUM(t.amount) as volume
FROM users u
LEFT JOIN transactions t ON u.id = t.user_id
GROUP BY u.id, u.full_name
ORDER BY transacoes DESC;

-- Fraudes por tipo
SELECT 
    fraud_type,
    COUNT(*) as total,
    SUM(CASE WHEN is_fraud THEN 1 ELSE 0 END) as confirmadas,
    AVG(fraud_score) as score_medio
FROM fraud_data
GROUP BY fraud_type
ORDER BY total DESC;

-- ==============================================
-- 4. TEMPLATE - COPIE E CUSTOMIZE
-- ==============================================

-- Template 1: Aggregação Simples
/*
SELECT 
    [coluna_para_agrupar],
    COUNT(*) as total,
    SUM([coluna_numerica]) as soma,
    AVG([coluna_numerica]) as media
FROM [tabela]
WHERE [condicoes]
GROUP BY [coluna_para_agrupar]
HAVING [condicoes_grupo]
ORDER BY [ordem];
*/

-- Template 2: JOIN com Agregação
/*
SELECT 
    a.coluna1,
    b.coluna2,
    COUNT(c.id) as total,
    SUM(c.valor) as soma
FROM tabela_a a
LEFT JOIN tabela_b b ON a.id = b.a_id
LEFT JOIN tabela_c c ON a.id = c.a_id
WHERE [condicoes]
GROUP BY a.id, a.coluna1, b.coluna2
ORDER BY total DESC;
*/

-- Template 3: CTE para Análise Complexa
/*
WITH stats_cte AS (
    SELECT 
        user_id,
        COUNT(*) as total,
        SUM(amount) as volume,
        AVG(amount) as media
    FROM transactions
    GROUP BY user_id
)
SELECT 
    u.full_name,
    s.total,
    s.volume,
    s.media
FROM stats_cte s
JOIN users u ON s.user_id = u.id
WHERE s.volume > 1000
ORDER BY s.volume DESC;
*/

-- ==============================================
-- 5. FUNÇÕES ÚTEIS
-- ==============================================

-- String
UPPER('texto')              -- TEXTO
LOWER('TEXTO')              -- texto
LENGTH('texto')             -- 5
SUBSTRING('texto', 1, 3)    -- tex
CONCAT('a', 'b', 'c')       -- abc

-- Data/Hora
NOW()                       -- 2025-12-26 14:30:45
CURRENT_DATE                -- 2025-12-26
DATE(created_at)            -- 2025-12-26
EXTRACT(YEAR FROM created_at)   -- 2025
EXTRACT(MONTH FROM created_at)  -- 12
EXTRACT(DAY FROM created_at)    -- 26
AGE(NOW(), created_at)      -- 1 year 2 months 3 days

-- Número
ROUND(3.14159, 2)           -- 3.14
ABS(-10)                    -- 10
CEIL(3.1)                   -- 4
FLOOR(3.9)                  -- 3

-- Agregação
COUNT(*)                    -- linhas
COUNT(DISTINCT coluna)      -- valores únicos
SUM(coluna)                 -- soma
AVG(coluna)                 -- média
MIN(coluna)                 -- mínimo
MAX(coluna)                 -- máximo
STDDEV(coluna)              -- desvio padrão

-- ==============================================
-- 6. OPERADORES
-- ==============================================

-- Comparação
=   -- igual
!=  -- diferente
>   -- maior
<   -- menor
>=  -- maior ou igual
<=  -- menor ou igual

-- Lógicos
AND -- ambos verdadeiros
OR  -- um dos dois verdadeiro
NOT -- negação

-- Ranges
BETWEEN 100 AND 500         -- x >= 100 AND x <= 500
IN ('SP', 'RJ', 'MG')       -- x = 'SP' OR x = 'RJ' OR x = 'MG'
NOT IN (...)                -- oposto de IN

-- String
LIKE '%texto%'              -- contém "texto"
LIKE 'texto%'               -- começa com "texto"
LIKE '%texto'               -- termina com "texto"
ILIKE '%TEXTO%'             -- LIKE mas case-insensitive

-- NULL
IS NULL                     -- valor é nulo
IS NOT NULL                 -- valor não é nulo

-- ==============================================
-- 7. OTIMIZAÇÃO - VERIFICAR PERFORMANCE
-- ==============================================

-- Ver query plan
EXPLAIN
SELECT * FROM transactions WHERE amount > 500;

-- Ver query plan COM dados reais
EXPLAIN ANALYZE
SELECT * FROM transactions WHERE amount > 500;

-- Criar índice
CREATE INDEX idx_transactions_amount ON transactions(amount);

-- Remover índice
DROP INDEX idx_transactions_amount;

-- Analisar tabela (atualiza estatísticas)
ANALYZE transactions;

-- ==============================================
-- 8. TROUBLESHOOTING
-- ==============================================

-- Ver erros de constraint
SELECT * FROM users WHERE email IS NULL;  -- deve ser 0

-- Ver dados duplicados
SELECT email, COUNT(*) FROM users GROUP BY email HAVING COUNT(*) > 1;

-- Ver registros órfãos
SELECT t.* FROM transactions t
LEFT JOIN users u ON t.user_id = u.id
WHERE u.id IS NULL;

-- Verificar integridade
SELECT COUNT(*) FROM fraud_data WHERE transaction_id NOT IN (SELECT id FROM transactions);

-- ==============================================
-- 9. LIMPEZA E MAINTENANCE
-- ==============================================

-- Vacuum (recupera espaço)
VACUUM transactions;

-- Reindex (reconstrói índices)
REINDEX TABLE transactions;

-- Ver espaço usado
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;

-- ==============================================
-- 10. BACKUP E RESTORE
-- ==============================================

-- Backup (executar no bash, não em SQL)
-- pg_dump dbname > backup.sql

-- Restore (executar no bash)
-- psql dbname < backup.sql

-- Ver log de replicação
SELECT * FROM pg_stat_replication;

-- ==============================================
-- 11. RESET RÁPIDO (CUIDADO!)
-- ==============================================

-- Deletar TODOS dados (mantém estrutura)
-- TRUNCATE users CASCADE;
-- TRUNCATE posts CASCADE;
-- TRUNCATE comments CASCADE;
-- TRUNCATE transactions CASCADE;
-- TRUNCATE fraud_data CASCADE;
-- TRUNCATE user_accounts CASCADE;

-- Depois recarregar dados:
-- \i Banco.sql

-- ==============================================
-- 12. COMANDOS PSQL (bash, não SQL)
-- ==============================================

-- psql -U usuario -d banco                      # conectar
-- psql -U usuario -d banco -f arquivo.sql      # executar arquivo
-- \l                                             # listar bancos
-- \dt                                            # listar tabelas
-- \d users                                       # ver estrutura
-- \h SELECT                                      # ajuda de comando
-- \q                                             # sair

-- ==============================================

-- 🎉 DICA: Salve este arquivo para consulta rápida!
