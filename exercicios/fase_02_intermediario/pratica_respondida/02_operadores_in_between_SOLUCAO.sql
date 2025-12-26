-- ==============================================
-- FASE 2: CONSULTAS INTERMEDIÁRIAS
-- Exercício 2.2: Operadores IN, NOT IN, BETWEEN - SOLUÇÃO
-- ==============================================

-- EXERCÍCIO 1: Transações de tipos específicos
SELECT user_id, amount, transaction_type, merchant
FROM transactions
WHERE transaction_type IN ('purchase', 'transfer');

-- Resultado esperado: 8 linhas (todas são purchase ou transfer)


-- EXERCÍCIO 2: NÃO é um desses tipos
SELECT user_id, amount, transaction_type
FROM transactions
WHERE transaction_type NOT IN ('purchase');

-- Resultado esperado: 2 linhas (transfer, withdrawal)


-- EXERCÍCIO 3: Valores em um range
SELECT user_id, amount, transaction_type
FROM transactions
WHERE amount BETWEEN 200 AND 500;

-- Resultado esperado: 2 linhas (250.00, 320.75)


-- EXERCÍCIO 4: Estados específicos
SELECT full_name, state, city
FROM users
WHERE state IN ('SP', 'RJ', 'MG');

-- Resultado esperado: 6 linhas


-- EXERCÍCIO 5: Excluir estados
SELECT full_name, state
FROM users
WHERE state NOT IN ('SP', 'RJ', 'MG');

-- Resultado esperado: 4 linhas (outros estados)


-- EXERCÍCIO 6: Posts com engajamento moderado
SELECT title, likes, views
FROM posts
WHERE likes BETWEEN 100 AND 200;

-- Resultado esperado: Posts com likes entre 100 e 200

