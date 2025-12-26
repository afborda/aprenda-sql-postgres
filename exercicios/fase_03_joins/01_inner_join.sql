-- ==============================================
-- FASE 3: RELACIONAMENTOS E JOINS
-- Exercício 3.1: INNER JOIN Básico
-- ==============================================
-- ⏱️  Tempo estimado: 10 minutos
-- 📚 Conceitos: INNER JOIN, aliases, relacionamentos

-- ❓ O que você aprenderá:
-- 1. INNER JOIN - combinar tabelas relacionadas
-- 2. Aliases de tabelas (u, p, t)
-- 3. Relacionamentos 1:N (um usuário tem muitos posts)
-- 4. Selecionar colunas de múltiplas tabelas

-- ==============================================
-- EXERCÍCIO 1: Posts com nome do autor
-- ==============================================
-- Retorne posts mostrando título e nome completo do autor
-- Colunas: title, full_name (como 'autor')
-- Dica: posts.user_id = users.id

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 2: Transações com nome do usuário
-- ==============================================
-- Retorne transações mostrando amount, merchant e nome do usuário
-- Colunas: amount, merchant, full_name (como 'cliente')
-- Ordenar por amount DESC

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 3: Comentários com título do post
-- ==============================================
-- Retorne comentários mostrando conteúdo e título do post
-- Colunas: content (do comentário), title (do post)
-- Limite: 5 resultados

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 4: Posts com views e autor
-- ==============================================
-- Retorne posts com mais de 300 views, mostrando autor
-- Colunas: title, views, full_name (como 'autor')
-- Ordenar por views DESC

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 5: Transações de usuários de SP
-- ==============================================
-- Retorne transações apenas de usuários do estado SP
-- Colunas: full_name, state, amount, transaction_type
-- Dica: Combine JOIN com WHERE

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 6: Posts com likes e cidade do autor
-- ==============================================
-- Retorne posts mostrando autor e cidade
-- Colunas: title, likes, full_name, city
-- Ordenar por likes DESC
-- Limite: 5 resultados

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- VALIDAÇÃO
-- ==============================================
-- Ex 1: Deve retornar posts com nomes dos autores
-- Ex 2: Transações ordenadas por valor
-- Ex 3: 5 comentários com títulos dos posts
-- Ex 4: Posts virais (>300 views) com autores
-- Ex 5: Apenas transações de usuários de SP
-- Ex 6: Top 5 posts por likes com localização
