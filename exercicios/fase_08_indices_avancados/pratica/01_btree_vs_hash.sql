-- Fase 8: Índices Avançados
-- Exercício 1: BTREE vs HASH - Comparação de Performance
--
-- Objetivo: Entender quando usar cada tipo de índice
--
-- Cenário: Você precisa otimizar buscas por email de usuários
-- Duas abordagens: BTREE (padrão) vs HASH (para igualdade)

-- ❌ SEM ÍNDICE (muito lento!)
EXPLAIN ANALYZE
SELECT * FROM users WHERE email = 'joao@example.com';

-- ✅ COM BTREE (a forma padrão)
CREATE INDEX IF NOT EXISTS idx_users_email_btree 
ON users(email);

EXPLAIN ANALYZE
SELECT * FROM users WHERE email = 'joao@example.com';

-- ✅ COM HASH (otimizado apenas para igualdade)
-- Nota: HASH é menos comum, reservado para casos específicos
-- DROP INDEX IF EXISTS idx_users_email_btree;

-- CREATE INDEX IF NOT EXISTS idx_users_email_hash 
-- ON users USING HASH(email);

-- EXPLAIN ANALYZE
-- SELECT * FROM users WHERE email = 'joao@example.com';

-- 📋 Questões:
-- Q1: Qual é a diferença de custo entre sem índice e BTREE?
-- Q2: Se quisesse buscar por padrão (LIKE), HASH funcionaria?
-- Q3: BTREE ou HASH para produção? Por quê?
-- Q4: E se precisasse de range (email < 'z@...')? Qual seria melhor?

-- 💡 Dica: BTREE é versátil; HASH é especializado
