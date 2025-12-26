-- ==============================================
-- FASE 2: CONSULTAS INTERMEDIÁRIAS
-- Exercício 2.2: Operadores IN, NOT IN, BETWEEN - SOLUÇÃO
-- ==============================================

-- EXERCÍCIO 1: Transações de tipos específicos
SELECT user_id, amount, transaction_type, merchant
FROM transactions
WHERE transaction_type IN ('purchase', 'transfer');

-- Resultado esperado: 8 linhas


-- EXERCÍCIO 2: NÃO é um desses tipos
SELECT user_id, amount, transaction_type
FROM transactions
WHERE transaction_type NOT IN ('purchase');

-- Resultado esperado: 2 linhas (withdrawal, transfer)


-- EXERCÍCIO 3: Valores em um range
SELECT user_id, amount, transaction_type
FROM transactions
WHERE amount BETWEEN 200 AND 500;

-- Resultado esperado: 3 linhas (250, 250, 320.75)


-- EXERCÍCIO 4: Estados específicos
SELECT full_name, state, city
FROM users
WHERE state IN ('SP', 'RJ', 'MG');

-- Resultado esperado: 6 linhas


-- EXERCÍCIO 5: Excluir estados
SELECT full_name, state
FROM users
WHERE state NOT IN ('SP', 'RJ', 'MG');

-- Resultado esperado: 4 linhas (4 states fora do Sudeste)


-- EXERCÍCIO 6: Posts com engajamento moderado
SELECT title, views, likes
FROM posts
WHERE views BETWEEN 300 AND 500;

-- Resultado esperado: Posts com views entre 300-500
