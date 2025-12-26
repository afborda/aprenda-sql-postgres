-- ==============================================
-- FASE 1: FUNDAMENTOS SQL
-- Exercício 1.2: Filtragem com WHERE - SOLUÇÃO
-- ==============================================

-- EXERCÍCIO 1: Usuários de um estado específico
SELECT full_name, email, state 
FROM users 
WHERE state = 'SP';

-- Resultado esperado: 2 linhas (João, Maria)


-- EXERCÍCIO 2: Usuários que NÃO são de SP
SELECT full_name, state 
FROM users 
WHERE state != 'SP';

-- Resultado esperado: 8 linhas


-- EXERCÍCIO 3: Transações com valor > R$ 500
SELECT user_id, amount, transaction_type 
FROM transactions 
WHERE amount > 500;

-- Resultado esperado: 3 linhas (1200, 2500, 1200)


-- EXERCÍCIO 4: Transações < R$ 200
SELECT user_id, amount, created_at 
FROM transactions 
WHERE amount < 200;

-- Resultado esperado: 4 linhas (150.50, 89.99, 45.00, 110.00)


-- EXERCÍCIO 5: Posts com > 0 likes
SELECT title, likes, views 
FROM posts 
WHERE likes > 0;

-- Resultado esperado: 10 linhas (todos têm likes > 0)


-- EXERCÍCIO 6: Usuários com CPF registrado
SELECT full_name, cpf 
FROM users 
WHERE cpf IS NOT NULL;

