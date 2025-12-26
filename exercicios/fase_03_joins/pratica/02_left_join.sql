-- ==============================================
-- FASE 3: RELACIONAMENTOS E JOINS
-- Exercício 3.2: LEFT JOIN
-- ==============================================
-- ⏱️  Tempo estimado: 12 minutos
-- 📚 Conceitos: LEFT JOIN, NULL checks, usuários sem dados

-- ❓ O que você aprenderá:
-- 1. LEFT JOIN - retorna TODOS da tabela esquerda
-- 2. Identificar registros sem relacionamento (IS NULL)
-- 3. Diferença entre INNER e LEFT JOIN
-- 4. Contar registros relacionados

-- ==============================================
-- EXERCÍCIO 1: Usuários e seus posts (com e sem posts)
-- ==============================================
-- Retorne TODOS usuários, mesmo sem posts
-- Colunas: full_name, COUNT(posts) as total_posts
-- Agrupar por usuário
-- Dica: LEFT JOIN posts e GROUP BY

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 2: Usuários que NUNCA postaram
-- ==============================================
-- Retorne apenas usuários SEM posts
-- Colunas: full_name, email
-- Dica: LEFT JOIN + WHERE posts.id IS NULL

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 3: Usuários e transações (todos)
-- ==============================================
-- Retorne todos usuários com contagem de transações
-- Colunas: full_name, total_transacoes
-- Incluir usuários sem transações (COUNT = 0)

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 4: Posts com ou sem comentários
-- ==============================================
-- Retorne todos posts com contagem de comentários
-- Colunas: title, total_comentarios
-- Ordenar por total_comentarios DESC

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 5: Usuários inativos (sem transações)
-- ==============================================
-- Encontre usuários que nunca fizeram transação
-- Colunas: full_name, state, created_at
-- Dica: LEFT JOIN + WHERE transactions.id IS NULL

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================

