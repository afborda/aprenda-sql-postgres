-- ==============================================
-- FASE 2: CONSULTAS INTERMEDIÁRIAS
-- Exercício 2.2: Operadores IN, NOT IN, BETWEEN
-- ==============================================
-- ⏱️  Tempo estimado: 10 minutos
-- 📚 Conceitos: IN, NOT IN, BETWEEN

-- ❓ O que você aprenderá:
-- 1. IN para múltiplos valores
-- 2. NOT IN para exclusão
-- 3. BETWEEN para ranges
-- 4. Combinar com WHERE

-- ==============================================
-- EXERCÍCIO 1: Transações de tipos específicos
-- ==============================================
-- Retorne transações que são 'purchase' OU 'transfer'
-- Colunas: user_id, amount, transaction_type, merchant
-- Dica: Use IN ('purchase', 'transfer')

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 2: NÃO é um desses tipos
-- ==============================================
-- Retorne transações que NÃO são 'purchase'
-- Colunas: user_id, amount, transaction_type
-- Dica: Use NOT IN

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 3: Valores em um range
-- ==============================================
-- Retorne transações entre R$ 200 e R$ 500
-- Colunas: user_id, amount, transaction_type
-- Dica: Use BETWEEN 200 AND 500

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 4: Estados específicos
-- ==============================================
-- Retorne usuários dos estados SP, RJ, MG
-- Colunas: full_name, state, city
-- Dica: Use IN ('SP', 'RJ', 'MG')

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 5: Excluir estados
-- ==============================================
-- Retorne usuários que NÃO são da região Sudeste (SP, RJ, MG)
-- Colunas: full_name, state
-- Dica: Use NOT IN

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 6: Posts com engajamento moderado
-- ==============================================
-- Retorne posts com visualizações entre 300 e 500
-- Colunas: title, views, likes
-- Dica: BETWEEN

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- VALIDAÇÃO
-- ==============================================
-- Ex 1: Deve retornar transações que são purchase ou transfer
-- Ex 2: Deve retornar transações que NÃO são purchase
-- Ex 3: Deve retornar transações entre 200 e 500
-- Ex 4: Deve retornar usuários de SP, RJ, MG
-- Ex 5: Deve retornar 7 usuários (fora do Sudeste)
-- Ex 6: Deve retornar posts com views entre 300-500
