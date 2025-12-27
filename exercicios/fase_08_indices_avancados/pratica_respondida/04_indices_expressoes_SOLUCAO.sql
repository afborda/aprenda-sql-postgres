-- Fase 8: Índices Avançados
-- SOLUÇÃO: Exercício 4 - Índices em Expressões
--
-- Indexar cálculos permite que funções usem índices!

-- ✅ Criar índice em expressão
CREATE INDEX IF NOT EXISTS idx_users_email_lower 
ON users(LOWER(email));

EXPLAIN ANALYZE
SELECT * FROM users 
WHERE LOWER(email) = 'joao@example.com';

-- IMPORTANTE: A query PRECISA usar LOWER() exatamente igual ao índice!
-- Estas queries NÃO usariam o índice:
-- - WHERE LOWER(TRIM(email)) = ... (diferente)
-- - WHERE email = 'JOAO@example.com' (sem LOWER)

-- RESPOSTA:
-- Q1: Redução de ~100x no custo (Index Scan vs Seq Scan)
-- Q2: A função precisa estar no índice para que EXPLAIN veja e use
-- Q3: Não usaria! Precisa ser expressão exatamente igual
-- Q4: Custo é índice mais longo e INSERT/UPDATE mais lentos

-- 💡 Casos de uso:
-- CREATE INDEX idx_users_state_upper ON users(UPPER(state));
-- CREATE INDEX idx_posts_year ON posts(EXTRACT(YEAR FROM created_at));
-- CREATE INDEX idx_abs_values ON data(ABS(value));

-- ⚠️ Use com moderação:
-- - Cada índice em expressão consome espaço
-- - INSERT/UPDATE ficam mais lentos
-- - Só crie se query realmente usar a expressão

-- 💡 RESUMO:
-- - Índices em expressões: permitem usar índices com funções
-- - Query DEVE usar expressão exatamente igual
-- - Use apenas quando necessário
