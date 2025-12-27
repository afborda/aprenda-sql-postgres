-- Fase 8: Índices Avançados
-- SOLUÇÃO: Exercício 1 - BTREE vs HASH
--
-- BTREE é versátil e cobre a maioria dos casos
-- HASH é especializado para igualdade apenas

-- ✅ Criar índice BTREE (padrão e recomendado)
CREATE INDEX IF NOT EXISTS idx_users_email_btree 
ON users(email);

EXPLAIN ANALYZE
SELECT * FROM users WHERE email = 'joao@example.com';

-- RESPOSTA:
-- Q1: Redução de ~100-1000x no custo (de Seq Scan de 10k para Index Scan de ~1)
-- Q2: HASH NÃO funciona com LIKE. BTREE sim.
-- Q3: BTREE para produção! Funciona com igualdade, ranges e LIKE.
-- Q4: BTREE também funciona (WHERE email < 'z@example.com')

-- ✅ Resumo:
-- - BTREE: 99% dos casos (use este!)
-- - HASH: Apenas se souber o que está fazendo
-- - Para este caso: BTREE é a resposta correta
