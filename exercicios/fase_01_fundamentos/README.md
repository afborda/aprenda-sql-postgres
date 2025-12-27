# 🎯 Fase 1: Fundamentos SQL

![Fase 1 - Fundamentos](../../assets/img.png)

## 📚 O que você aprenderá nesta fase

- ✅ SELECT básico (colunas, *)
- ✅ Filtragem com WHERE (=, !=, >, <, IS NULL)
- ✅ Ordenação com ORDER BY (ASC, DESC)
- ✅ Limitação de resultados com LIMIT

---

## 📋 Estrutura dos Exercícios

### Exercício 1: SELECT Básico ⭐
**Arquivo:** `01_select_basico.sql`
- Tempo: 5 minutos
- Dificuldade: ⭐ Muito Fácil
- **O que fazer:**
  1. Abra o arquivo
  2. Leia os comentários
  3. Escreva suas queries
  4. Execute e compare com a solução

**Tópicos:**
- `SELECT *` - todas as colunas
- `SELECT coluna1, coluna2` - colunas específicas
- `LIMIT n` - primeiras n linhas

### Exercício 2: Filtragem com WHERE ⭐⭐
**Arquivo:** `02_where_basico.sql`
- Tempo: 8 minutos
- Dificuldade: ⭐⭐ Fácil
- **Tópicos:**
  - `WHERE coluna = valor` (igualdade)
  - `WHERE coluna != valor` (desigualdade)
  - `WHERE coluna > valor` (maior que)
  - `WHERE coluna IS NOT NULL` (não nulo)

### Exercício 3: ORDER BY e LIMIT ⭐⭐
**Arquivo:** `03_order_by_limit.sql`
- Tempo: 10 minutos
- Dificuldade: ⭐⭐ Fácil
- **Tópicos:**
  - `ORDER BY coluna ASC` (crescente)
  - `ORDER BY coluna DESC` (decrescente)
  - Combinar com `LIMIT`
  - Múltiplas colunas em ORDER BY

---

## 🎯 Desafios Contextualizados

**Arquivo:** `DESAFIOS_fase_01.sql`

Estes desafios simulam problemas reais que você encontrará como analista de dados:

1. **Cobertura Regional** - Análise geográfica
2. **Top Influencers** - Encontrar usuários mais ativos
3. **Fraude - Transações Altas** - Compliance
4. **Integridade de Dados** - Encontrar dados incompletos
5. **Lealdade** - Usuários antigos
6. **Bonus** - Combinação de técnicas

---

## ✅ Como Usar Este Material

### Passo 1️⃣ : Fazer os Exercícios
```bash
1. Abra 01_select_basico.sql
2. Leia os comentários
3. Escreva suas queries nos espaços [ESCREVA AQUI]
4. Execute no seu banco de dados
```

### Passo 2️⃣ : Verificar as Soluções
```bash
1. Abra 01_select_basico_SOLUCAO.sql
2. Compare com suas respostas
3. Entenda por que está certo
4. Se errou, tente novamente antes de ver a solução
```

### Passo 3️⃣ : Fazer os Desafios
```bash
1. Abra DESAFIOS_fase_01.sql
2. Leia o contexto de cada desafio
3. Tente resolver SEM VER A SOLUÇÃO
4. Teste e valide seus resultados
```

---

## 📊 Checklist de Progresso

- [ ] Exercício 1: SELECT Básico - ✅ Completo
- [ ] Exercício 2: WHERE - ✅ Completo
- [ ] Exercício 3: ORDER BY - ✅ Completo
- [ ] Desafios 1-5: ✅ Completo
- [ ] Desafio Bonus 6: ✅ Completo

---

## 🎯 Objetivos da Fase 1

**Ao final desta fase você deve:**

✅ Escrever queries SELECT sem consultar documentação
✅ Filtrar dados com WHERE sem hesitar
✅ Ordenar e limitar resultados automaticamente
✅ Resolver problemas reais de análise de dados

**Tempo total estimado:** 1-2 semanas (30 minutos por dia)

---

## 📖 Dicas Importantes

### ✨ Boas Práticas
- Sempre use nomes de coluna específicos (não `*` em produção)
- Indente seu código para legibilidade
- Use aliases quando trabalhar com múltiplas tabelas
- Teste suas queries incrementalmente

### 🐛 Erros Comuns
- ❌ Esquecer ponto-e-vírgula no final
- ❌ Usar `=` em WHERE com NULL (use `IS NULL`)
- ❌ Esquecer `DESC` quando quer valores maiores primeiro
- ❌ Usar `LIMIT` sem `ORDER BY` (ordem não garantida)

### 💡 Otimizações Rápidas
- WHERE filtra ANTES do SELECT (mais rápido)
- ORDER BY com índice é mais rápido
- LIMIT sempre vai no final

---

## 🚀 Próximo Passo

Quando terminar todos os exercícios:
1. Revise o roadmap teórico
2. Comece a **Fase 2: Consultas Intermediárias**
3. Pratique 30 minutos por dia

---

## 📝 Anotações Pessoais

Use este espaço para anotar dúvidas ou insights:

```
Dúvida: 
Solução:

Aprendizado importante:
```

Boa sorte! 🚀
