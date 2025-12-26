-- ==============================================
-- FASE 1: FUNDAMENTOS SQL
-- Exercício 1.2: Filtragem com WHERE
-- ==============================================
-- ⏱️  Tempo estimado: 8 minutos
-- 📚 Conceitos: WHERE, operadores (=, !=, >, <), lógica básica

-- ❓ O que você aprenderá:
-- 1. Filtrar por igualdade (=)
-- 2. Filtrar por desigualdade (!=)
-- 3. Filtrar por comparação (>, <)
-- 4. Combinar múltiplas condições

-- ==============================================
-- EXERCÍCIO 1: Usuários de um estado específico
-- ==============================================
-- Retorne TODOS os usuários do estado de São Paulo (SP)
-- Colunas: full_name, email, state

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 2: Usuários que NÃO são de SP
-- ==============================================
-- Retorne usuários que NÃO estão em SP
-- Colunas: full_name, state
-- Dica: Use !=

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 3: Transações com valor específico
-- ==============================================
-- Retorne transações com valor MAIOR que R$ 500
-- Colunas: user_id, amount, transaction_type
-- Dica: Use >

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 4: Transações menores que R$ 200
-- ==============================================
-- Retorne transações com valor MENOR que R$ 200
-- Colunas: user_id, amount, created_at

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 5: Posts sem comentários negativos
-- ==============================================
-- Retorne posts que têm MAIS que 0 likes
-- Colunas: title, likes, views
-- Dica: Tabela = posts

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 6: Usuários com CPF registrado
-- ==============================================
-- Retorne usuários que TÊM CPF registrado (não NULL)
-- Colunas: full_name, cpf
-- Dica: Use IS NOT NULL

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- VALIDAÇÃO
-- ==============================================
-- Ex 1: Deve retornar 2 usuários (SP)
-- Ex 2: Deve retornar 8 usuários (não SP)
-- Ex 3: Deve retornar 3 transações (> 500)
-- Ex 4: Deve retornar 4 transações (< 200)
-- Ex 5: Deve retornar posts com likes > 0
-- Ex 6: Deve retornar 10 usuários (todos têm CPF)
