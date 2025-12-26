# 🎓 Conceitos Fundamentais - Fase 1

## SELECT - A Operação Mais Importante SQL

### O Que É?

`SELECT` é a operação SQL que **busca e retorna dados** de uma tabela. É como dizer: "Quero ver esses dados".

```sql
SELECT * FROM users;  -- Retorna TODOS os dados da tabela users
```

### Sintaxe Básica

```sql
SELECT colunas
FROM tabela
WHERE condições
ORDER BY colunas
LIMIT n;
```

---

## Componentes Principais

### 1. **SELECT** (O que retornar)

```sql
SELECT *                    -- Todas as colunas
SELECT full_name, email     -- Colunas específicas
SELECT DISTINCT state       -- Valores únicos apenas
```

### 2. **FROM** (De onde buscar)

```sql
FROM users          -- Uma tabela
FROM posts          -- Outra tabela
```

### 3. **WHERE** (Filtrar resultados)

Aplicado **ANTES** de ordenar/limitar. Usa operadores:
- `=` : igual
- `!=` ou `<>` : diferente
- `>`, `<` : maior/menor
- `>=`, `<=` : maior/igual, menor/igual
- `IS NULL` : valores vazios
- `IS NOT NULL` : valores não-vazios

```sql
SELECT full_name, email
FROM users
WHERE state = 'SP';  -- Apenas usuários de SP
```

### 4. **ORDER BY** (Ordenar resultados)

```sql
ORDER BY full_name ASC      -- Ordem alfabética (A-Z)
ORDER BY created_at DESC    -- Data decrescente (mais recente primeiro)
ORDER BY state, full_name   -- Por estado, depois nome
```

### 5. **LIMIT** (Limitar quantidade)

```sql
LIMIT 10        -- Apenas 10 primeiro resultados
LIMIT 5 OFFSET 10  -- Pule 10, pegue 5 (pagination)
```

---

## Exemplos Práticos

### Buscar Todos os Usuários

```sql
SELECT * FROM users;
-- Retorna: 10 linhas, 12 colunas (id, username, email, full_name, cpf, phone, address, city, state, zip_code, created_at, updated_at)
```

### Buscar Apenas Nomes e Emails

```sql
SELECT full_name, email FROM users;
-- Retorna: 10 linhas, 2 colunas
```

### Usuários de São Paulo

```sql
SELECT full_name, email, state
FROM users
WHERE state = 'SP';
-- Retorna: 2 linhas (João, Maria)
```

### Top 3 Posts Mais Visualizados

```sql
SELECT title, views
FROM posts
ORDER BY views DESC
LIMIT 3;
-- Retorna: 3 linhas com posts mais vistos
```

---

## Ordem de Execução

PostgreSQL processa sua query nesta ordem:

1. **FROM** - Identifica a(s) tabela(s)
2. **WHERE** - Filtra linhas
3. **ORDER BY** - Ordena resultados
4. **LIMIT** - Limita quantidade

### ⚠️ Não Funciona Assim:

```sql
-- ❌ ERRADO: LIMIT primeiro, WHERE depois
SELECT * FROM users LIMIT 5 WHERE state = 'SP';

-- ✅ CORRETO: WHERE primeiro, LIMIT depois
SELECT * FROM users WHERE state = 'SP' LIMIT 5;
```

---

## Tabela de Referência Rápida

| Operador | Significado | Exemplo |
|----------|-------------|---------|
| `=` | Igual | `WHERE state = 'SP'` |
| `!=` | Diferente | `WHERE state != 'RJ'` |
| `>` | Maior | `WHERE views > 100` |
| `<` | Menor | `WHERE amount < 500` |
| `>=` | Maior/Igual | `WHERE likes >= 10` |
| `<=` | Menor/Igual | `WHERE id <= 5` |
| `IS NULL` | Valor vazio | `WHERE phone IS NULL` |
| `IS NOT NULL` | Não vazio | `WHERE email IS NOT NULL` |

---

## Dicas Importantes

✅ **Use nomes claros**
```sql
-- ✅ Bom
SELECT full_name, email FROM users WHERE state = 'SP';

-- ❌ Ruim
SELECT fn, e FROM u WHERE s = 'SP';
```

✅ **Sempre especifique colunas quando possível**
```sql
-- ✅ Melhor performance
SELECT full_name, email FROM users;

-- ❌ Menos eficiente
SELECT * FROM users;
```

✅ **Use LIMIT para testar**
```sql
-- Teste sua query primeiro com LIMIT
SELECT * FROM transactions WHERE amount > 1000 LIMIT 5;

-- Depois remova ou aumente LIMIT
SELECT * FROM transactions WHERE amount > 1000;
```

---

## Próximos Passos

Você aprendeu `SELECT` básico. Próximo: **WHERE avançado e operadores lógicos**
