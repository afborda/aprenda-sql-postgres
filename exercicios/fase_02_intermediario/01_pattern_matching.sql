-- ==============================================
-- FASE 2: CONSULTAS INTERMEDIÁRIAS
-- Exercício 2.1: Pattern Matching com LIKE
-- ==============================================
-- ⏱️  Tempo estimado: 8 minutos
-- 📚 Conceitos: LIKE, wildcards (%, _), ILIKE

-- ❓ O que você aprenderá:
-- 1. LIKE para busca de padrões
-- 2. % (qualquer número de caracteres)
-- 3. _ (um único caractere)
-- 4. ILIKE (case-insensitive)

-- ==============================================
-- EXERCÍCIO 1: Buscar por prefixo
-- ==============================================
-- Encontre usuários cujo nome COMEÇA com 'Maria'
-- Colunas: full_name, email
-- Dica: Use LIKE 'Maria%'

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 2: Buscar por contém
-- ==============================================
-- Encontre usuários que TÊM 'Silva' no nome em qualquer posição
-- Colunas: full_name, state
-- Dica: Use LIKE '%Silva%'

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 3: Buscar por sufixo
-- ==============================================
-- Encontre usuários cujo nome TERMINA com 'Silva'
-- Colunas: full_name, email

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 4: Buscar emails por domínio
-- ==============================================
-- Encontre usuários com email terminado em '.com'
-- Colunas: full_name, email
-- Dica: Use LIKE '%.com'

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 5: Busca case-insensitive
-- ==============================================
-- Encontre usuários com 'silva' no nome (maiúsculas e minúsculas)
-- Colunas: full_name, email
-- Dica: Use ILIKE (não é case-sensitive)

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 6: Underscore (_) para um caractere
-- ==============================================
-- Encontre transações onde o merchant começa com 'S' 
-- e tem exatamente 7 caracteres antes do espaço
-- Colunas: merchant, amount
-- Dica: 'S______' casa exatamente 7 caracteres após S

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- VALIDAÇÃO
-- ==============================================
-- Ex 1: Deve retornar 1 usuário (Maria Oliveira)
-- Ex 2: Deve retornar usuários com Silva no nome
-- Ex 3: Deve retornar usuários terminados em Silva
-- Ex 4: Deve retornar emails com domínio .com
-- Ex 5: Busca case-insensitive funciona
-- Ex 6: Busca com underscore funciona
