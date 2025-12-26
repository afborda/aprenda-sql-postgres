-- ==============================================
-- FASE 1: FUNDAMENTOS SQL
-- Exercício 1.3: Ordenação com ORDER BY e LIMIT
-- ==============================================
-- ⏱️  Tempo estimado: 10 minutos
-- 📚 Conceitos: ORDER BY, ASC, DESC, LIMIT, combinações

-- ❓ O que você aprenderá:
-- 1. Ordenar crescente (ASC)
-- 2. Ordenar decrescente (DESC)
-- 3. Combinar ORDER BY com LIMIT
-- 4. Ordenar por múltiplas colunas

-- ==============================================
-- EXERCÍCIO 1: Usuários ordenados por nome
-- ==============================================
-- Retorne todos os usuários ordenados alfabeticamente por nome
-- Colunas: full_name, email
-- Dica: ORDER BY full_name ASC (ou sem ASC)

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 2: Posts mais visualizados
-- ==============================================
-- Retorne posts ordenados por visualizações (maior para menor)
-- Colunas: title, views
-- Retorne apenas os 3 PRIMEIROS
-- Dica: Use ORDER BY views DESC LIMIT 3

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 3: Transações menores
-- ==============================================
-- Retorne as 5 MENORES transações
-- Colunas: user_id, amount, created_at
-- Ordenar por amount crescente

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 4: Usuários por estado (ordem alfabética)
-- ==============================================
-- Retorne usuários ordenados por:
-- 1º: state (alfabético)
-- 2º: full_name (alfabético)
-- Colunas: state, full_name, city

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 5: Usuários mais recentes
-- ==============================================
-- Retorne os 5 usuários mais RECENTES (últimos criados)
-- Colunas: full_name, created_at
-- Dica: Order by created_at DESC

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 6: Posts com mais engajamento
-- ==============================================
-- Retorne os 3 posts com MAIS likes
-- Colunas: title, likes, views
-- Ordenar por likes DESC

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- VALIDAÇÃO
-- ==============================================
-- Ex 1: 10 linhas, ordenadas alfabeticamente (Ana, Beatriz, Carlos...)
-- Ex 2: 3 linhas, order DESC views (650, 540, 510)
-- Ex 3: 5 linhas, ordem crescente (45.00, 89.99, 110.00, 150.50, 180.50)
-- Ex 4: 10 linhas, agrupado por state depois nome
-- Ex 5: 5 linhas, usuários mais recentes
-- Ex 6: 3 linhas, posts com mais likes
