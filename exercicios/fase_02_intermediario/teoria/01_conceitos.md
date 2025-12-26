# 🎓 Conceitos Intermediários - Fase 2

## Pattern Matching com LIKE

### O Que É?

`LIKE` permite buscar por **padrões de texto** em vez de valores exatos. Perfeito para buscas em nomes, emails, endereços, etc.

```sql
SELECT * FROM users WHERE full_name LIKE 'Maria%';  -- Nomes que começam com "Maria"
```

### Wildcards (Caracteres Especiais)

| Wildcard | Significado | Exemplo |
|----------|-------------|---------|
| `%` | Qualquer número de caracteres | `'Maria%'` = Maria, Mariana, Mariana Silva |
| `_` | Exatamente um caractere | `'Jo_o'` = João, Joao (mas não Johnson) |

### Exemplos

```sql
-- Começa com...
SELECT * FROM users WHERE full_name LIKE 'J%';  -- João, José, Juliana, etc

-- Termina com...
SELECT * FROM users WHERE full_name LIKE '%Silva';  -- João Silva, Maria Silva, etc

-- Contém...
SELECT * FROM users WHERE full_name LIKE '%Silva%';  -- Em qualquer posição

-- Um caractere específico
SELECT * FROM users WHERE full_name LIKE 'Jo_o';  -- João ou Joao
```

### ILIKE - Case Insensitive

```sql
-- ❌ LIKE é case-sensitive
SELECT * FROM users WHERE full_name LIKE 'maria%';  -- Pode não achar "Maria"

-- ✅ ILIKE ignora maiúsculas/minúsculas
SELECT * FROM users WHERE full_name ILIKE 'maria%';  -- Acha "Maria", "MARIA", "maria"
```

---

## Operadores IN, NOT IN, BETWEEN

### IN - Múltiplos Valores

Em vez de usar vários `OR`:

```sql
-- ❌ Verboso
SELECT * FROM users WHERE state = 'SP' OR state = 'RJ' OR state = 'MG';

-- ✅ Conciso
SELECT * FROM users WHERE state IN ('SP', 'RJ', 'MG');
```

### NOT IN - Excluir Valores

```sql
-- Todos EXCETO esses estados
SELECT * FROM users WHERE state NOT IN ('SP', 'RJ', 'MG');
```

### BETWEEN - Ranges

```sql
-- Transações entre R$ 100 e R$ 500
SELECT * FROM transactions WHERE amount BETWEEN 100 AND 500;

-- Equivalente a:
SELECT * FROM transactions WHERE amount >= 100 AND amount <= 500;
```

**Nota:** BETWEEN inclui os limites (100 e 500 são incluídos).

---

## Funções de String

### UPPER() e LOWER()

```sql
SELECT 
    full_name,
    UPPER(full_name) as maiusculas,
    LOWER(full_name) as minusculas
FROM users;
```

### LENGTH()

```sql
-- Tamanho do nome
SELECT 
    full_name,
    LENGTH(full_name) as comprimento
FROM users
ORDER BY LENGTH(full_name) DESC;
```

### SUBSTRING()

Extrair parte de uma string:

```sql
SUBSTRING(texto, posição_inicial, quantidade)

-- Primeiros 3 dígitos de um CPF
SELECT 
    cpf,
    SUBSTRING(cpf, 1, 3) as cpf_inicio
FROM users;

-- Do caractere 5 até o final
SELECT SUBSTRING('João Silva', 5);  -- 'Silva'
```

### CONCAT()

Juntar strings:

```sql
-- Concatenar nome e cidade
SELECT 
    full_name,
    city,
    CONCAT(full_name, ' - ', city) as usuario_local
FROM users;

-- Equivalente a:
SELECT full_name || ' - ' || city as usuario_local FROM users;
```

---

## Funções de Data

### NOW() e CURRENT_DATE

```sql
SELECT 
    NOW()           -- 2025-12-26 14:30:45.123456
    CURRENT_DATE    -- 2025-12-26
    CURRENT_TIME    -- 14:30:45
;
```

### AGE() - Diferença entre Datas

```sql
-- Quantos dias a conta tem
SELECT 
    full_name,
    created_at,
    AGE(NOW(), created_at) as idade_conta
FROM users;

-- Resultado: "1 year 2 months 10 days"
```

### EXTRACT() - Extrair Partes

```sql
-- Extrair ano, mês, dia
SELECT 
    full_name,
    created_at,
    EXTRACT(YEAR FROM created_at) as ano,
    EXTRACT(MONTH FROM created_at) as mes,
    EXTRACT(DAY FROM created_at) as dia
FROM users;
```

### DATE_TRUNC() - Truncar Data

```sql
-- Remover hora
SELECT DATE(created_at) FROM posts;

-- Remover hora:minuto:segundo
SELECT DATE_TRUNC('day', created_at) FROM posts;

-- Truncar para mês
SELECT DATE_TRUNC('month', created_at) FROM posts;
```

### INTERVAL - Períodos de Tempo

```sql
-- Usuários criados nos últimos 30 dias
SELECT * FROM users
WHERE created_at >= NOW() - INTERVAL '30 days';

-- Outras opções:
INTERVAL '1 year'
INTERVAL '3 months'
INTERVAL '7 days'
INTERVAL '24 hours'
```

---

## Exemplos Práticos Completos

### Buscar Emails de um Domínio

```sql
SELECT full_name, email
FROM users
WHERE email LIKE '%.com';
```

### Nomes Longos (> 20 caracteres)

```sql
SELECT 
    full_name,
    LENGTH(full_name) as tamanho
FROM users
WHERE LENGTH(full_name) > 20
ORDER BY tamanho DESC;
```

### Transações em Valor Específico

```sql
SELECT user_id, amount, transaction_type
FROM transactions
WHERE amount BETWEEN 100 AND 500
  AND transaction_type IN ('purchase', 'transfer')
ORDER BY amount DESC;
```

### Análise Temporal

```sql
-- Posts criados em 2025
SELECT 
    title,
    created_at,
    EXTRACT(YEAR FROM created_at) as ano
FROM posts
WHERE EXTRACT(YEAR FROM created_at) = 2025;
```

---

## Combinando Tudo

```sql
SELECT 
    UPPER(full_name) as usuario,
    LOWER(email) as email_padrao,
    LENGTH(full_name) as tamanho_nome,
    EXTRACT(YEAR FROM created_at) as ano_criacao,
    AGE(NOW(), created_at) as tempo_membro
FROM users
WHERE full_name ILIKE '%silva%'
  AND created_at >= NOW() - INTERVAL '1 year'
ORDER BY tamanho_nome DESC
LIMIT 10;
```

---

## Próximos Passos

Você domina pattern matching, operadores lógicos e funções. Próximo: **JOINs** para combinar múltiplas tabelas!

