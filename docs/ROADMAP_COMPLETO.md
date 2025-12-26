# 🎯 Roadmap Completo SQL PostgreSQL - Do Básico ao Avançado

## 📚 Índice
- [Fase 1: Fundamentos SQL](#fase-1-fundamentos-sql)
- [Fase 2: Consultas Intermediárias](#fase-2-consultas-intermediárias)
- [Fase 3: Relacionamentos e JOINs](#fase-3-relacionamentos-e-joins)
- [Fase 4: Agregação e Agrupamento](#fase-4-agregação-e-agrupamento)
- [Fase 5: Subconsultas e CTEs](#fase-5-subconsultas-e-ctes)
- [Fase 6: Window Functions](#fase-6-window-functions)
- [Fase 7: Performance e Otimização](#fase-7-performance-e-otimização)
- [Fase 8: Índices Avançados](#fase-8-índices-avançados)
- [Fase 9: Transactions e Locks](#fase-9-transactions-e-locks)
- [Fase 10: Stored Procedures e Triggers](#fase-10-stored-procedures-e-triggers)
- [Fase 11: Análise de Fraudes](#fase-11-análise-de-fraudes)
- [Fase 12: Big Data e Particionamento](#fase-12-big-data-e-particionamento)

---

## Fase 1: Fundamentos SQL
**Duração estimada: 1-2 semanas**

### 🎓 Conceitos a Aprender
- SELECT básico
- Cláusula WHERE
- Operadores de comparação (=, !=, <, >, <=, >=)
- Operadores lógicos (AND, OR, NOT)
- Ordenação com ORDER BY
- Limitação de resultados com LIMIT

### 📝 Exercícios Práticos

#### Exercício 1.1: SELECT Básico
```sql
-- Buscar todos os usuários
SELECT * FROM users;

-- Buscar apenas nome e email
SELECT full_name, email FROM users;

-- Buscar os 5 primeiros usuários
SELECT * FROM users LIMIT 5;
```

#### Exercício 1.2: Filtragem com WHERE
```sql
-- Usuários de São Paulo
SELECT * FROM users WHERE city = 'São Paulo';

-- Usuários que não são de SP
SELECT * FROM users WHERE state != 'SP';

-- Usuários criados após determinada data
SELECT * FROM users 
WHERE created_at > '2024-01-01';
```

#### Exercício 1.3: Operadores Lógicos
```sql
-- Usuários de SP ou RJ
SELECT * FROM users 
WHERE state = 'SP' OR state = 'RJ';

-- Usuários de SP com username começando com 'j'
SELECT * FROM users 
WHERE state = 'SP' AND username LIKE 'j%';

-- Usuários que NÃO são de SP, RJ ou MG
SELECT * FROM users 
WHERE state NOT IN ('SP', 'RJ', 'MG');
```

#### Exercício 1.4: Ordenação
```sql
-- Ordenar por nome alfabeticamente
SELECT * FROM users ORDER BY full_name;

-- Ordenar por data de criação (mais recentes primeiro)
SELECT * FROM users ORDER BY created_at DESC;

-- Ordenar por estado e depois por cidade
SELECT * FROM users ORDER BY state, city;
```

### 🎯 Desafios da Fase 1
1. Liste todos os usuários com email do Gmail
2. Encontre usuários cujo nome completo tenha mais de 20 caracteres
3. Liste os 3 usuários mais antigos da plataforma
4. Busque usuários de estados da região Sul (PR, SC, RS)

### 📖 Conceitos Importantes
**Como o SQL é Lido?**
1. FROM - Define a tabela
2. WHERE - Filtra as linhas
3. SELECT - Seleciona as colunas
4. ORDER BY - Ordena o resultado
5. LIMIT - Limita quantidade de registros

---

## Fase 2: Consultas Intermediárias
**Duração estimada: 1-2 semanas**

### 🎓 Conceitos a Aprender
- LIKE e Pattern Matching
- IN, NOT IN, BETWEEN
- IS NULL, IS NOT NULL
- DISTINCT
- Funções de String (UPPER, LOWER, CONCAT, SUBSTRING)
- Funções de Data (NOW(), CURRENT_DATE, DATE_TRUNC, AGE)
- CASE WHEN (lógica condicional)

### 📝 Exercícios Práticos

#### Exercício 2.1: Pattern Matching
```sql
-- Usuários com nome começando com 'Maria'
SELECT * FROM users WHERE full_name LIKE 'Maria%';

-- Usuários com 'Silva' no nome
SELECT * FROM users WHERE full_name LIKE '%Silva%';

-- Usuários com email do domínio .com
SELECT * FROM users WHERE email LIKE '%.com';

-- CPFs começando com 123
SELECT * FROM users WHERE cpf LIKE '123%';
```

#### Exercício 2.2: Operadores IN e BETWEEN
```sql
-- Transações de tipos específicos
SELECT * FROM transactions 
WHERE transaction_type IN ('purchase', 'transfer');

-- Transações entre valores
SELECT * FROM transactions 
WHERE amount BETWEEN 100 AND 500;

-- Posts com visualizações entre 200 e 400
SELECT * FROM posts 
WHERE views BETWEEN 200 AND 400;
```

#### Exercício 2.3: Trabalhando com NULL
```sql
-- Usuários sem telefone cadastrado
SELECT * FROM users WHERE phone IS NULL;

-- Transações com merchant definido
SELECT * FROM transactions WHERE merchant IS NOT NULL;

-- Fraudes ainda não resolvidas
SELECT * FROM fraud_data WHERE resolved_at IS NULL;
```

#### Exercício 2.4: DISTINCT
```sql
-- Cidades únicas de usuários
SELECT DISTINCT city FROM users;

-- Estados únicos
SELECT DISTINCT state FROM users ORDER BY state;

-- Tipos únicos de transação
SELECT DISTINCT transaction_type FROM transactions;
```

#### Exercício 2.5: Funções de String
```sql
-- Nome em maiúsculas
SELECT UPPER(full_name) as nome_maiusculo FROM users;

-- Email em minúsculas
SELECT LOWER(email) as email_minusculo FROM users;

-- Concatenar nome e cidade
SELECT CONCAT(full_name, ' - ', city) as usuario_cidade FROM users;

-- Primeiros 3 caracteres do CPF
SELECT SUBSTRING(cpf, 1, 3) as inicio_cpf FROM users;

-- Tamanho do nome
SELECT full_name, LENGTH(full_name) as tamanho_nome FROM users;
```

#### Exercício 2.6: Funções de Data
```sql
-- Data e hora atual
SELECT NOW();

-- Data atual
SELECT CURRENT_DATE;

-- Idade da conta em dias
SELECT full_name, 
       AGE(NOW(), created_at) as idade_conta 
FROM users;

-- Usuários criados no último mês
SELECT * FROM users 
WHERE created_at >= NOW() - INTERVAL '1 month';

-- Transações por data (sem hora)
SELECT DATE(created_at) as data, COUNT(*) 
FROM transactions 
GROUP BY DATE(created_at);
```

#### Exercício 2.7: CASE WHEN
```sql
-- Classificar posts por popularidade
SELECT title, views,
    CASE 
        WHEN views > 500 THEN 'Viral'
        WHEN views > 300 THEN 'Popular'
        WHEN views > 100 THEN 'Moderado'
        ELSE 'Baixo'
    END as popularidade
FROM posts;

-- Classificar transações por valor
SELECT user_id, amount,
    CASE 
        WHEN amount > 1000 THEN 'Alto valor'
        WHEN amount > 500 THEN 'Médio valor'
        ELSE 'Baixo valor'
    END as categoria_valor
FROM transactions;

-- Status de fraude simplificado
SELECT id, fraud_score,
    CASE 
        WHEN fraud_score > 0.7 THEN 'Alto risco'
        WHEN fraud_score > 0.4 THEN 'Médio risco'
        ELSE 'Baixo risco'
    END as nivel_risco
FROM fraud_data;
```

### 🎯 Desafios da Fase 2
1. Encontre usuários cujo nome tenha exatamente 3 palavras
2. Liste transações dos últimos 7 dias
3. Classifique contas por tipo e saldo (alta, média, baixa)
4. Encontre emails duplicados (se houver)
5. Liste posts com títulos entre 20 e 50 caracteres

---

## Fase 3: Relacionamentos e JOINs
**Duração estimada: 2-3 semanas**

### 🎓 Conceitos a Aprender
- INNER JOIN
- LEFT JOIN (LEFT OUTER JOIN)
- RIGHT JOIN (RIGHT OUTER JOIN)
- FULL OUTER JOIN
- CROSS JOIN
- SELF JOIN
- Múltiplos JOINs
- Aliases de tabelas

### 📝 Exercícios Práticos

#### Exercício 3.1: INNER JOIN Básico
```sql
-- Posts com informações do autor
SELECT 
    p.title,
    p.content,
    u.full_name as autor,
    u.email
FROM posts p
INNER JOIN users u ON p.user_id = u.id;

-- Comentários com post e autor
SELECT 
    c.content as comentario,
    c.created_at,
    u.full_name as autor_comentario,
    p.title as post_titulo
FROM comments c
INNER JOIN users u ON c.user_id = u.id
INNER JOIN posts p ON c.post_id = p.id;
```

#### Exercício 3.2: LEFT JOIN
```sql
-- Todos os usuários e seus posts (mesmo sem posts)
SELECT 
    u.full_name,
    COUNT(p.id) as total_posts
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
GROUP BY u.id, u.full_name;

-- Usuários que nunca fizeram transação
SELECT u.*
FROM users u
LEFT JOIN transactions t ON u.id = t.user_id
WHERE t.id IS NULL;
```

#### Exercício 3.3: Múltiplos JOINs
```sql
-- Transações com dados do usuário e conta
SELECT 
    t.id as transacao_id,
    t.amount,
    t.transaction_type,
    u.full_name,
    ua.account_type,
    ua.card_last_digits
FROM transactions t
INNER JOIN users u ON t.user_id = u.id
INNER JOIN user_accounts ua ON u.id = ua.user_id;

-- Análise completa de fraude
SELECT 
    fd.id,
    fd.fraud_type,
    fd.fraud_score,
    u.full_name,
    u.email,
    t.amount,
    t.merchant,
    t.created_at as data_transacao
FROM fraud_data fd
INNER JOIN users u ON fd.user_id = u.id
INNER JOIN transactions t ON fd.transaction_id = t.id
WHERE fd.is_fraud = TRUE;
```

#### Exercício 3.4: SELF JOIN
```sql
-- Encontrar usuários da mesma cidade
SELECT 
    u1.full_name as usuario1,
    u2.full_name as usuario2,
    u1.city
FROM users u1
INNER JOIN users u2 ON u1.city = u2.city AND u1.id < u2.id
ORDER BY u1.city;
```

### 🎯 Desafios da Fase 3
1. Liste posts com seus comentários e autores de ambos
2. Encontre usuários que fizeram transações suspeitas
3. Liste contas ativas com suas últimas transações
4. Encontre posts sem comentários
5. Crie um relatório de atividade por usuário (posts, comentários, transações)

### 📖 Como Ler JOINs Complexos
```sql
-- Exemplo de leitura mental:
SELECT columns
FROM tabela_principal tp          -- 1. Começa aqui (tabela base)
INNER JOIN tabela_secundaria ts   -- 2. Junta com esta tabela
    ON tp.id = ts.foreign_key     -- 3. Usando esta condição
LEFT JOIN outra_tabela ot         -- 4. Depois junta com esta (mesmo sem match)
    ON ts.id = ot.foreign_key     -- 5. Com esta condição
WHERE tp.coluna = 'valor'         -- 6. Filtra o resultado final
```

---

## Fase 4: Agregação e Agrupamento
**Duração estimada: 2 semanas**

### 🎓 Conceitos a Aprender
- Funções de Agregação (COUNT, SUM, AVG, MAX, MIN)
- GROUP BY
- HAVING
- Agregações com JOINs
- Agregações condicionais

### 📝 Exercícios Práticos

#### Exercício 4.1: Funções de Agregação Básicas
```sql
-- Total de usuários
SELECT COUNT(*) as total_usuarios FROM users;

-- Total de usuários por estado
SELECT state, COUNT(*) as total 
FROM users 
GROUP BY state 
ORDER BY total DESC;

-- Soma total de transações
SELECT SUM(amount) as total_transacionado FROM transactions;

-- Valor médio das transações
SELECT AVG(amount) as valor_medio FROM transactions;

-- Maior e menor transação
SELECT 
    MAX(amount) as maior_transacao,
    MIN(amount) as menor_transacao
FROM transactions;
```

#### Exercício 4.2: GROUP BY Intermediário
```sql
-- Posts por autor
SELECT 
    u.full_name,
    COUNT(p.id) as total_posts,
    SUM(p.views) as total_visualizacoes,
    AVG(p.likes) as media_likes
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
GROUP BY u.id, u.full_name
ORDER BY total_posts DESC;

-- Transações por tipo e método de pagamento
SELECT 
    transaction_type,
    payment_method,
    COUNT(*) as quantidade,
    SUM(amount) as valor_total,
    AVG(amount) as ticket_medio
FROM transactions
GROUP BY transaction_type, payment_method
ORDER BY valor_total DESC;
```

#### Exercício 4.3: HAVING
```sql
-- Usuários com mais de 2 posts
SELECT 
    u.full_name,
    COUNT(p.id) as total_posts
FROM users u
INNER JOIN posts p ON u.id = p.user_id
GROUP BY u.id, u.full_name
HAVING COUNT(p.id) > 2;

-- Cidades com mais de 1 usuário
SELECT 
    city,
    COUNT(*) as total_usuarios
FROM users
GROUP BY city
HAVING COUNT(*) > 1;

-- Usuários com gasto médio superior a R$ 500
SELECT 
    u.full_name,
    AVG(t.amount) as ticket_medio,
    COUNT(t.id) as total_transacoes
FROM users u
INNER JOIN transactions t ON u.id = t.user_id
GROUP BY u.id, u.full_name
HAVING AVG(t.amount) > 500;
```

#### Exercício 4.4: Agregações Condicionais
```sql
-- Contar fraudes vs não fraudes
SELECT 
    COUNT(CASE WHEN is_fraud THEN 1 END) as total_fraudes,
    COUNT(CASE WHEN NOT is_fraud THEN 1 END) as total_legitimas,
    COUNT(*) as total_analises
FROM fraud_data;

-- Transações por status
SELECT 
    status,
    COUNT(*) as quantidade,
    SUM(CASE WHEN amount > 500 THEN 1 ELSE 0 END) as acima_500,
    SUM(CASE WHEN amount <= 500 THEN 1 ELSE 0 END) as ate_500
FROM transactions
GROUP BY status;
```

### 🎯 Desafios da Fase 4
1. Calcule o engajamento total por post (likes + comentários)
2. Encontre o estado com maior volume de transações
3. Liste métodos de pagamento mais usados por tipo de transação
4. Calcule a taxa de fraude por usuário
5. Identifique horários de pico de transações

---

## Fase 5: Subconsultas e CTEs
**Duração estimada: 2-3 semanas**

### 🎓 Conceitos a Aprender
- Subqueries no SELECT
- Subqueries no WHERE
- Subqueries no FROM
- CTEs (Common Table Expressions)
- CTEs Recursivos
- Múltiplos CTEs

### 📝 Exercícios Práticos

#### Exercício 5.1: Subqueries Básicas
```sql
-- Usuários que fizeram mais transações que a média
SELECT full_name, 
    (SELECT COUNT(*) 
     FROM transactions t 
     WHERE t.user_id = u.id) as total_transacoes
FROM users u
WHERE (SELECT COUNT(*) 
       FROM transactions t 
       WHERE t.user_id = u.id) > 
      (SELECT AVG(transacao_count) 
       FROM (SELECT COUNT(*) as transacao_count 
             FROM transactions 
             GROUP BY user_id) as counts);

-- Posts com mais comentários que a média
SELECT title, views,
    (SELECT COUNT(*) 
     FROM comments c 
     WHERE c.post_id = p.id) as total_comentarios
FROM posts p
WHERE (SELECT COUNT(*) 
       FROM comments c 
       WHERE c.post_id = p.id) > 
      (SELECT AVG(comment_count)
       FROM (SELECT COUNT(*) as comment_count 
             FROM comments 
             GROUP BY post_id) as avg_comments);
```

#### Exercício 5.2: CTEs (WITH)
```sql
-- Análise de engajamento de posts
WITH post_stats AS (
    SELECT 
        p.id,
        p.title,
        p.views,
        p.likes,
        COUNT(c.id) as total_comentarios
    FROM posts p
    LEFT JOIN comments c ON p.id = c.post_id
    GROUP BY p.id, p.title, p.views, p.likes
)
SELECT 
    title,
    views,
    likes,
    total_comentarios,
    (likes + total_comentarios) as engajamento_total
FROM post_stats
ORDER BY engajamento_total DESC;

-- Análise de fraude por usuário
WITH user_fraud_stats AS (
    SELECT 
        u.id,
        u.full_name,
        COUNT(fd.id) as total_analises,
        SUM(CASE WHEN fd.is_fraud THEN 1 ELSE 0 END) as total_fraudes,
        AVG(fd.fraud_score) as score_medio
    FROM users u
    LEFT JOIN fraud_data fd ON u.id = fd.user_id
    GROUP BY u.id, u.full_name
)
SELECT 
    full_name,
    total_analises,
    total_fraudes,
    ROUND(score_medio::numeric, 2) as score_medio,
    CASE 
        WHEN total_fraudes > 0 THEN 'Alto Risco'
        WHEN score_medio > 0.5 THEN 'Médio Risco'
        ELSE 'Baixo Risco'
    END as classificacao_risco
FROM user_fraud_stats
WHERE total_analises > 0
ORDER BY total_fraudes DESC, score_medio DESC;
```

#### Exercício 5.3: Múltiplos CTEs
```sql
-- Análise completa de usuários
WITH user_posts AS (
    SELECT user_id, COUNT(*) as total_posts
    FROM posts
    GROUP BY user_id
),
user_comments AS (
    SELECT user_id, COUNT(*) as total_comments
    FROM comments
    GROUP BY user_id
),
user_transactions AS (
    SELECT 
        user_id, 
        COUNT(*) as total_transacoes,
        SUM(amount) as valor_total
    FROM transactions
    GROUP BY user_id
)
SELECT 
    u.full_name,
    u.email,
    u.city,
    u.state,
    COALESCE(up.total_posts, 0) as posts,
    COALESCE(uc.total_comments, 0) as comentarios,
    COALESCE(ut.total_transacoes, 0) as transacoes,
    COALESCE(ut.valor_total, 0) as volume_transacionado
FROM users u
LEFT JOIN user_posts up ON u.id = up.user_id
LEFT JOIN user_comments uc ON u.id = uc.user_id
LEFT JOIN user_transactions ut ON u.id = ut.user_id
ORDER BY volume_transacionado DESC;
```

### 🎯 Desafios da Fase 5
1. Encontre posts com engajamento acima da média do estado do autor
2. Calcule o percentil de cada usuário em volume de transações
3. Identifique transações anômalas (muito acima do padrão do usuário)
4. Crie ranking de usuários mais ativos
5. Analise padrões de fraude por região

---

## Fase 6: Window Functions
**Duração estimada: 3 semanas**

### 🎓 Conceitos a Aprender
- ROW_NUMBER()
- RANK() e DENSE_RANK()
- NTILE()
- LAG() e LEAD()
- FIRST_VALUE() e LAST_VALUE()
- PARTITION BY
- ORDER BY em Window Functions
- Frame Clauses (ROWS, RANGE)

### 📝 Exercícios Práticos

#### Exercício 6.1: ROW_NUMBER e RANK
```sql
-- Ranking de posts por visualizações
SELECT 
    title,
    views,
    ROW_NUMBER() OVER (ORDER BY views DESC) as posicao,
    RANK() OVER (ORDER BY views DESC) as ranking,
    DENSE_RANK() OVER (ORDER BY views DESC) as ranking_denso
FROM posts;

-- Ranking de usuários por volume de transações
SELECT 
    u.full_name,
    SUM(t.amount) as volume_total,
    ROW_NUMBER() OVER (ORDER BY SUM(t.amount) DESC) as posicao
FROM users u
INNER JOIN transactions t ON u.id = t.user_id
GROUP BY u.id, u.full_name;
```

#### Exercício 6.2: PARTITION BY
```sql
-- Ranking de posts por autor
SELECT 
    u.full_name as autor,
    p.title,
    p.views,
    ROW_NUMBER() OVER (PARTITION BY u.id ORDER BY p.views DESC) as ranking_por_autor
FROM posts p
INNER JOIN users u ON p.user_id = u.id;

-- Transações ordenadas por usuário
SELECT 
    u.full_name,
    t.amount,
    t.created_at,
    ROW_NUMBER() OVER (PARTITION BY u.id ORDER BY t.created_at DESC) as ordem_transacao
FROM transactions t
INNER JOIN users u ON t.user_id = u.id;
```

#### Exercício 6.3: LAG e LEAD
```sql
-- Comparar transação atual com anterior
SELECT 
    user_id,
    amount,
    created_at,
    LAG(amount) OVER (PARTITION BY user_id ORDER BY created_at) as transacao_anterior,
    amount - LAG(amount) OVER (PARTITION BY user_id ORDER BY created_at) as diferenca
FROM transactions;

-- Próxima transação do usuário
SELECT 
    user_id,
    amount,
    created_at,
    LEAD(created_at) OVER (PARTITION BY user_id ORDER BY created_at) as proxima_transacao,
    LEAD(created_at) OVER (PARTITION BY user_id ORDER BY created_at) - created_at as tempo_ate_proxima
FROM transactions;
```

#### Exercício 6.4: Agregações com Window Functions
```sql
-- Running total de transações por usuário
SELECT 
    u.full_name,
    t.created_at,
    t.amount,
    SUM(t.amount) OVER (PARTITION BY u.id ORDER BY t.created_at) as total_acumulado
FROM transactions t
INNER JOIN users u ON t.user_id = u.id
ORDER BY u.id, t.created_at;

-- Média móvel de 3 transações
SELECT 
    user_id,
    amount,
    created_at,
    AVG(amount) OVER (
        PARTITION BY user_id 
        ORDER BY created_at 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) as media_movel_3
FROM transactions;
```

#### Exercício 6.5: NTILE (Quartis e Percentis)
```sql
-- Dividir usuários em quartis por volume de transações
WITH user_volumes AS (
    SELECT 
        u.id,
        u.full_name,
        SUM(t.amount) as volume_total
    FROM users u
    INNER JOIN transactions t ON u.id = t.user_id
    GROUP BY u.id, u.full_name
)
SELECT 
    full_name,
    volume_total,
    NTILE(4) OVER (ORDER BY volume_total) as quartil
FROM user_volumes;
```

### 🎯 Desafios da Fase 6
1. Identifique a primeira e última transação de cada usuário
2. Calcule a taxa de crescimento de transações mês a mês
3. Encontre gaps suspeitos entre transações
4. Crie um ranking de posts considerando engajamento total
5. Analise padrões de fraude usando valores anteriores

---

## Fase 7: Performance e Otimização
**Duração estimada: 3-4 semanas**

### 🎓 Conceitos a Aprender
- EXPLAIN e EXPLAIN ANALYZE
- Tipos de Scan (Sequential, Index, Bitmap)
- Query Planning
- Cost-based optimization
- Cardinality estimation
- Statistics e ANALYZE
- VACUUM
- Reescrita de queries

### 📝 Exercícios Práticos

#### Exercício 7.1: EXPLAIN ANALYZE
```sql
-- Análise básica de query
EXPLAIN ANALYZE
SELECT * FROM users WHERE email = 'joao.silva@email.com';

-- Comparar performance com e sem índice
-- Sem índice
EXPLAIN ANALYZE
SELECT * FROM transactions WHERE amount > 1000;

-- Após criar índice
CREATE INDEX idx_transactions_amount ON transactions(amount);
EXPLAIN ANALYZE
SELECT * FROM transactions WHERE amount > 1000;
```

#### Exercício 7.2: Otimização de JOINs
```sql
-- Query não otimizada
EXPLAIN ANALYZE
SELECT u.full_name, COUNT(*)
FROM users u, transactions t
WHERE u.id = t.user_id
GROUP BY u.full_name;

-- Query otimizada
EXPLAIN ANALYZE
SELECT u.full_name, COUNT(*)
FROM users u
INNER JOIN transactions t ON u.id = t.user_id
GROUP BY u.id, u.full_name;
```

#### Exercício 7.3: Entendendo o Query Plan
```sql
-- Exemplo de leitura de EXPLAIN
EXPLAIN (FORMAT JSON, ANALYZE, BUFFERS)
SELECT 
    u.full_name,
    COUNT(t.id) as total_transacoes,
    SUM(t.amount) as volume_total
FROM users u
LEFT JOIN transactions t ON u.id = t.user_id
WHERE u.state = 'SP'
GROUP BY u.id, u.full_name
HAVING COUNT(t.id) > 5;

/*
Leitura do plano:
1. Scan Type: Sequential vs Index
2. Cost: custo estimado (startup..total)
3. Rows: linhas estimadas vs reais
4. Width: tamanho médio da linha
5. Time: tempo real de execução
*/
```

#### Exercício 7.4: Reescrita de Queries
```sql
-- ❌ Query ruim (subconsulta correlacionada)
SELECT u.full_name,
    (SELECT COUNT(*) FROM transactions t WHERE t.user_id = u.id) as total
FROM users u;

-- ✅ Query otimizada (JOIN)
SELECT u.full_name, COUNT(t.id) as total
FROM users u
LEFT JOIN transactions t ON u.id = t.user_id
GROUP BY u.id, u.full_name;

-- ❌ Query ruim (múltiplas subconsultas)
SELECT 
    full_name,
    (SELECT COUNT(*) FROM posts WHERE user_id = u.id),
    (SELECT COUNT(*) FROM comments WHERE user_id = u.id),
    (SELECT COUNT(*) FROM transactions WHERE user_id = u.id)
FROM users u;

-- ✅ Query otimizada (CTEs ou JOINs)
WITH user_stats AS (
    SELECT u.id, u.full_name,
        COUNT(DISTINCT p.id) as posts,
        COUNT(DISTINCT c.id) as comments,
        COUNT(DISTINCT t.id) as transactions
    FROM users u
    LEFT JOIN posts p ON u.id = p.user_id
    LEFT JOIN comments c ON u.id = c.user_id
    LEFT JOIN transactions t ON u.id = t.user_id
    GROUP BY u.id, u.full_name
)
SELECT * FROM user_stats;
```

### 📖 Guia de Leitura de EXPLAIN

```
QUERY PLAN
----------
Nested Loop  (cost=0.00..100.00 rows=10 width=32) (actual time=0.050..0.150 rows=8 loops=1)
  -> Seq Scan on users u  (cost=0.00..50.00 rows=5 width=16)
  -> Index Scan using idx_posts_user_id on posts p  (cost=0.00..10.00 rows=2 width=16)

Leitura:
- Nested Loop: tipo de JOIN usado
- cost=0.00..100.00: custo inicial..custo total
- rows=10: linhas esperadas
- width=32: bytes por linha
- actual time: tempo real
- rows=8: linhas reais (diferente da estimativa!)
- loops=1: quantas vezes executou
```

### 🎯 Desafios da Fase 7
1. Otimize query de análise de fraudes (deve usar índices)
2. Compare performance de CTE vs Subquery
3. Identifique queries lentas e otimize
4. Analise impacto de diferentes tipos de JOIN
5. Crie índices compostos eficientes

---

## Fase 8: Índices Avançados
**Duração estimada: 2-3 semanas**

### 🎓 Conceitos a Aprender
- B-Tree Index (padrão)
- Hash Index
- GiST Index
- GIN Index
- BRIN Index
- Partial Index
- Expression Index
- Covering Index
- Index Maintenance

### 📝 Exercícios Práticos

#### Exercício 8.1: Índices B-Tree
```sql
-- Índice simples
CREATE INDEX idx_users_email ON users(email);

-- Índice composto (ordem importa!)
CREATE INDEX idx_transactions_user_date ON transactions(user_id, created_at);

-- Uso correto: user_id E created_at
EXPLAIN ANALYZE
SELECT * FROM transactions 
WHERE user_id = 1 AND created_at > '2024-01-01';

-- Uso parcial: apenas user_id (funciona)
EXPLAIN ANALYZE
SELECT * FROM transactions WHERE user_id = 1;

-- NÃO USA índice: apenas created_at
EXPLAIN ANALYZE
SELECT * FROM transactions WHERE created_at > '2024-01-01';
```

#### Exercício 8.2: Partial Index
```sql
-- Índice apenas para fraudes confirmadas
CREATE INDEX idx_fraud_confirmed ON fraud_data(user_id) 
WHERE is_fraud = TRUE;

-- Índice para transações ativas
CREATE INDEX idx_active_transactions ON transactions(user_id, created_at)
WHERE status = 'completed';

-- Query que usa o índice parcial
EXPLAIN ANALYZE
SELECT * FROM fraud_data 
WHERE is_fraud = TRUE AND user_id = 1;
```

#### Exercício 8.3: Expression Index
```sql
-- Índice em expressão (LOWER)
CREATE INDEX idx_users_email_lower ON users(LOWER(email));

-- Agora esta query usa o índice
EXPLAIN ANALYZE
SELECT * FROM users WHERE LOWER(email) = 'joao.silva@email.com';

-- Índice em cálculo
CREATE INDEX idx_transactions_rounded_amount ON transactions(ROUND(amount));
```

#### Exercício 8.4: Covering Index
```sql
-- Covering index: inclui colunas extras
CREATE INDEX idx_posts_user_covering ON posts(user_id) 
INCLUDE (title, views, created_at);

-- Index-Only Scan (muito rápido!)
EXPLAIN ANALYZE
SELECT title, views, created_at 
FROM posts 
WHERE user_id = 1;
```

#### Exercício 8.5: Análise de Índices
```sql
-- Listar índices de uma tabela
SELECT 
    indexname,
    indexdef
FROM pg_indexes
WHERE tablename = 'transactions';

-- Tamanho dos índices
SELECT 
    indexrelname as index_name,
    pg_size_pretty(pg_relation_size(indexrelid)) as index_size
FROM pg_stat_user_indexes
WHERE schemaname = 'public'
ORDER BY pg_relation_size(indexrelid) DESC;

-- Índices não utilizados
SELECT 
    schemaname,
    tablename,
    indexname,
    idx_scan,
    idx_tup_read,
    idx_tup_fetch
FROM pg_stat_user_indexes
WHERE idx_scan = 0
AND schemaname = 'public';
```

### 🎯 Desafios da Fase 8
1. Crie índices otimizados para queries de fraude
2. Identifique e remova índices desnecessários
3. Otimize buscas por CPF e email
4. Crie índices para análises temporais
5. Implemente covering indexes estratégicos

---

## Fase 9: Transactions e Locks
**Duração estimada: 2 semanas**

### 🎓 Conceitos a Aprender
- ACID Properties
- BEGIN, COMMIT, ROLLBACK
- SAVEPOINT
- Isolation Levels
- Deadlocks
- Lock Types (Row, Table)
- MVCC (Multi-Version Concurrency Control)
- FOR UPDATE, FOR SHARE

### 📝 Exercícios Práticos

#### Exercício 9.1: Transações Básicas
```sql
-- Transação simples
BEGIN;
    INSERT INTO users (username, email, full_name) 
    VALUES ('teste', 'teste@email.com', 'Teste Usuario');
    
    -- Verificar antes de confirmar
    SELECT * FROM users WHERE username = 'teste';
    
COMMIT; -- ou ROLLBACK;

-- Transação com múltiplas operações
BEGIN;
    -- Transferência entre contas
    UPDATE user_accounts 
    SET balance = balance - 500 
    WHERE id = 1;
    
    UPDATE user_accounts 
    SET balance = balance + 500 
    WHERE id = 2;
    
    INSERT INTO transactions (user_id, amount, transaction_type)
    VALUES (1, 500, 'transfer');
    
COMMIT;
```

#### Exercício 9.2: SAVEPOINT
```sql
BEGIN;
    INSERT INTO posts (user_id, title, content)
    VALUES (1, 'Post 1', 'Conteudo 1');
    
    SAVEPOINT primeiro_post;
    
    INSERT INTO posts (user_id, title, content)
    VALUES (1, 'Post 2', 'Conteudo 2');
    
    SAVEPOINT segundo_post;
    
    -- Ops, erro no terceiro
    INSERT INTO posts (user_id, title, content)
    VALUES (999, 'Post 3', 'Conteudo 3'); -- user_id inválido
    
    -- Voltar para savepoint
    ROLLBACK TO segundo_post;
    
COMMIT;
```

#### Exercício 9.3: Isolation Levels
```sql
-- Verificar nível atual
SHOW transaction_isolation;

-- Definir nível de isolamento
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SELECT * FROM transactions WHERE user_id = 1;
COMMIT;

-- Serializable (mais restritivo)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    -- Operações críticas
COMMIT;
```

#### Exercício 9.4: Locks Explícitos
```sql
-- Lock de linha para atualização
BEGIN;
    SELECT * FROM user_accounts 
    WHERE id = 1 
    FOR UPDATE;
    
    -- Apenas esta sessão pode atualizar
    UPDATE user_accounts 
    SET balance = balance - 100 
    WHERE id = 1;
    
COMMIT;

-- Lock compartilhado
BEGIN;
    SELECT * FROM users 
    WHERE id = 1 
    FOR SHARE;
    
    -- Outras sessões podem ler mas não atualizar
COMMIT;
```

### 🎯 Desafios da Fase 9
1. Implemente transferência segura entre contas
2. Evite condição de corrida em saldo de conta
3. Crie sistema de reserva de produtos com locks
4. Simule e resolva deadlock
5. Implemente auditoria com transações

---

## Fase 10: Stored Procedures e Triggers
**Duração estimada: 2-3 semanas**

### 🎓 Conceitos a Aprender
- PL/pgSQL Basics
- Functions vs Procedures
- Triggers (BEFORE, AFTER)
- Trigger Functions
- Variables e Control Flow
- Error Handling
- Dynamic SQL

### 📝 Exercícios Práticos

#### Exercício 10.1: Functions Básicas
```sql
-- Função simples
CREATE OR REPLACE FUNCTION total_usuarios()
RETURNS INTEGER AS $$
BEGIN
    RETURN (SELECT COUNT(*) FROM users);
END;
$$ LANGUAGE plpgsql;

-- Usar a função
SELECT total_usuarios();

-- Função com parâmetros
CREATE OR REPLACE FUNCTION total_transacoes_usuario(p_user_id INTEGER)
RETURNS INTEGER AS $$
BEGIN
    RETURN (SELECT COUNT(*) FROM transactions WHERE user_id = p_user_id);
END;
$$ LANGUAGE plpgsql;

SELECT total_transacoes_usuario(1);
```

#### Exercício 10.2: Triggers
```sql
-- Trigger para atualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_users_updated_at
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Testar
UPDATE users SET email = 'novo@email.com' WHERE id = 1;
SELECT updated_at FROM users WHERE id = 1;
```

#### Exercício 10.3: Auditoria com Triggers
```sql
-- Tabela de auditoria
CREATE TABLE audit_log (
    id SERIAL PRIMARY KEY,
    table_name VARCHAR(50),
    operation VARCHAR(10),
    old_data JSONB,
    new_data JSONB,
    user_id INTEGER,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Trigger de auditoria
CREATE OR REPLACE FUNCTION audit_trigger_func()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO audit_log (table_name, operation, new_data)
        VALUES (TG_TABLE_NAME, 'INSERT', row_to_json(NEW));
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO audit_log (table_name, operation, old_data, new_data)
        VALUES (TG_TABLE_NAME, 'UPDATE', row_to_json(OLD), row_to_json(NEW));
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO audit_log (table_name, operation, old_data)
        VALUES (TG_TABLE_NAME, 'DELETE', row_to_json(OLD));
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_users_audit
AFTER INSERT OR UPDATE OR DELETE ON users
FOR EACH ROW
EXECUTE FUNCTION audit_trigger_func();
```

#### Exercício 10.4: Validação com Triggers
```sql
-- Trigger de validação de fraude
CREATE OR REPLACE FUNCTION validate_transaction()
RETURNS TRIGGER AS $$
BEGIN
    -- Validar valor mínimo
    IF NEW.amount <= 0 THEN
        RAISE EXCEPTION 'Valor deve ser maior que zero';
    END IF;
    
    -- Verificar se usuário existe e está ativo
    IF NOT EXISTS (SELECT 1 FROM users WHERE id = NEW.user_id) THEN
        RAISE EXCEPTION 'Usuário não encontrado';
    END IF;
    
    -- Detectar transação suspeita
    IF NEW.amount > 10000 THEN
        INSERT INTO fraud_data (transaction_id, user_id, fraud_type, fraud_score, reason)
        VALUES (NEW.id, NEW.user_id, 'high_value_transaction', 0.8, 
                'Transação acima de R$ 10.000');
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validate_transaction
BEFORE INSERT ON transactions
FOR EACH ROW
EXECUTE FUNCTION validate_transaction();
```

### 🎯 Desafios da Fase 10
1. Crie função para calcular score de fraude
2. Implemente trigger para atualizar saldo de conta
3. Crie stored procedure para processar lote de transações
4. Implemente validação complexa de CPF
5. Crie sistema de notificação com triggers

---

## Fase 11: Análise de Fraudes
**Duração estimada: 3-4 semanas**

### 🎓 Conceitos a Aprender
- Análise Estatística com SQL
- Pattern Detection
- Anomaly Detection
- Time Series Analysis
- Risk Scoring
- Machine Learning básico com SQL

### 📝 Exercícios Práticos

#### Exercício 11.1: Detecção de Padrões Suspeitos
```sql
-- Transações acima de 3 desvios padrão
WITH transaction_stats AS (
    SELECT 
        user_id,
        AVG(amount) as media,
        STDDEV(amount) as desvio_padrao
    FROM transactions
    GROUP BY user_id
)
SELECT 
    t.*,
    ts.media,
    ts.desvio_padrao,
    (t.amount - ts.media) / NULLIF(ts.desvio_padrao, 0) as z_score
FROM transactions t
INNER JOIN transaction_stats ts ON t.user_id = ts.user_id
WHERE ABS((t.amount - ts.media) / NULLIF(ts.desvio_padrao, 0)) > 3;

-- Múltiplas transações em curto período
WITH transaction_timing AS (
    SELECT 
        user_id,
        created_at,
        LAG(created_at) OVER (PARTITION BY user_id ORDER BY created_at) as prev_transaction,
        amount
    FROM transactions
)
SELECT 
    user_id,
    created_at,
    prev_transaction,
    EXTRACT(EPOCH FROM (created_at - prev_transaction))/60 as minutos_desde_anterior,
    amount
FROM transaction_timing
WHERE EXTRACT(EPOCH FROM (created_at - prev_transaction))/60 < 5
ORDER BY user_id, created_at;
```

#### Exercício 11.2: Score de Risco
```sql
-- Função de cálculo de risk score
CREATE OR REPLACE FUNCTION calculate_fraud_score(p_transaction_id INTEGER)
RETURNS DECIMAL(3,2) AS $$
DECLARE
    v_score DECIMAL(3,2) := 0;
    v_amount DECIMAL(10,2);
    v_user_id INTEGER;
    v_avg_amount DECIMAL(10,2);
    v_transaction_count INTEGER;
    v_time_diff INTEGER;
BEGIN
    -- Buscar dados da transação
    SELECT amount, user_id INTO v_amount, v_user_id
    FROM transactions WHERE id = p_transaction_id;
    
    -- Calcular média do usuário
    SELECT AVG(amount), COUNT(*) INTO v_avg_amount, v_transaction_count
    FROM transactions WHERE user_id = v_user_id;
    
    -- Score baseado em valor anormal
    IF v_amount > v_avg_amount * 3 THEN
        v_score := v_score + 0.3;
    END IF;
    
    -- Score baseado em novo usuário
    IF v_transaction_count < 5 THEN
        v_score := v_score + 0.2;
    END IF;
    
    -- Score baseado em horário suspeito (madrugada)
    IF EXTRACT(HOUR FROM (SELECT created_at FROM transactions WHERE id = p_transaction_id)) 
       BETWEEN 0 AND 5 THEN
        v_score := v_score + 0.15;
    END IF;
    
    -- Normalizar entre 0 e 1
    v_score := LEAST(v_score, 1.0);
    
    RETURN v_score;
END;
$$ LANGUAGE plpgsql;
```

#### Exercício 11.3: Análise Temporal
```sql
-- Análise de fraudes por hora do dia
SELECT 
    EXTRACT(HOUR FROM t.created_at) as hora,
    COUNT(*) as total_transacoes,
    SUM(CASE WHEN fd.is_fraud THEN 1 ELSE 0 END) as total_fraudes,
    ROUND(100.0 * SUM(CASE WHEN fd.is_fraud THEN 1 ELSE 0 END) / COUNT(*), 2) as taxa_fraude
FROM transactions t
LEFT JOIN fraud_data fd ON t.id = fd.transaction_id
GROUP BY EXTRACT(HOUR FROM t.created_at)
ORDER BY hora;

-- Tendência de fraudes ao longo do tempo
WITH daily_fraud AS (
    SELECT 
        DATE(t.created_at) as data,
        COUNT(*) as transacoes,
        SUM(CASE WHEN fd.is_fraud THEN 1 ELSE 0 END) as fraudes
    FROM transactions t
    LEFT JOIN fraud_data fd ON t.id = fd.transaction_id
    GROUP BY DATE(t.created_at)
)
SELECT 
    data,
    transacoes,
    fraudes,
    ROUND(100.0 * fraudes / transacoes, 2) as taxa_fraude,
    AVG(fraudes) OVER (ORDER BY data ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) as media_movel_7dias
FROM daily_fraud
ORDER BY data;
```

#### Exercício 11.4: Análise Geográfica
```sql
-- Transações em locais diferentes em curto período
WITH location_changes AS (
    SELECT 
        user_id,
        created_at,
        location_city,
        location_state,
        LAG(location_city) OVER (PARTITION BY user_id ORDER BY created_at) as prev_city,
        LAG(created_at) OVER (PARTITION BY user_id ORDER BY created_at) as prev_time
    FROM transactions
)
SELECT 
    user_id,
    created_at,
    location_city,
    prev_city,
    EXTRACT(EPOCH FROM (created_at - prev_time))/3600 as horas_diferenca
FROM location_changes
WHERE location_city != prev_city
AND EXTRACT(EPOCH FROM (created_at - prev_time))/3600 < 2
ORDER BY horas_diferenca;
```

### 🎯 Desafios da Fase 11
1. Implemente detecção de múltiplas tentativas de compra falhadas
2. Crie análise de comportamento de compra por perfil
3. Identifique cartões usados em múltiplos dispositivos
4. Analise correlação entre tipo de fraude e hora do dia
5. Crie dashboard SQL com métricas de fraude

---

## Fase 12: Big Data e Particionamento
**Duração estimada: 4+ semanas**

### 🎓 Conceitos a Aprender
- Table Partitioning (Range, List, Hash)
- Partition Pruning
- Parallel Query Execution
- Table Inheritance
- Foreign Data Wrappers
- Materialized Views
- Query Parallelization
- Sharding Strategies

### 📝 Exercícios Práticos

#### Exercício 12.1: Particionamento por Range
```sql
-- Criar tabela particionada por data
CREATE TABLE transactions_partitioned (
    id SERIAL,
    user_id INTEGER,
    amount DECIMAL(10,2),
    created_at TIMESTAMP,
    -- outras colunas...
) PARTITION BY RANGE (created_at);

-- Criar partições mensais
CREATE TABLE transactions_2024_01 PARTITION OF transactions_partitioned
FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');

CREATE TABLE transactions_2024_02 PARTITION OF transactions_partitioned
FOR VALUES FROM ('2024-02-01') TO ('2024-03-01');

CREATE TABLE transactions_2024_03 PARTITION OF transactions_partitioned
FOR VALUES FROM ('2024-03-01') TO ('2024-04-01');

-- Índices em cada partição
CREATE INDEX idx_trans_2024_01_user ON transactions_2024_01(user_id);
CREATE INDEX idx_trans_2024_02_user ON transactions_2024_02(user_id);

-- Query com partition pruning
EXPLAIN ANALYZE
SELECT * FROM transactions_partitioned
WHERE created_at BETWEEN '2024-01-15' AND '2024-01-20';
```

#### Exercício 12.2: Materialized Views
```sql
-- View materializada para análise de fraudes
CREATE MATERIALIZED VIEW mv_fraud_analysis AS
SELECT 
    DATE_TRUNC('day', t.created_at) as data,
    t.location_state,
    COUNT(*) as total_transacoes,
    SUM(t.amount) as volume_total,
    COUNT(fd.id) FILTER (WHERE fd.is_fraud) as total_fraudes,
    AVG(fd.fraud_score) as score_medio
FROM transactions t
LEFT JOIN fraud_data fd ON t.id = fd.transaction_id
GROUP BY DATE_TRUNC('day', t.created_at), t.location_state;

-- Criar índice na view
CREATE INDEX idx_mv_fraud_data_estado ON mv_fraud_analysis(location_state, data);

-- Refresh da view (executar periodicamente)
REFRESH MATERIALIZED VIEW mv_fraud_analysis;

-- Refresh concorrente (não bloqueia leituras)
REFRESH MATERIALIZED VIEW CONCURRENTLY mv_fraud_analysis;
```

#### Exercício 12.3: Parallel Queries
```sql
-- Verificar configuração de paralelismo
SHOW max_parallel_workers_per_gather;

-- Forçar query paralela
SET max_parallel_workers_per_gather = 4;

EXPLAIN ANALYZE
SELECT 
    location_state,
    COUNT(*) as total,
    AVG(amount) as media
FROM transactions
GROUP BY location_state;

-- Parallel aggregate
EXPLAIN ANALYZE
SELECT COUNT(*) FROM transactions;
```

#### Exercício 12.4: Estratégias de Sharding
```sql
-- Sharding por hash de user_id
CREATE TABLE transactions_shard_0 (LIKE transactions INCLUDING ALL);
CREATE TABLE transactions_shard_1 (LIKE transactions INCLUDING ALL);
CREATE TABLE transactions_shard_2 (LIKE transactions INCLUDING ALL);
CREATE TABLE transactions_shard_3 (LIKE transactions INCLUDING ALL);

-- Função para determinar shard
CREATE OR REPLACE FUNCTION get_shard(p_user_id INTEGER)
RETURNS INTEGER AS $$
BEGIN
    RETURN p_user_id % 4;
END;
$$ LANGUAGE plpgsql;

-- Inserir em shard correto
INSERT INTO transactions_shard_0 
SELECT * FROM transactions WHERE get_shard(user_id) = 0;
```

### 🎯 Desafios da Fase 12
1. Implemente particionamento automático por mês
2. Crie views materializadas para dashboards
3. Otimize queries para processar milhões de registros
4. Implemente estratégia de arquivamento de dados antigos
5. Crie sistema de cache com materialized views

---

## 📊 Projeto Final Integrado

### Cenário: Sistema de Detecção de Fraudes em Tempo Real

**Objetivo**: Criar um sistema completo de análise e detecção de fraudes usando todas as técnicas aprendidas.

### Requisitos:

1. **Modelagem de Dados**
   - Tabelas otimizadas e normalizadas
   - Relacionamentos bem definidos
   - Constraints e validações

2. **Performance**
   - Índices estratégicos
   - Particionamento de tabelas grandes
   - Materialized views para dashboards

3. **Análise em Tempo Real**
   - Triggers para detecção automática
   - Funções de cálculo de risk score
   - Alertas automáticos

4. **Relatórios e Dashboards**
   - Views complexas com estatísticas
   - Análises temporais
   - Ranking de riscos

5. **Otimização**
   - Todas as queries com EXPLAIN ANALYZE
   - Performance target: < 100ms para 90% das queries
   - Suporte a 1TB de dados

---

## 🎓 Recursos Adicionais

### Documentação Oficial
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [PostgreSQL Wiki](https://wiki.postgresql.org/)
- [PostgreSQL Tutorial](https://www.postgresqltutorial.com/)

### Livros Recomendados
- "PostgreSQL: Up and Running" - Regina Obe & Leo Hsu
- "The Art of PostgreSQL" - Dimitri Fontaine
- "PostgreSQL Query Optimization" - Henrietta Dombrovskaya

### Ferramentas
- pgAdmin
- DBeaver
- Beekeeper Studio
- pg_stat_statements
- pgBadger (análise de logs)

### Prática Online
- [PgExercises](https://pgexercises.com/)
- [SQLBolt](https://sqlbolt.com/)
- [HackerRank SQL](https://www.hackerrank.com/domains/sql)

---

## ✅ Checklist de Progresso

### Fase 1-3: Fundamentos
- [ ] SELECT, WHERE, ORDER BY dominados
- [ ] JOINs sem consultar documentação
- [ ] Entende diferença entre LEFT/RIGHT/INNER JOIN

### Fase 4-6: Intermediário
- [ ] GROUP BY e agregações sem erro
- [ ] Subconsultas e CTEs fluentemente
- [ ] Window Functions básicas

### Fase 7-9: Avançado
- [ ] Lê EXPLAIN ANALYZE com facilidade
- [ ] Cria índices apropriados
- [ ] Entende isolation levels

### Fase 10-12: Expert
- [ ] Escreve stored procedures complexos
- [ ] Implementa particionamento
- [ ] Otimiza para Big Data

---

## 🎯 Meta Final

**Você será considerado fluente em PostgreSQL quando:**
1. Conseguir resolver 90% dos problemas sem documentação
2. Escrever queries otimizadas na primeira tentativa
3. Ler e entender queries complexas em minutos
4. Identificar gargalos de performance rapidamente
5. Modelar sistemas completos com confiança

**Tempo estimado total: 6-12 meses de prática diária**

Boa jornada! 🚀
