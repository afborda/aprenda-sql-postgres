# 🎯 Fase 3: Relacionamentos e JOINs

## 📚 O que você aprenderá nesta fase

- ✅ INNER JOIN (combinar tabelas relacionadas)
- ✅ LEFT JOIN (incluir todos da esquerda)
- ✅ Múltiplos JOINs (3+ tabelas)
- ✅ Aliases de tabelas
- ✅ Análises complexas com relacionamentos
- ✅ Identificar registros órfãos (sem relacionamento)

---

## 📋 Estrutura dos Exercícios

### Exercício 1: INNER JOIN Básico ⭐⭐
**Arquivo:** `01_inner_join.sql`
- Tempo: 10 minutos
- Dificuldade: ⭐⭐ Fácil
- **Tópicos:**
  - Sintaxe básica INNER JOIN
  - Aliases de tabelas (u, p, t)
  - Relacionamentos 1:N
  - Combinar WHERE com JOIN

### Exercício 2: LEFT JOIN ⭐⭐⭐
**Arquivo:** `02_left_join.sql`
- Tempo: 12 minutos
- Dificuldade: ⭐⭐⭐ Médio
- **Tópicos:**
  - LEFT JOIN vs INNER JOIN
  - Encontrar registros órfãos (IS NULL)
  - Contar com LEFT JOIN
  - GROUP BY com LEFT JOIN

### Exercício 3: Múltiplos JOINs ⭐⭐⭐⭐
**Arquivo:** `03_multiplos_joins.sql`
- Tempo: 15 minutos
- Dificuldade: ⭐⭐⭐⭐ Avançado
- **Tópicos:**
  - Combinar 3+ tabelas
  - INNER + LEFT juntos
  - SELF JOIN (mesma tabela)
  - Análises complexas

---

## 🎯 Desafios Contextualizados

**Arquivo:** `DESAFIOS_fase_03.sql`

Estes desafios aplicam múltiplos conceitos:

1. **Relatório de Engajamento** - Segmentar usuários por atividade
2. **Análise de Risco por Região** - Mapear fraudes geograficamente
3. **Posts Virais sem Engajamento** - Views altas, comentários baixos
4. **Perfil Financeiro** - Criar ofertas personalizadas
5. **Usuários em Risco de Churn** - Identificar inativos
6. **Bonus: Dashboard Executivo** - Visão 360° do negócio

---

## ✅ Como Usar Este Material

### Passo 1️⃣: Entender JOINs Visualmente
```
INNER JOIN:          LEFT JOIN:
┌─────┬─────┐       ┌─────┬─────┐
│  A  │  B  │       │  A  │  B  │
│ ┌───┼───┐ │       │ ┌───┼───┐ │
│ │████████│ │       │ │█████████│ │ ← Todos de A
│ └───┼───┘ │       │ └───┼───┘ │
└─────┴─────┘       └─────┴─────┘
  Apenas             A + matches
  intersecção        com B
```

### Passo 2️⃣: Fazer os Exercícios
```bash
1. Abra 01_inner_join.sql
2. Tente resolver cada exercício
3. Execute no PostgreSQL
4. Compare com a solução
```

### Passo 3️⃣: Ler Queries Complexas
```sql
-- Como ler mentalmente:
SELECT colunas
FROM tabela_principal tp      -- 1. Começa aqui (base)
INNER JOIN tabela2 t2         -- 2. Junta com esta
    ON tp.id = t2.foreign_key -- 3. Usando esta condição
LEFT JOIN tabela3 t3          -- 4. Depois junta (mesmo sem match)
    ON t2.id = t3.foreign_key -- 5. Com esta condição
WHERE tp.status = 'ativo'     -- 6. Filtra tudo no final
```

---

## 📊 Checklist de Progresso

- [ ] Exercício 1: INNER JOIN - ✅ Completo
- [ ] Exercício 2: LEFT JOIN - ✅ Completo
- [ ] Exercício 3: Múltiplos JOINs - ✅ Completo
- [ ] Desafios 1-5: ✅ Completo
- [ ] Desafio Bonus 6: ✅ Completo

---

## 🎯 Objetivos da Fase 3

**Ao final desta fase você deve:**

✅ Combinar 2+ tabelas com confiança
✅ Escolher entre INNER e LEFT JOIN corretamente
✅ Encontrar registros órfãos com IS NULL
✅ Criar análises complexas com múltiplas tabelas
✅ Ler e entender queries grandes
✅ Usar aliases para organizar código

**Tempo total estimado:** 2-3 semanas (45 minutos por dia)

---

## 📖 Dicas Importantes

### ✨ Sobre INNER JOIN
- Retorna APENAS registros que têm match nas duas tabelas
- Use quando precisa de dados completos
- Mais restritivo que LEFT JOIN

### ✨ Sobre LEFT JOIN
- Retorna TODOS da tabela esquerda
- Use para encontrar "quem não tem"
- Combine com IS NULL para órfãos

### ✨ Sobre Múltiplos JOINs
- Organize visualmente (uma linha por JOIN)
- Use aliases curtos (u, p, t)
- Leia de cima para baixo

### 🐛 Erros Comuns
- ❌ Esquecer ON (condição do JOIN)
- ❌ Usar INNER quando precisa LEFT
- ❌ Não usar DISTINCT com múltiplos LEFT JOIN
- ❌ Esquecer GROUP BY ao contar

---

## 💡 Quando Usar Cada JOIN

| Situação | JOIN Correto |
|----------|--------------|
| "Posts E seus autores" | INNER JOIN |
| "Todos usuários, com ou sem posts" | LEFT JOIN |
| "Usuários SEM posts" | LEFT JOIN + IS NULL |
| "Dados de 3+ tabelas" | Múltiplos JOINs |

---

## 🚀 Próximo Passo

Quando terminar Fase 3:
1. Revise conceitos de JOINs
2. Comece a **Fase 4: Agregações e GROUP BY**
3. Mantenha prática de 45 min/dia

---

## 📝 Anotações Pessoais

Use este espaço para anotar dúvidas ou insights:

```
Dúvida: 
Solução:

Aprendizado importante:
```

Boa sorte! 🚀
