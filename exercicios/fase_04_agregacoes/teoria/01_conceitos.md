# 🎓 Conceitos de Agregações - Fase 4

## GROUP BY - Agrupar Dados

### O Que É?

`GROUP BY` **agrupa linhas com valores iguais** em uma coluna, permitindo fazer cálculos sobre cada grupo.

```sql
-- Contar posts por usuário
SELECT user_id, COUNT(*) as total_posts
FROM posts
GROUP BY user_id;

-- Resultado:
-- user_id | total_posts
-- --------|------------
--   1     |     1
--   2     |     1
--   3     |     1
-- etc...
```

### Sintaxe

```sql
SELECT coluna_grupo, FUNCAO_AGREGADA(coluna)
FROM tabela
GROUP BY coluna_grupo;
```

---

## Funções Agregadas

### COUNT() - Contar Registros

```sql
SELECT 
    state,
    COUNT(*) as total_usuarios      -- Conta todas as linhas
FROM users
GROUP BY state;

-- Resultado: Estados com número de usuários
```

### SUM() - Somar Valores

```sql
SELECT 
    user_id,
    SUM(amount) as total_gasto
FROM transactions
GROUP BY user_id;
```

### AVG() - Média Aritmética

```sql
SELECT 
    user_id,
    AVG(amount) as ticket_medio
FROM transactions
GROUP BY user_id;
```

### MIN() e MAX() - Mínimo e Máximo

```sql
SELECT 
    user_id,
    MIN(amount) as menor_transacao,
    MAX(amount) as maior_transacao
FROM transactions
GROUP BY user_id;
```

---

## Combinando Múltiplas Agregações

```sql
SELECT 
    user_id,
    COUNT(*) as total_transacoes,
    SUM(amount) as valor_total,
    AVG(amount) as valor_medio,
    MIN(amount) as valor_minimo,
    MAX(amount) as valor_maximo
FROM transactions
GROUP BY user_id
ORDER BY valor_total DESC;
```

---

## HAVING - Filtrar Grupos

### Diferença entre WHERE e HAVING

| WHERE | HAVING |
|-------|--------|
| Filtra LINHAS | Filtra GRUPOS |
| Antes de GROUP BY | Depois de GROUP BY |
| Usa colunas originais | Usa funções agregadas |

### Sintaxe

```sql
SELECT coluna, FUNCAO_AGREGADA(coluna)
FROM tabela
GROUP BY coluna
HAVING FUNCAO_AGREGADA(coluna) > valor;
```

### Exemplo

```sql
-- ❌ ERRADO: Usar WHERE com agregação
SELECT user_id, SUM(amount) as total
FROM transactions
WHERE SUM(amount) > 1000   -- ✗ Não funciona!
GROUP BY user_id;

-- ✅ CORRETO: Usar HAVING
SELECT user_id, SUM(amount) as total
FROM transactions
GROUP BY user_id
HAVING SUM(amount) > 1000;  -- ✓ Funciona!
```

### Exemplo Prático: Usuários de Alto Gasto

```sql
SELECT 
    u.full_name,
    SUM(t.amount) as total_gasto
FROM users u
LEFT JOIN transactions t ON u.id = t.user_id
GROUP BY u.id, u.full_name
HAVING SUM(t.amount) > 2000
ORDER BY total_gasto DESC;

-- Retorna: Apenas usuários que gastaram > R$ 2000
```

---

## GROUP BY Múltiplas Colunas

Agrupar por 2+ colunas:

```sql
-- Transações por estado e tipo
SELECT 
    u.state,
    t.transaction_type,
    COUNT(*) as total,
    SUM(t.amount) as valor_total
FROM users u
LEFT JOIN transactions t ON u.id = t.user_id
GROUP BY u.state, t.transaction_type
ORDER BY u.state, valor_total DESC;

-- Resultado:
-- state | transaction_type | total | valor_total
-- ------|------------------|-------|-------------
-- BA    | purchase         |  1    | 110.00
-- BA    | transfer         |  NULL | NULL
-- CE    | purchase         |  NULL | NULL
-- ...
```

---

## COUNT(DISTINCT col) - Valores Únicos

```sql
-- Contar usuários DIFERENTES (não registros)
SELECT 
    COUNT(DISTINCT user_id) as usuarios_unicos
FROM transactions;

-- vs

-- Contar TODOS os registros
SELECT 
    COUNT(*) as total_transacoes
FROM transactions;
```

