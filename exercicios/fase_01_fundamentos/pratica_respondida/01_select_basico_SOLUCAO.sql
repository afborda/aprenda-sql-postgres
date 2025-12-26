-- ==============================================
-- FASE 1: FUNDAMENTOS SQL
-- Exercício 1.1: SELECT Básico - SOLUÇÃO
-- ==============================================

-- EXERCÍCIO 1: Selecionar TODOS os usuários
SELECT * FROM users;

-- Resultado esperado: 10 linhas, 11 colunas (id, username, email, full_name, cpf, phone, address, city, state, zip_code, created_at, updated_at)


-- EXERCÍCIO 2: Selecionar colunas específicas
SELECT full_name, email FROM users;

-- Resultado esperado: 10 linhas, 2 colunas


-- EXERCÍCIO 3: Limitar resultados
SELECT full_name, email FROM users LIMIT 3;

-- Resultado esperado: 3 linhas, 2 colunas
-- Resultado: João da Silva Santos | João da Silva Santos, Maria Oliveira Costa, Carlos Santos Ferreira


-- EXERCÍCIO 4: Retornar todas as transações
SELECT * FROM transactions;

-- Resultado esperado: 10 linhas, 10 colunas


-- EXERCÍCIO 5: Seleção e limite combinados
SELECT * FROM posts LIMIT 5;

-- Resultado esperado: 5 linhas, 8 colunas

