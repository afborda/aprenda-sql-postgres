-- ==============================================
-- FASE 4: AGREGAÇÕES E RESUMOS
-- Exercício 4.2: Cláusula HAVING e Filtros Avançados
-- ==============================================
-- ⏱️  Tempo estimado: 10 minutos
-- 📚 Conceitos: HAVING, filtros em agregações, subconsultas

-- ❓ O que você aprenderá:
-- 1. HAVING - filtrar grupos (como WHERE para agregações)
-- 2. Diferenciar WHERE (antes) de HAVING (depois)
-- 3. Combinar múltiplas condições
-- 4. Análises avançadas

-- ==============================================
-- EXERCÍCIO 1: Usuários com 2 ou mais posts
-- ==============================================
-- Retorne usuários que postaram 2 ou mais vezes
-- Colunas: full_name, total_posts
-- Dica: Use HAVING COUNT(p.id) >= 2

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 2: Usuários com gasto acima de R$ 1000
-- ==============================================
-- Retorne usuários que gastaram mais de R$ 1000
-- Colunas: full_name, total_gasto
-- Dica: Use HAVING SUM(amount) > 1000

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 3: Posts com média de likes acima de 100
-- ==============================================
-- Retorne posts por usuário com média de likes > 100
-- Colunas: full_name, total_posts, media_likes
-- Ordenar por media_likes DESC

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 4: Transações por tipo (purchase only)
-- ==============================================
-- Retorne suma de purchases por usuário (apenas purchase)
-- Colunas: full_name, total_purchases
-- Usar WHERE antes de GROUP BY
-- Ordenar por total_purchases DESC

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 5: Contar posts e filtrar
-- ==============================================
-- Encontre usuários com exatamente 1 post
-- Colunas: full_name, total_posts
-- Dica: HAVING COUNT(p.id) = 1

-- SUA RESPOSTA:
-- [ESCREVA AQUI]


