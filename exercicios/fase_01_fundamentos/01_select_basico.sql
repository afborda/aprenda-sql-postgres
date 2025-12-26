-- ==============================================
-- FASE 1: FUNDAMENTOS SQL
-- Exercício 1.1: SELECT Básico
-- ==============================================
-- ⏱️  Tempo estimado: 5 minutos
-- 📚 Conceitos: SELECT, colunas, LIMIT

-- ❓ O que você aprenderá:
-- 1. Como selecionar todas as colunas com *
-- 2. Como selecionar colunas específicas
-- 3. Como limitar número de resultados

-- ==============================================
-- EXERCÍCIO 1: Selecionar TODOS os usuários
-- ==============================================
-- Escreva uma query que retorne TODAS as colunas de TODOS os usuários
-- Dica: Use SELECT * FROM users;

-- SUA RESPOSTA:
-- SELECT * from users;




-- ==============================================
-- EXERCÍCIO 2: Selecionar colunas específicas
-- ==============================================
-- Escreva uma query que retorne apenas:
-- - full_name (nome completo)
-- - email (email)
-- Para TODOS os usuários

-- SUA RESPOSTA:
-- SELECT  full_name, email from users;




-- ==============================================
-- EXERCÍCIO 3: Limitar resultados
-- ==============================================
-- Escreva uma query que retorne:
-- - Nome completo
-- - Email
-- Dos PRIMEIROS 3 usuários apenas

-- SUA RESPOSTA:
-- SELECT  full_name, email from users LIMIT 3;




-- ==============================================
-- EXERCÍCIO 4: Retornar todas as transações
-- ==============================================
-- Escreva uma query que retorne TODAS as colunas de TODAS as transações
-- Dica: Tabela = transactions

-- SUA RESPOSTA:
-- SELECT  * FROM transactions;





-- ==============================================
-- EXERCÍCIO 5: Seleção e limite combinados
-- ==============================================
-- Retorne:
-- - Todos os campos dos posts
-- - Apenas os 5 primeiros posts

-- SUA RESPOSTA:
-- SELECT * FROM posts LIMIT 5;


-- ==============================================
-- VALIDAÇÃO - EXECUTE ISTO PARA VERIFICAR
-- ==============================================
-- Se suas respostas estão corretas, deve ter:
-- Ex 1: 10 linhas (usuários) com 11 colunas
-- Ex 2: 10 linhas com 2 colunas (name, email)
-- Ex 3: 3 linhas com 2 colunas
-- Ex 4: 10 linhas (transações) com 10 colunas
-- Ex 5: 5 linhas de posts
