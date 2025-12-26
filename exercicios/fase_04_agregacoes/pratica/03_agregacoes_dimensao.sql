-- ==============================================
-- FASE 4: AGREGAÇÕES E RESUMOS
-- Exercício 4.3: Agregações por Dimensão (Estado, Tipo)
-- ==============================================
-- ⏱️  Tempo estimado: 12 minutos
-- 📚 Conceitos: GROUP BY múltiplas colunas, análise dimensional

-- ❓ O que você aprenderá:
-- 1. GROUP BY com múltiplas colunas
-- 2. Análise por dimensão (estado, tipo, etc)
-- 3. Combinar múltiplas agregações
-- 4. Relatórios estruturados

-- ==============================================
-- EXERCÍCIO 1: Usuários e posts por estado
-- ==============================================
-- Retorne total de usuários e posts por estado
-- Colunas: state, total_usuarios, total_posts
-- Ordenar por total_posts DESC

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 2: Transações por tipo
-- ==============================================
-- Retorne soma e contagem de transações por tipo
-- Colunas: transaction_type, total_transacoes, valor_total
-- Ordenar por valor_total DESC

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 3: Análise por estado e tipo de transação
-- ==============================================
-- Retorne transações agrupadas por estado e tipo
-- Colunas: state, transaction_type, total_valor
-- Ordenar por state, valor_total DESC

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 4: Engajamento por usuário e tipo
-- ==============================================
-- Retorne posts e comentários por usuário
-- Colunas: full_name, total_posts, total_comentarios
-- Ordenar por total_posts DESC

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 5: Fraudes por estado
-- ==============================================
-- Retorne contagem de fraudes por estado
-- Colunas: state, total_fraudes, score_medio
-- Apenas com fraudes detectadas (is_fraud = TRUE)
-- Ordenar por total_fraudes DESC

-- SUA RESPOSTA:
-- [ESCREVA AQUI]


