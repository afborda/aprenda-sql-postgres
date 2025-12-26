-- ==============================================
-- FASE 2: CONSULTAS INTERMEDIÁRIAS
-- Exercício 2.3: Funções de String
-- ==============================================
-- ⏱️  Tempo estimado: 12 minutos
-- 📚 Conceitos: UPPER, LOWER, LENGTH, SUBSTRING, CONCAT

-- ❓ O que você aprenderá:
-- 1. UPPER() - converter para maiúsculas
-- 2. LOWER() - converter para minúsculas
-- 3. LENGTH() - tamanho da string
-- 4. SUBSTRING() - extrair parte da string
-- 5. CONCAT() - juntar strings

-- ==============================================
-- EXERCÍCIO 1: Converter para maiúsculas
-- ==============================================
-- Retorne nomes em MAIÚSCULAS
-- Colunas: original_name, uppercase_name
-- Dica: SELECT full_name, UPPER(full_name) FROM users

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 2: Converter para minúsculas
-- ==============================================
-- Retorne emails em minúsculas
-- Colunas: email, email_lower
-- Dica: Use LOWER()

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 3: Tamanho do nome
-- ==============================================
-- Retorne nomes com seu comprimento
-- Colunas: full_name, name_length
-- Ordenar por name_length DESC
-- Dica: Use LENGTH()

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 4: Extrair parte da string
-- ==============================================
-- Retorne os primeiros 3 caracteres do CPF
-- Colunas: cpf, cpf_start, full_name
-- Dica: SUBSTRING(cpf, 1, 3)

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 5: Concatenar strings
-- ==============================================
-- Combine nome e cidade em uma coluna
-- Colunas: full_name, city, user_location (nome - cidade)
-- Dica: CONCAT(full_name, ' - ', city)

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 6: Buscar nomes longos
-- ==============================================
-- Retorne usuários com nomes > 25 caracteres
-- Colunas: full_name, name_length
-- Dica: Combine LENGTH() com WHERE

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- VALIDAÇÃO
-- ==============================================
-- Ex 1: Todos nomes em MAIÚSCULAS
-- Ex 2: Todos emails em minúsculas
-- Ex 3: Nomes ordenados por comprimento (decrescente)
-- Ex 4: Primeiros 3 caracteres de CPF mostrados
-- Ex 5: Nome e cidade combinados corretamente
-- Ex 6: Apenas usuários com nomes > 25 caracteres
