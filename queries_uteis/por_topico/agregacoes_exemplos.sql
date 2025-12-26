-- ==============================================
-- QUERIES ÚTEIS: AGREGAÇÕES EXPLICADAS
-- Aprenda com exemplos reais do seu banco
-- ==============================================

-- ==============================================
-- COUNT: Contar registros
-- ==============================================

-- ✅ Exemplo 1: Total de usuários
SELECT COUNT(*) as "Total de Usuários"
FROM users;

-- Resultado: 10


-- ✅ Exemplo 2: Total de posts por usuário
SELECT 
    u.full_name as "Usuário",
    COUNT(p.id) as "Total de Posts"
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
GROUP BY u.id, u.full_name
ORDER BY COUNT(p.id) DESC;

-- Resultado: Usuários ordenados por produtividade


-- ✅ Exemplo 3: Contar apenas fraudes
SELECT 
    COUNT(*) as "Total de Análises",
    COUNT(CASE WHEN is_fraud = TRUE THEN 1 END) as "Fraudes Confirmadas",
    COUNT(CASE WHEN is_fraud = FALSE THEN 1 END) as "Legítimas"
FROM fraud_data;

-- Resultado: Taxa de fraude no banco

-- ==============================================
-- SUM: Somar valores
-- ==============================================

-- ✅ Exemplo 4: Total transacionado
SELECT 
    SUM(amount) as "Total (R$)",
    COUNT(*) as "Quantidade"
FROM transactions;

-- Resultado: Volume total e quantidade


-- ✅ Exemplo 5: Volume por tipo de transação
SELECT 
    transaction_type as "Tipo",
    SUM(amount) as "Volume Total (R$)",
    COUNT(*) as "Quantidade",
    ROUND(AVG(amount), 2) as "Ticket Médio (R$)"
FROM transactions
GROUP BY transaction_type
ORDER BY SUM(amount) DESC;

-- Resultado: Análise por tipo de transação

-- ==============================================
-- AVG, MIN, MAX: Estatísticas
-- ==============================================

-- ✅ Exemplo 6: Estatísticas de transações
SELECT 
    AVG(amount) as "Média (R$)",
    MIN(amount) as "Mínima (R$)",
    MAX(amount) as "Máxima (R$)",
    STDDEV(amount) as "Desvio Padrão"
FROM transactions;

-- Resultado: Distribuição de valores


-- ✅ Exemplo 7: Posts mais e menos engajados
SELECT 
    'Views' as "Métrica",
    MAX(views) as "Máximo",
    MIN(views) as "Mínimo",
    AVG(views) as "Média"
FROM posts
UNION ALL
SELECT 
    'Likes' as "Métrica",
    MAX(likes),
    MIN(likes),
    AVG(likes)
FROM posts;

-- Resultado: Comparação de engajamento

-- ==============================================
-- GROUP BY: Agrupar dados
-- ==============================================

-- ✅ Exemplo 8: Volume por estado
SELECT 
    u.state as "Estado",
    COUNT(DISTINCT u.id) as "Usuários",
    COUNT(t.id) as "Transações",
    SUM(t.amount) as "Volume Total (R$)"
FROM users u
LEFT JOIN transactions t ON u.id = t.user_id
GROUP BY u.state
ORDER BY SUM(t.amount) DESC;

-- Resultado: Mapa de penetração por região


-- ✅ Exemplo 9: Análise por método de pagamento
SELECT 
    payment_method as "Método",
    COUNT(*) as "Quantidade",
    SUM(amount) as "Volume (R$)",
    AVG(amount) as "Ticket Médio (R$)",
    COUNT(CASE WHEN status = 'failed' THEN 1 END) as "Falhas"
FROM transactions
GROUP BY payment_method
ORDER BY SUM(amount) DESC;

-- Resultado: Preferências de pagamento

-- ==============================================
-- HAVING: Filtrar grupos
-- ==============================================

-- ✅ Exemplo 10: Usuários com MAIS de 1 transação
SELECT 
    u.full_name as "Usuário",
    COUNT(t.id) as "Transações",
    SUM(t.amount) as "Volume (R$)"
FROM users u
LEFT JOIN transactions t ON u.id = t.user_id
GROUP BY u.id, u.full_name
HAVING COUNT(t.id) > 1
ORDER BY COUNT(t.id) DESC;

-- Resultado: Usuários ativos


-- ✅ Exemplo 11: Estados com MAIS de 1 usuário
SELECT 
    city as "Cidade",
    COUNT(*) as "Usuários"
FROM users
GROUP BY city
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC;

-- Resultado: Cidades com múltiplos usuários

-- ==============================================
-- CASE em Agregações: Lógica condicional
-- ==============================================

-- ✅ Exemplo 12: Análise de risco
SELECT 
    COUNT(*) as "Total de Análises",
    SUM(CASE WHEN fraud_score > 0.7 THEN 1 ELSE 0 END) as "Alto Risco",
    SUM(CASE WHEN fraud_score BETWEEN 0.4 AND 0.7 THEN 1 ELSE 0 END) as "Médio Risco",
    SUM(CASE WHEN fraud_score < 0.4 THEN 1 ELSE 0 END) as "Baixo Risco"
FROM fraud_data;

-- Resultado: Distribuição de riscos


-- ✅ Exemplo 13: Sucesso por tipo de transação
SELECT 
    transaction_type as "Tipo",
    COUNT(*) as "Total",
    SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) as "Sucesso",
    SUM(CASE WHEN status = 'failed' THEN 1 ELSE 0 END) as "Falha",
    ROUND(100.0 * SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) / COUNT(*), 2) as "Taxa Sucesso %"
FROM transactions
GROUP BY transaction_type
ORDER BY "Taxa Sucesso %" DESC;

-- Resultado: Confiabilidade por tipo de operação
