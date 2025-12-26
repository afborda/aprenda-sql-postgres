-- ==============================================
-- FASE 3: RELACIONAMENTOS E JOINS
-- Exercício 3.3: Múltiplos JOINs
-- ==============================================
-- ⏱️  Tempo estimado: 15 minutos
-- 📚 Conceitos: Múltiplos JOINs, 3+ tabelas, análises complexas

-- ❓ O que você aprenderá:
-- 1. Combinar 3 ou mais tabelas
-- 2. INNER JOIN + LEFT JOIN juntos
-- 3. Análises complexas de dados
-- 4. Organização de queries grandes

-- ==============================================
-- EXERCÍCIO 1: Análise de fraudes completa
-- ==============================================
-- Retorne fraudes com dados do usuário e transação
-- Colunas: fraud_type, fraud_score, full_name, amount, merchant
-- Apenas fraudes confirmadas (is_fraud = TRUE)
-- Tabelas: fraud_data, users, transactions

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 2: Posts, autores e comentários
-- ==============================================
-- Liste posts com autor e total de comentários
-- Colunas: title, autor (full_name), views, total_comentarios
-- Ordenar por total_comentarios DESC
-- Tabelas: posts, users, comments

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 3: Transações com usuário e conta
-- ==============================================
-- Retorne transações mostrando dados do usuário e conta
-- Colunas: full_name, amount, transaction_type, account_type, payment_method
-- Ordenar por amount DESC
-- Limite: 5 transações
-- Tabelas: transactions, users, user_accounts

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 4: Comentários com post e autores
-- ==============================================
-- Retorne comentários mostrando:
-- - Conteúdo do comentário
-- - Título do post
-- - Autor do comentário
-- - Autor do post
-- Colunas: content, title, autor_comentario, autor_post
-- Tabelas: comments, posts, users (2x)

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 5: Dashboard de usuários
-- ==============================================
-- Para cada usuário, mostre:
-- - Nome completo
-- - Total de posts
-- - Total de comentários
-- - Total de transações
-- Ordenar por total_posts DESC
-- Tabelas: users, posts, comments, transactions

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- VALIDAÇÃO
-- ==============================================
-- Ex 1: Fraudes confirmadas com todos os detalhes
-- Ex 2: Posts com contagem de comentários
-- Ex 3: Top 5 transações com dados completos
-- Ex 4: Comentários mostrando autor do post e comentário
-- Ex 5: Dashboard completo de atividade por usuário
