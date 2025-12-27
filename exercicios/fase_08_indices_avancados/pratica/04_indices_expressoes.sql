-- Fase 8: Índices Avançados
-- Exercício 4: Índices em Expressões
--
-- Objetivo: Indexar CÁLCULOS ou FUNÇÕES
--
-- Cenário: Você precisa buscar usuários pelo email (case-insensitive)
-- Sem índice em expressão, isso seria Seq Scan

-- ❌ Problema: LOWER() não usa índice
EXPLAIN ANALYZE
SELECT * FROM users 
WHERE LOWER(email) = 'joao@example.com';

-- ✅ Solução: Criar índice na expressão
CREATE INDEX IF NOT EXISTS idx_users_email_lower 
ON users(LOWER(email));

-- Executar novamente - agora usa Index Scan!
EXPLAIN ANALYZE
SELECT * FROM users 
WHERE LOWER(email) = 'joao@example.com';

-- 📋 Questões:
-- Q1: Qual é a diferença de custo?
-- Q2: Por que a função precisa estar no INDEX?
-- Q3: Se você escrevesse LOWER(email) diferentemente, usaria o índice?
--     Exemplo: SELECT * FROM users WHERE LOWER(TRIM(email)) = ...
-- Q4: Qual é o custo de ter um índice em expressão?

-- 💡 Exemplos comuns de índices em expressões:
-- CREATE INDEX idx_users_name_first ON users(SUBSTR(full_name, 1, 1));
-- CREATE INDEX idx_posts_year ON posts(DATE_TRUNC('month', created_at));
-- CREATE INDEX idx_values_abs ON data(ABS(value));