---

## Cuidado com NULLs

NULLs são **ignorados** por funções agregadas:

```sql
-- Se uma coluna tiver NULL, SUM ignora essa linha
SELECT 
    user_id,
    SUM(amount) as total,           -- Ignora NULLs
    COUNT(amount) as contagem,      -- Ignora NULLs
    COUNT(*) as contagem_tudo       -- Conta NULLs também
FROM transactions
GROUP BY user_id;
```

Substitua NULLs antes de agregar:

```sql
SELECT 
    user_id,
    SUM(COALESCE(amount, 0)) as total
FROM transactions
GROUP BY user_id;
```

---

## Exemplos Práticos Completos

### Dashboard de Plataforma

```sql
SELECT 
    COUNT(DISTINCT u.id) as total_usuarios,
    COUNT(DISTINCT p.id) as total_posts,
    ROUND(AVG(p.views)::numeric, 2) as media_views,
    ROUND(AVG(p.likes)::numeric, 2) as media_likes
FROM users u
LEFT JOIN posts p ON u.id = p.user_id;
```

### Top Usuários por Engajamento

```sql
SELECT 
    u.full_name,
    COUNT(DISTINCT p.id) as posts,
    COUNT(DISTINCT c.id) as comentarios,
    COUNT(DISTINCT t.id) as transacoes,
    (COUNT(DISTINCT p.id) + COUNT(DISTINCT c.id) + COUNT(DISTINCT t.id)) as score
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
LEFT JOIN comments c ON u.id = c.user_id
LEFT JOIN transactions t ON u.id = t.user_id
GROUP BY u.id, u.full_name
ORDER BY score DESC
LIMIT 5;
```

### Análise Regional

```sql
SELECT 
    u.state,
    COUNT(DISTINCT u.id) as usuarios,
    SUM(t.amount) as valor_total,
    ROUND(AVG(t.amount)::numeric, 2) as ticket_medio,
    COUNT(DISTINCT t.id) as transacoes
FROM users u
LEFT JOIN transactions t ON u.id = t.user_id
GROUP BY u.state
ORDER BY valor_total DESC;
```

### Detectar Usuários Inativos

```sql
SELECT 
    u.full_name,
    COUNT(DISTINCT t.id) as transacoes
FROM users u
LEFT JOIN transactions t ON u.id = t.user_id
GROUP BY u.id, u.full_name
HAVING COUNT(DISTINCT t.id) = 0
ORDER BY u.created_at DESC;
```

---

## Ordem de Processamento com GROUP BY

```
1. FROM + JOIN       ← Combina tabelas
2. WHERE            ← Filtra linhas (ANTES de agrupar)
3. GROUP BY         ← Agrupa
4. HAVING           ← Filtra grupos (DEPOIS de agrupar)
5. ORDER BY         ← Ordena
6. LIMIT            ← Limita resultados
```

### Exemplo Completo

```sql
SELECT 
    u.state,
    COUNT(DISTINCT u.id) as usuarios,
    SUM(t.amount) as total_gasto
FROM users u
LEFT JOIN transactions t ON u.id = t.user_id
WHERE u.created_at >= '2025-01-01'           -- 2. Filtra ANTES de GROUP BY
GROUP BY u.state                             -- 3. Agrupa
HAVING SUM(t.amount) > 5000                  -- 4. Filtra GRUPOS
ORDER BY total_gasto DESC                    -- 5. Ordena
LIMIT 10;                                    -- 6. Limita
```

---

## Regras de Ouro

✅ **Adicione TODAS as colunas não-agregadas em GROUP BY**
```sql
-- ✅ Correto
SELECT u.full_name, u.state, COUNT(p.id) as posts
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
GROUP BY u.id, u.full_name, u.state;

-- ❌ Errado (erro PostgreSQL)
SELECT u.full_name, u.state, COUNT(p.id) as posts
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
GROUP BY u.full_name;
```

✅ **Use HAVING para filtrar grupos**
```sql
HAVING COUNT(*) > 5
HAVING SUM(amount) > 1000
```

✅ **Use DISTINCT em agregações**
```sql
COUNT(DISTINCT user_id)   -- Usuários únicos
```

❌ **Evite:**
- Esquecer colunas em GROUP BY
- Confundir WHERE com HAVING
- Ignorar NULLs

---

## Próximos Passos

Você domina agregações! Próximo: **Subconsultas e CTEs** para análises ainda mais poderosas!

