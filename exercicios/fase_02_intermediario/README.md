# Fase 2: Consultas Intermediárias 📊

## Visão Geral

A segunda fase aprofunda suas habilidades SQL com **técnicas de busca avançada e manipulação de dados**. Você aprenderá Pattern Matching, operadores lógicos, funções de string e funções de data.

**Tempo total:** 2-3 semanas (45 min/dia)  
**Público:** Iniciantes com conhecimento de Fase 1  
**Pré-requisitos:** Completar Fase 1 ✅

---

## 📚 Estrutura de Aprendizado

Este módulo está organizado em 4 subpastas:

- **pratica/** - Exercícios em branco para você resolver
- **pratica_respondida/** - Soluções comentadas
- **teoria/** - Conceitos e explicações (em breve)
- **desafio/** - 6 desafios contextualizados em fintech

---

## 📖 Tópicos Cobertos

### 1. **Pattern Matching com LIKE** (pratica/01_pattern_matching.sql)
Aprenda a:
- Buscar por padrões com `LIKE`
- Usar wildcards (`%` e `_`)
- Busca case-insensitive (`ILIKE`)

**Conceitos chave:** `LIKE`, `ILIKE`, `%`, `_`

---

### 2. **Operadores IN, NOT IN, BETWEEN** (pratica/02_operadores_in_between.sql)
Aprenda a:
- Filtrar múltiplos valores (`IN`)
- Excluir valores (`NOT IN`)
- Filtrar ranges (`BETWEEN`)

**Conceitos chave:** `IN`, `NOT IN`, `BETWEEN`, `AND`

---

### 3. **Funções de String** (pratica/03_funcoes_string.sql)
Aprenda a:
- Converter maiúsculas/minúsculas (`UPPER`, `LOWER`)
- Medir comprimento (`LENGTH`)
- Extrair substrings (`SUBSTRING`)
- Concatenar strings (`CONCAT`)

**Conceitos chave:** `UPPER()`, `LOWER()`, `LENGTH()`, `SUBSTRING()`, `CONCAT()`

---

### 4. **Funções de Data** (pratica/04_funcoes_data.sql)
Aprenda a:
- Trabalhar com data/hora (`NOW()`, `CURRENT_DATE`)
- Calcular diferenças (`AGE()`)
- Extrair partes (`EXTRACT()`)
- Truncar datas (`DATE_TRUNC()`)

**Conceitos chave:** `NOW()`, `CURRENT_DATE`, `AGE()`, `EXTRACT()`, `DATE_TRUNC()`, `INTERVAL`

---

## 🎯 Desafios Contextualizados

Todos os desafios aplicam **cenários reais de negócio**:

1. **Busca de Email por Domínio** - Segmentação de marketing
2. **Análise de Nomes Longos** - Compatibilidade com SMS
3. **Transações em Range Específico** - Políticas de compliance
4. **Normalização de Dados** - Busca case-insensitive
5. **Formatação de Dados** - Relatórios padronizados
6. **Análise Temporal de Contas** - Idade média das contas

Veja as soluções em `desafio/DESAFIOS_fase_02.sql`

---

## 🎓 Como Usar Este Material

### Passo 1: Review de Fase 1
Certifique-se que domina SELECT, WHERE, ORDER BY antes de começar.

### Passo 2: Resolver Exercícios em Ordem
Comece em `pratica/01_pattern_matching.sql` e siga sequencialmente.

### Passo 3: Validar com Soluções
Compare suas respostas com `pratica_respondida/`.

### Passo 4: Fazer Desafios
Complete todos os 6 desafios para praticar integração de conceitos.

---

## 📊 Dados Disponíveis

Você tem acesso a **6 tabelas** com **110+ registros** de dados brasileiros:

- **users** (110) - Usuários com nomes, emails, CPFs brasileiros
- **posts** (110) - Posts com visualizações
- **comments** (111) - Comentários em posts
- **transactions** (110) - Transações com tipos variados
- **fraud_data** (56) - Detecção de fraudes
- **user_accounts** (110) - Contas bancárias e cartões

---

## 💡 Dicas Importantes

✅ **Use LIKE com wildcards corretamente**
```sql
SELECT * FROM users WHERE full_name LIKE 'Maria%';  -- Começa com
SELECT * FROM users WHERE full_name LIKE '%Silva';  -- Termina com
SELECT * FROM users WHERE full_name LIKE '%Silva%'; -- Contém
```

✅ **Combine WHERE com filtros avançados**
```sql
SELECT * FROM transactions 
WHERE amount BETWEEN 100 AND 500 AND transaction_type IN ('purchase', 'transfer');
```

✅ **Use funções de data para análises temporais**
```sql
SELECT full_name, EXTRACT(YEAR FROM created_at) as ano FROM users;
```

❌ **Evite:**
- Misturar LIKE com operadores lógicos sem parênteses
- Esquecer que LIKE é case-sensitive (use ILIKE para flexibilidade)
- Confundir BETWEEN (inclui limites) com operadores comparativos

---

## 📈 Progressão Esperada

| Dia | Exercício | Tempo |
|-----|-----------|-------|
| 1-3 | Pattern Matching | 45 min |
| 4-6 | IN / NOT IN / BETWEEN | 45 min |
| 7-9 | Funções de String | 45 min |
| 10-12 | Funções de Data | 45 min |
| 13-21 | Desafios (6 total) | 90-120 min |

---

## 🔗 Próximas Etapas

Quando terminar Fase 2, avance para:
- **Fase 3:** Relacionamentos e JOINs
- **Fase 4:** Agregações e Resumos

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

- [LIKE Pattern Matching](https://www.postgresql.org/docs/current/functions-matching.html)
- [String Functions](https://www.postgresql.org/docs/current/functions-string.html)
- [Date/Time Functions](https://www.postgresql.org/docs/current/functions-datetime.html)

---

**Parabéns por chegar à Fase 2! 🎉**

