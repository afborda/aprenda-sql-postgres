-- ==============================================
-- FASE 2: CONSULTAS INTERMEDIÁRIAS
-- Exercício 2.4: Funções de Data
-- ==============================================
-- ⏱️  Tempo estimado: 10 minutos
-- 📚 Conceitos: NOW(), CURRENT_DATE, DATE(), AGE, DATE_TRUNC, EXTRACT

-- ❓ O que você aprenderá:
-- 1. NOW() - data e hora atual
-- 2. CURRENT_DATE - data atual
-- 3. DATE() - extrair apenas data
-- 4. AGE() - diferença entre datas
-- 5. EXTRACT() - extrair partes da data
-- 6. DATE_TRUNC() - truncar data

-- ==============================================
-- EXERCÍCIO 1: Data e hora atual
-- ==============================================
-- Mostre data/hora atual e data atual
-- Colunas: data_hora_atual, data_atual

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 2: Idade da conta em dias
-- ==============================================
-- Para cada usuário, calcule quantos dias tem a conta
-- Colunas: full_name, created_at, dias_desde_criacao
-- Dica: Use AGE(NOW(), created_at)

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 3: Extrair apenas a data
-- ==============================================
-- Mostre criação de posts sem a hora
-- Colunas: title, created_at, data_criacao
-- Dica: DATE(created_at)

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 4: Extrair ano de uma data
-- ==============================================
-- Retorne ano de criação de cada usuário
-- Colunas: full_name, created_at, ano
-- Dica: EXTRACT(YEAR FROM created_at)

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 5: Extrair mês e dia
-- ==============================================
-- Retorne mês e dia de nascimento de transações
-- Colunas: user_id, amount, mes, dia
-- Dica: EXTRACT(MONTH FROM ...), EXTRACT(DAY FROM ...)

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- EXERCÍCIO 6: Usuários criados no último mês
-- ==============================================
-- Retorne usuários criados nos últimos 30 dias
-- Colunas: full_name, created_at
-- Dica: created_at >= NOW() - INTERVAL '30 days'

-- SUA RESPOSTA:
-- [ESCREVA AQUI]




-- ==============================================
-- VALIDAÇÃO
-- ==============================================
-- Ex 1: NOW() retorna data/hora, CURRENT_DATE retorna só data
-- Ex 2: AGE retorna intervalo de tempo (dias, meses, anos)
-- Ex 3: DATE() remove a hora
-- Ex 4: EXTRACT(YEAR) retorna 2024 ou 2025
-- Ex 5: EXTRACT(MONTH) de 1-12, EXTRACT(DAY) de 1-31
-- Ex 6: Apenas usuários dos últimos 30 dias
