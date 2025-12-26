-- ==============================================
-- FASE 2: CONSULTAS INTERMEDIÁRIAS
-- DESAFIOS CONTEXTUALIZADOS
-- ==============================================
-- 🎯 Cenário: Você é analista de dados de uma fintech

-- ==============================================
-- DESAFIO 1: Busca de Email por Domínio
-- ==============================================
-- 📋 Contexto: Marketing quer segmentar campanhas por provedor de email
--
-- Sua tarefa:
-- - Retorne usuários com emails de domínios específicos
-- - Mostre full_name, email para todos os usuários com @email.com
-- - Ordene alfabeticamente

SELECT full_name, email
FROM users
WHERE email LIKE '%@email.com'
ORDER BY full_name ASC;

-- ✅ Resposta esperada: 10 linhas (todos os usuários têm @email.com)


-- ==============================================
-- DESAFIO 2: Análise de Nomes Longos
-- ==============================================
-- 📋 Contexto: Sistema de SMS tem limite de caracteres. 
-- Quais usuários têm nomes muito longos?
--
-- Sua tarefa:
-- - Retorne usuários com nomes maiores que 20 caracteres
-- - Colunas: full_name, LENGTH(full_name) AS comprimento
-- - Ordene por comprimento DESC

SELECT 
    full_name, 
    LENGTH(full_name) AS comprimento
FROM users
WHERE LENGTH(full_name) > 20
ORDER BY comprimento DESC;

-- ✅ Resposta esperada: 8 linhas (nomes longos)


-- ==============================================
-- DESAFIO 3: Transações em Range Específico
-- ==============================================
-- 📋 Contexto: Política de compliance. Transações entre R$ 100 e R$ 500
-- requerem verificação padrão; acima disso requer análise manual.
--
-- Sua tarefa:
-- - Retorne transações entre R$ 100 e R$ 500
-- - Colunas: user_id, amount, transaction_type
-- - Ordene por amount DESC

SELECT user_id, amount, transaction_type
FROM transactions
WHERE amount BETWEEN 100 AND 500
ORDER BY amount DESC;

-- ✅ Resposta esperada: 4 linhas (transações neste range)


-- ==============================================
-- DESAFIO 4: Normalização de Dados
-- ==============================================
-- 📋 Contexto: Sistema de busca é case-sensitive. 
-- Você precisa encontrar usuários com "silva" em qualquer caso.
--
-- Sua tarefa:
-- - Retorne usuários com "silva" no nome (case-insensitive)
-- - Colunas: full_name, email
-- - Use ILIKE

SELECT full_name, email
FROM users
WHERE full_name ILIKE '%silva%';

-- ✅ Resposta esperada: 1 linha (João da Silva Santos)


-- ==============================================
-- DESAFIO 5: Formatação de Dados para Relatório
-- ==============================================
-- 📋 Contexto: Relatório precisa exibir dados formatados
--
-- Sua tarefa:
-- - Retorne nomes em MAIÚSCULAS e emails em minúsculas
-- - Colunas: nome_formatado, email_formatado
-- - Use UPPER() e LOWER()

SELECT 
    UPPER(full_name) AS nome_formatado,
    LOWER(email) AS email_formatado
FROM users
LIMIT 5;

-- ✅ Resposta esperada: 5 linhas com dados formatados


-- ==============================================
-- DESAFIO 6: Análise Temporal de Contas
-- ==============================================
-- 📋 Contexto: RH quer saber qual é a idade média das contas
--
-- Sua tarefa:
-- - Mostre data atual e compare com criação de usuários
-- - Colunas: full_name, created_at, AGE(NOW(), created_at) AS idade_conta
-- - Ordene por data de criação

SELECT 
    full_name, 
    created_at,
    AGE(NOW(), created_at) AS idade_conta
FROM users
ORDER BY created_at ASC;

-- ✅ Resposta esperada: 10 linhas com idade de cada conta

