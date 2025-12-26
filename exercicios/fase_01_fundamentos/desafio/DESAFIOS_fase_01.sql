-- ==============================================
-- FASE 1: FUNDAMENTOS SQL
-- DESAFIOS CONTEXTUALIZADOS
-- ==============================================
-- 🎯 Cenário: Você é analista de dados de uma fintech

-- ==============================================
-- DESAFIO 1: Análise de Cobertura Regional
-- ==============================================
-- 📋 Contexto: O diretor quer saber em quais estados 
-- temos usuários ativos. Qual é a penetração do produto?
--
-- Sua tarefa:
-- - Retorne todos os estados onde temos usuários
-- - Retorne o nome de todos os usuários (ordenado por estado depois nome)
-- - Mostrar apenas estados com "SP", "RJ", "MG"

SELECT state, full_name, email
FROM users
WHERE state IN ('SP', 'RJ', 'MG')
ORDER BY state ASC, full_name ASC;

-- ✅ Resposta esperada: 6 linhas (2 SP, 2 RJ, 2 MG)


-- ==============================================
-- DESAFIO 2: Identificar Top Influencers
-- ==============================================
-- 📋 Contexto: Marketing quer saber quem são os usuários 
-- mais ativos na plataforma (maiores geradores de engajamento)
--
-- Sua tarefa:
-- - Retorne posts ordenados por visualizações
-- - Mostre apenas os 3 top posts
-- - Colunas: title, views, likes

SELECT title, views, likes
FROM posts
ORDER BY views DESC
LIMIT 3;

-- ✅ Resposta esperada: 3 posts com maiores views


-- ==============================================
-- DESAFIO 3: Análise de Fraude - Transações Altas
-- ==============================================
-- 📋 Contexto: Equipe de compliance quer encontrar 
-- potenciais fraudes. Transações acima de R$ 1000 precisam 
-- de análise manual.
--
-- Sua tarefa:
-- - Retorne transações acima de R$ 1000
-- - Ordene por valor (maior para menor)
-- - Colunas: user_id, amount, transaction_type, created_at

SELECT user_id, amount, transaction_type, created_at
FROM transactions
WHERE amount > 1000
ORDER BY amount DESC;

-- ✅ Resposta esperada: 2 linhas (1200, 2500)


-- ==============================================
-- DESAFIO 4: Dados Incompletos - Verificar Integridade
-- ==============================================
-- 📋 Contexto: Você precisa encontrar usuários sem 
-- telefone registrado para enviar SMS de confirmação.
--
-- Sua tarefa:
-- - Retorne usuários SEM telefone
-- - Ordenar por nome
-- - Colunas: full_name, email, phone

SELECT full_name, email, phone
FROM users
WHERE phone IS NULL
ORDER BY full_name ASC;

-- ✅ Resposta esperada: Nenhuma linha (todos têm telefone)


-- ==============================================
-- DESAFIO 5: Produtos Mais Antigos
-- ==============================================
-- 📋 Contexto: Sistema de retenção. Você precisa 
-- encontrar usuários antigos para oferecer prêmios de lealdade.
--
-- Sua tarefa:
-- - Retorne os 3 usuários MAIS ANTIGOS (primeiro criados)
-- - Colunas: full_name, created_at
-- - Ordem: mais antigos primeiro

SELECT full_name, created_at
FROM users
ORDER BY created_at ASC
LIMIT 3;

-- ✅ Resposta esperada: Primeiros 3 usuários criados

