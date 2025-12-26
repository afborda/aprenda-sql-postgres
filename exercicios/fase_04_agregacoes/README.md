# Fase 4: Agregações e Resumos 📈

![Fase 4 - Agregações](../../assets/img.png)

## Visão Geral

A quarta fase ensina como **resumir e analisar dados em massa** usando agregações. Você aprenderá funções como COUNT, SUM, AVG, GROUP BY e HAVING para criar relatórios executivos.

**Tempo total:** 2-3 semanas (45 min/dia)  
**Público:** Intermediários com conhecimento de Fase 3  
**Pré-requisitos:** Completar Fase 3 ✅

---

## 📚 Estrutura de Aprendizado

Este módulo está organizado em 4 subpastas:

- **pratica/** - Exercícios em branco para você resolver
- **pratica_respondida/** - Soluções comentadas
- **teoria/** - Conceitos e explicações (em breve)
- **desafio/** - 6 desafios contextualizados em fintech

---

## 📖 Tópicos Cobertos

### 1. **GROUP BY e Funções Agregadas Básicas** (pratica/01_group_by_basico.sql)
Aprenda a:
- Agrupar resultados (`GROUP BY`)
- Contar registros (`COUNT()`)
- Somar valores (`SUM()`)
- Calcular média (`AVG()`)
- Encontrar máximo/mínimo (`MAX()`, `MIN()`)

**Conceitos chave:** `GROUP BY`, `COUNT()`, `SUM()`, `AVG()`, `MAX()`, `MIN()`

**Exemplo:**
```sql
SELECT u.full_name, COUNT(p.id) as total_posts
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
GROUP BY u.id, u.full_name;
```

---

### 2. **Cláusula HAVING e Filtros Avançados** (pratica/02_having_filtros.sql)
Aprenda a:
- Filtrar grupos (`HAVING`)
- Diferenciar `WHERE` (antes do agrupamento) de `HAVING` (depois)
- Combinar múltiplas condições
- Fazer análises avançadas

**Conceitos chave:** `HAVING`, `WHERE vs HAVING`

**Exemplo:**
```sql
SELECT u.full_name, SUM(t.amount) as total_gasto
FROM users u
LEFT JOIN transactions t ON u.id = t.user_id
GROUP BY u.id, u.full_name
HAVING SUM(t.amount) > 1000;
```

---

### 3. **Agregações por Dimensão** (pratica/03_agregacoes_dimensao.sql)
Aprenda a:
- Agrupar por múltiplas colunas
- Análise dimensional (estado, tipo, etc)
- Combinar múltiplas agregações
- Criar relatórios estruturados

**Conceitos chave:** `GROUP BY` múltiplas colunas, análise dimensional

**Exemplo:**
```sql
SELECT u.state, t.transaction_type, SUM(t.amount) as total
FROM users u
LEFT JOIN transactions t ON u.id = t.user_id
GROUP BY u.state, t.transaction_type
ORDER BY u.state, total DESC;
```

---

### 4. **Relatórios Executivos Completos** (pratica/04_relatorios_executivos.sql)
Aprenda a:
- Combinar múltiplas técnicas
- Criar relatórios estruturados
- Fazer análises de negócio
- Otimizar queries

**Conceitos chave:** Agregações avançadas, CTEs, análises de negócio

**Exemplo:**
```sql
SELECT 
    u.full_name,
    COUNT(DISTINCT p.id) as posts,
    SUM(t.amount) as gasto,
    CASE WHEN SUM(t.amount) > 2000 THEN 'VIP' ELSE 'Regular' END as categoria
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
LEFT JOIN transactions t ON u.id = t.user_id
GROUP BY u.id, u.full_name;
```

---

## 🎯 Desafios Contextualizados

Todos baseados em **cenários reais de negócio**:

1. **Receita por Região** - Análise geográfica de vendas
2. **Segmentação de Usuários** - VIP/Premium/Regular tiers
3. **Detecção de Contas Inativas** - Retenção de usuários
4. **Análise de Tipos de Transação** - Mix de produtos
5. **Usuários de Alto Risco** - Monitoramento de fraude
6. **Benchmark de Performance** - Comparação com média

Veja as soluções em `desafio/DESAFIOS_fase_04.sql`

---

## 🎓 Como Usar Este Material

### Passo 1: Review de Fases Anteriores
Certifique-se que domina JOINs antes de começar (cruciais para agregações).

### Passo 2: Resolver Exercícios Progressivamente
1. Comece com GROUP BY simples
2. Adicione HAVING
3. Agregue múltiplas dimensões
4. Crie relatórios completos

### Passo 3: Entender Casos de Uso
Não é só sobre sintaxe, mas quando usar cada agregação.

### Passo 4: Fazer Desafios
Complete os 6 desafios para aplicar em contexto real.

---

## 📊 Funções Agregadas Disponíveis

| Função | Descrição | Exemplo |
|--------|-----------|---------|
| `COUNT(*)` | Conta linhas | `COUNT(t.id)` |
| `SUM(col)` | Soma valores | `SUM(t.amount)` |
| `AVG(col)` | Média aritmética | `AVG(p.views)` |
| `MIN(col)` | Valor mínimo | `MIN(t.amount)` |
| `MAX(col)` | Valor máximo | `MAX(t.amount)` |
| `COUNT(DISTINCT col)` | Conta únicos | `COUNT(DISTINCT u.id)` |

---

## 💡 Dicas Importantes

✅ **Sempre adicione todas as colunas não agregadas a GROUP BY**
```sql
-- ✅ Correto
SELECT u.full_name, COUNT(p.id) as total
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
GROUP BY u.id, u.full_name;

-- ❌ Errado (erro PostgreSQL)
SELECT u.full_name, u.state, COUNT(p.id) as total
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
GROUP BY u.full_name;
```

✅ **Use WHERE para filtrar antes do agrupamento, HAVING para depois**
```sql
SELECT u.state, COUNT(*) as usuarios
FROM users u
WHERE u.state IN ('SP', 'RJ')  -- WHERE antes de GROUP BY
GROUP BY u.state
HAVING COUNT(*) > 5;  -- HAVING depois de GROUP BY
```

✅ **Cuidado com NULLs em agregações**
```sql
-- NULLS são ignorados por COUNT()
SELECT COUNT(phone) FROM users;  -- Conta apenas não-nulos
SELECT COUNT(*) FROM users;  -- Conta tudo

-- Use COALESCE para substituir
SELECT SUM(COALESCE(amount, 0)) FROM transactions;
```

❌ **Evite:**
- Esquecer de adicionar coluna em GROUP BY
- Confundir WHERE com HAVING
- Usar COUNT(*) quando quer COUNT(coluna_especifica)
- Não considerar NULLs em cálculos

---

## 📈 Progressão Esperada

| Dia | Exercício | Tempo |
|-----|-----------|-------|
| 1-3 | GROUP BY Básico | 45 min |
| 4-6 | HAVING e Filtros | 45 min |
| 7-9 | Agregações por Dimensão | 45 min |
| 10-12 | Relatórios Executivos | 60 min |
| 13-21 | Desafios (6 total) | 90-120 min |

---

## 🔗 Próximas Etapas

Quando terminar Fase 4, você está pronto para:
- **Fase 5:** Subconsultas e CTEs (em breve)
- **Fase 6:** Window Functions (em breve)
- Análises reais de dados!

---

## 🚀 Banco de Dados Público

**Conexão read-only:**
```
Host: ep-odd-dream-ah5ij0pt-pooler.c-3.us-east-1.aws.neon.tech
Database: neondb
User: aluno_readonly
Password: AprendaSQL2025!
```

---

## ❓ Recursos

- [GROUP BY](https://www.postgresql.org/docs/current/sql-select.html#SQL-GROUPBY)
- [Aggregate Functions](https://www.postgresql.org/docs/current/functions-aggregate.html)
- [HAVING Clause](https://www.postgresql.org/docs/current/sql-select.html#SQL-HAVING)

---

**Você já domina quase tudo sobre SQL! 🎉**

