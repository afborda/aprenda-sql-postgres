# 🎓 Conceitos de Relacionamentos - Fase 3

## Introdução aos JOINs

### O Que É um JOIN?

Um `JOIN` **combina dados de múltiplas tabelas** baseado em uma relação comum (chave estrangeira).

Sem JOINs, você teria que buscar dados em várias queries. Com JOINs, tudo em uma!

```sql
-- ❌ Sem JOIN (ineficiente - 2 queries)
SELECT * FROM posts WHERE user_id = 1;
SELECT * FROM users WHERE id = 1;

-- ✅ Com JOIN (eficiente - 1 query)
SELECT p.*, u.full_name
FROM posts p
INNER JOIN users u ON p.user_id = u.id
WHERE p.user_id = 1;
```

---

## Relacionamentos Entre Tabelas

### 1:N (Um para Muitos)

```
users (1) ──── posts (N)
  id          user_id
  
Um usuário TEM muitos posts.
Um post PERTENCE a um usuário.
```

```
users (1) ──── transactions (N)
  id           user_id
```

### Chave Estrangeira (Foreign Key)

A coluna `user_id` em `posts` referencia `id` em `users`:

```sql
-- Em posts, user_id aponta para users.id
posts.user_id = users.id
```

---

## INNER JOIN

### O Que Faz?

Retorna **apenas registros que existem em AMBAS as tabelas**.

```
Tabela Esquerda    JOIN    Tabela Direita
(posts)                    (users)
    ↓                         ↓
Apenas as interseções ↓←─────↓
```

### Sintaxe

```sql
SELECT colunas
FROM tabela_esquerda t1
INNER JOIN tabela_direita t2 ON t1.chave_estrangeira = t2.chave_primaria;
```

### Exemplo Prático

```sql
SELECT p.title, u.full_name
FROM posts p
INNER JOIN users u ON p.user_id = u.id;
```

**Resultado:** Posts com nome do autor (apenas posts que têm autor)

---

## LEFT JOIN

### O Que Faz?

Retorna **TODOS os registros da tabela ESQUERDA**, mesmo se não tiverem correspondência na direita.

```
Tabela Esquerda    LEFT JOIN    Tabela Direita
(users)                         (posts)
    ↓                              ↓
TODOS de users + matching posts
```

### Sintaxe

```sql
SELECT colunas
FROM tabela_esquerda t1
LEFT JOIN tabela_direita t2 ON t1.chave_primaria = t2.chave_estrangeira;
```

### Exemplo Prático

```sql
SELECT u.full_name, COUNT(p.id) as total_posts
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
GROUP BY u.id, u.full_name;
```

**Resultado:** Todos os usuários com contagem de posts (inclusive usuários que não postaram = 0)

---

## Identificar Nulos em LEFT JOINs

Quando um usuário não tem posts, as colunas de `posts` serão `NULL`:

```sql
SELECT u.full_name, p.title
FROM users u
LEFT JOIN posts p ON u.id = p.user_id;

-- Alguns resultados:
-- João da Silva | Dica de Segurança
-- João da Silva | NULL              ← João não tem todos os posts?
-- Maria Oliveira | Como Economizar
-- Carlos Santos | NULL              ← Carlos não tem nenhum post
```

Filtrar para encontrar usuários SEM posts:

```sql
SELECT u.full_name
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
WHERE p.id IS NULL;  -- ← Nulo = sem correspondência
```

---

## Aliases (Apelidos)

Abrevie nomes longos para facilitar leitura:

```sql
-- ✅ Com aliases
SELECT u.full_name, p.title, c.content
FROM users u
INNER JOIN posts p ON u.id = p.user_id
INNER JOIN comments c ON p.id = c.post_id;

-- ❌ Sem aliases (verboso!)
SELECT users.full_name, posts.title, comments.content
FROM users
INNER JOIN posts ON users.id = posts.user_id
INNER JOIN comments ON posts.id = comments.post_id;
```

---

## Múltiplos JOINs

Combinando 3+ tabelas:

```sql
SELECT 
    c.content as comentario,
    p.title as post,
    u1.full_name as autor_comentario,
    u2.full_name as autor_post
FROM comments c
INNER JOIN posts p ON c.post_id = p.id
INNER JOIN users u1 ON c.user_id = u1.id          -- Quem comentou
INNER JOIN users u2 ON p.user_id = u2.id;         -- Quem criou o post
```

---

## Ordem de JOINs

```
FROM tabela1
INNER JOIN tabela2 ON ...
LEFT JOIN tabela3 ON ...
INNER JOIN tabela4 ON ...
WHERE ...
GROUP BY ...
ORDER BY ...
```

**Importante:** JOINs são processados de cima para baixo, esquerda para direita.

---

## Tabela Comparativa: INNER vs LEFT

| Aspecto | INNER JOIN | LEFT JOIN |
|--------|-----------|-----------|
| Retorna | Apenas matches | TODOS da esquerda |
| Tabela nula | Nunca | Se não houver match |
| Uso | Análises com integridade | Encontrar não-matches, contar |
| Exemplo | Pedidos com clientes | Clientes com/sem pedidos |

---

## Exemplos Prático Completos

### Posts com Autor e Comentários

```sql
SELECT 
    p.title,
    u.full_name as autor,
    COUNT(c.id) as total_comentarios
FROM posts p
INNER JOIN users u ON p.user_id = u.id
LEFT JOIN comments c ON p.id = c.post_id
GROUP BY p.id, p.title, u.full_name
ORDER BY total_comentarios DESC;
```

### Usuários e Suas Atividades

```sql
SELECT 
    u.full_name,
    COUNT(DISTINCT p.id) as posts,
    COUNT(DISTINCT c.id) as comentarios,
    COUNT(DISTINCT t.id) as transacoes
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
LEFT JOIN comments c ON u.id = c.user_id
LEFT JOIN transactions t ON u.id = t.user_id
GROUP BY u.id, u.full_name;
```

### Análise de Fraude com JOINs

```sql
SELECT 
    fd.fraud_type,
    fd.fraud_score,
    u.full_name,
    t.amount,
    t.merchant
FROM fraud_data fd
INNER JOIN users u ON fd.user_id = u.id
INNER JOIN transactions t ON fd.transaction_id = t.id
WHERE fd.is_fraud = TRUE
ORDER BY fd.fraud_score DESC;
```

---

## Regras de Ouro

✅ **Sempre use aliases**
```sql
FROM posts p INNER JOIN users u ON ...
```

✅ **Seja claro no ON**
```sql
ON p.user_id = u.id  ← Deixa claro qual coluna referencia qual
```

✅ **Use LEFT JOIN para encontrar não-matches**
```sql
LEFT JOIN ... WHERE campo IS NULL
```

❌ **Evite:**
- Cartesian products (JOIN sem ON)
- Confundir INNER e LEFT JOIN
- Esquecer de adicionar WHERE/GROUP BY se necessário

---

## Próximos Passos

Você aprendeu a combinar tabelas com JOINs. Próximo: **Agregações** para resumir dados!

