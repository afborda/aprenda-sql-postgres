# 📚 Aprenda SQL PostgreSQL — Do Zero ao Sênior

![Aprenda SQL Postgres](assets/img.png)

> **Aprenda PostgreSQL do zero ao sênior com exercícios práticos, desafios contextualizados e dados reais de fintech brasileira**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-12+-blue.svg)](https://www.postgresql.org/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

---

## ⚡ Começar Agora (3 Passos)

### 1️⃣ Conectar ao Banco (escolha uma opção)

**Opção A: DBeaver (mais fácil, recomendado)**
- Baixe em [dbeaver.io](https://dbeaver.io)
- Clique em `+` → `PostgreSQL`
- Preencha:
  - **Host:** ep-odd-dream-ah5ij0pt-pooler.c-3.us-east-1.aws.neon.tech
  - **Database:** neondb
  - **User:** aluno_readonly
  - **Password:** AprendaSQL2025!
  - **SSL:** require
- Clique em `Test Connection` e depois `Finish`

**Opção B: Linha de Comando (psql)**
```bash
psql "postgresql://aluno_readonly:AprendaSQL2025!@ep-odd-dream-ah5ij0pt-pooler.c-3.us-east-1.aws.neon.tech/neondb?sslmode=require"
```

**Opção C: Outras ferramentas** (TablePlus, Postico, VS Code)
- Veja seção [🔌 Conexão Detalhada](#-conexão-ao-banco-de-dados) abaixo

### 2️⃣ Testar a Conexão
```sql
-- Cole isso no seu editor SQL:
SELECT COUNT(*) AS usuarios FROM users;
```
Deve retornar: **10,000**

### 3️⃣ Abrir Fase 1
- Vá para: `exercicios/fase_01_fundamentos/`
- Comece com: `pratica/01_select_basico.sql`
- Tempo: 20 minutos

---

## 🎯 Para Quem é Este Projeto?

✅ **Iniciantes totais** (sem experiência com SQL)  
✅ **Programadores** que precisam aprender SQL  
✅ **Analistas de dados** buscando estrutura e prática  
✅ **Profissionais** migrando de MySQL/Oracle para PostgreSQL  
✅ **Qualquer um** que quer dominar SQL progressivamente  

---

## 📊 Seu Plano de Aprendizado

### 12 Fases Completas (Básico → Especialista)

| # | Fase | O Que Você Aprenderá | Tempo | Dificuldade |
|---|------|---|---|---|
| 1 | **Fundamentos** | SELECT, WHERE, ORDER BY, LIMIT | 1 semana | ⭐ Básico |
| 2 | **Strings & Datas** | LIKE, IN, BETWEEN, Funções | 2 semanas | ⭐ Básico |
| 3 | **JOINs** | INNER, LEFT, Múltiplos joins | 2 semanas | ⭐⭐ |
| 4 | **Agregações** | GROUP BY, HAVING, SUM/AVG/COUNT | 2 semanas | ⭐⭐ |
| 5 | **CTEs e Windows** | WITH, Window Functions, Ranking | 3 semanas | ⭐⭐⭐ |
| 6 | **Avançado** | Recursão, LATERAL, Cohort Analysis | 3 semanas | ⭐⭐⭐ |
| 7 | **Performance** | EXPLAIN ANALYZE, Otimização de Queries | 2-3 semanas | ⭐⭐⭐ |
| 8 | **Índices** | BTREE, HASH, GiST, Estratégias | 2-3 semanas | ⭐⭐⭐ |
| 9 | **Transactions & Locks** | ACID, Isolation Levels, Deadlocks, Locks explícitos | 2-3 semanas | ⭐⭐⭐ |
| 10 | **Procedures & Triggers** | PL/pgSQL, funções, triggers BEFORE/AFTER | 2-3 semanas | ⭐⭐⭐ |
| 11 | **Análise de Fraudes** | Z-score, padrões suspeitos, scoring em tempo real | 3-4 semanas | ⭐⭐⭐⭐ |
| 12 | **Big Data & Particionamento** | Range/List/Hash partitioning, automação, retenção | 3-4 semanas | ⭐⭐⭐⭐ |

**Tempo total: ~5-6 meses (30 min/dia)**

### Bônus: Fase Extra — ETL na Prática
- Bronze → Silver → Gold pipeline
- Qualidade de dados em produção
- **Quando:** Depois da Fase 4

---

## 📈 O Que Você Sabe Fazer ao Final

### Após Fase 1 ⭐
```sql
SELECT nome, email FROM users WHERE estado = 'SP' ORDER BY nome LIMIT 10;
```

### Após Fase 2 ⭐
```sql
SELECT * FROM users 
WHERE email LIKE '%@gmail.com' 
  AND data_criacao >= '2024-01-01'
```

### Após Fase 3 ⭐⭐
```sql
SELECT u.nome, COUNT(t.id) AS transacoes
FROM users u
LEFT JOIN transactions t ON t.user_id = u.id
GROUP BY u.id, u.nome
```

### Após Fase 4 ⭐⭐
```sql
SELECT estado, payment_method, SUM(amount) AS total
FROM transactions
WHERE status = 'completed'
GROUP BY estado, payment_method
HAVING SUM(amount) > 10000
```

### Após Fase 5 ⭐⭐⭐
```sql
WITH user_totals AS (
  SELECT user_id, SUM(amount) as total
  FROM transactions GROUP BY user_id
)
SELECT *, ROW_NUMBER() OVER (ORDER BY total DESC) as ranking
FROM user_totals
```

### Após Fase 6 ⭐⭐⭐
```sql
-- CTEs recursivas, LATERAL joins, análise de coortes
WITH RECURSIVE mes_range AS (
  SELECT '2024-01-01'::DATE as mes
  UNION ALL
  SELECT mes + INTERVAL '1 month'
  FROM mes_range WHERE mes < '2024-12-01'
)
SELECT * FROM mes_range
```

### Após Fase 7 ⭐⭐⭐
```sql
-- Otimizar queries com EXPLAIN ANALYZE
EXPLAIN ANALYZE
SELECT u.state, COUNT(*) as transacoes
FROM users u
JOIN transactions t ON u.id = t.user_id
WHERE t.created_at > CURRENT_DATE - INTERVAL '30 days'
GROUP BY u.state
```

### Após Fase 8 ⭐⭐⭐
```sql
-- Criar índices estratégicos
CREATE INDEX idx_transactions_user_created 
ON transactions(user_id, created_at DESC);

CREATE INDEX idx_transactions_fraud 
ON transactions(user_id) WHERE fraud_score > 0.8;
```

### Após Fase 9 ⭐⭐⭐
```sql
-- Transação segura com isolamento SERIALIZABLE
BEGIN;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;
COMMIT;
```

### Após Fase 10 ⭐⭐⭐
```sql
-- Trigger de auditoria simples
CREATE OR REPLACE FUNCTION audit_transacoes()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO audit_log(table_name, ref_id, operacao, payload)
  VALUES (TG_TABLE_NAME, NEW.id, TG_OP, row_to_json(NEW));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_audit_transacoes
AFTER INSERT OR UPDATE ON transactions
FOR EACH ROW EXECUTE FUNCTION audit_transacoes();
```

### Após Fase 11 ⭐⭐⭐⭐
```sql
-- Z-score para detectar anomalias
WITH stats AS (
  SELECT AVG(amount) avg_amt, STDDEV(amount) std_amt FROM transactions
)
SELECT t.id, t.amount,
       (t.amount - s.avg_amt) / NULLIF(s.std_amt, 0) AS z_score
FROM transactions t CROSS JOIN stats s
WHERE (t.amount - s.avg_amt) / NULLIF(s.std_amt, 0) > 3;
```

### Após Fase 12 ⭐⭐⭐⭐
```sql
-- Particionamento por mês
CREATE TABLE transactions_partitioned (
  id BIGSERIAL PRIMARY KEY,
  user_id INT,
  amount NUMERIC,
  created_at TIMESTAMPTZ
) PARTITION BY RANGE (created_at);

CREATE TABLE trans_2024_01 PARTITION OF transactions_partitioned
FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');
```

---

## 🔌 Conexão ao Banco de Dados

### A) DBeaver (Recomendado — Visual e Fácil)

**Passo 1: Instalar**
- Baixe em https://dbeaver.io (versão Community é grátis)
- Instale como qualquer aplicação

**Passo 2: Conectar**
1. Abra o DBeaver
2. Clique em `Database` → `New Database Connection`
3. Selecione `PostgreSQL` e clique `Next`
4. Preencha:
   ```
   Server Host: ep-odd-dream-ah5ij0pt-pooler.c-3.us-east-1.aws.neon.tech
   Port: 5432
   Database: neondb
   Username: aluno_readonly
   Password: AprendaSQL2025!
   ```
5. Na aba `PostgreSQL`, marque **SSL: require**
6. Clique em `Test Connection` (deve aparecer ✅)
7. Clique `Finish`

**Passo 3: Testar**
- Clique duas vezes em `neondb` para expandir
- Procure a tabela `users`
- Clique botão direito → `SELECT Rows`
- Deve aparecer dados

### B) Postico 2 (macOS — Simples e Rápido)

- Instale via App Store (US$9.99) ou em https://eggerapps.at/postico/
- Abra e clique `+`
- Preencha as credenciais acima
- Conecte

### C) TablePlus (Windows, macOS, Linux)

- Instale em https://tableplus.com
- Clique `+` → `PostgreSQL`
- Preencha credenciais
- Salve e conecte

### D) VS Code (Desenvolvedor)

**Passo 1: Instalar extensão**
- Abra VS Code
- Extensions (Ctrl+Shift+X)
- Procure `SQLTools` + instale
- Instale também `SQLTools PostgreSQL Driver`

**Passo 2: Criar conexão**
- Clique ícone SQLTools (esquerda)
- Clique `+`
- Selecione PostgreSQL
- Preencha credenciais:
  ```json
  {
    "name": "Aprenda SQL",
    "host": "ep-odd-dream-ah5ij0pt-pooler.c-3.us-east-1.aws.neon.tech",
    "database": "neondb",
    "username": "aluno_readonly",
    "password": "AprendaSQL2025!",
    "port": 5432,
    "ssl": true
  }
  ```

### E) Linha de Comando (psql)

**Instalar psql:**
- Windows: https://www.postgresql.org/download/windows/
- macOS: `brew install postgresql`
- Linux: `sudo apt install postgresql-client`

**Conectar:**
```bash
psql "postgresql://aluno_readonly:AprendaSQL2025!@ep-odd-dream-ah5ij0pt-pooler.c-3.us-east-1.aws.neon.tech/neondb?sslmode=require"
```

**Testar:**
```sql
SELECT COUNT(*) FROM users;
\dt  -- listar tabelas
\q   -- sair
```

---

## 📂 Estrutura & Conteúdo

```
📁 exercicios/
├── fase_01_fundamentos/           SELECT, WHERE, ORDER BY
│   ├── README.md                  Comece aqui!
│   ├── teoria/01_conceitos.md     Explicação de conceitos
│   ├── pratica/                   3-4 exercícios para resolver
│   ├── pratica_respondida/        3-4 soluções comentadas
│   └── desafio/DESAFIOS_*.sql     6 desafios de negócio
│
├── fase_02_intermediario/         LIKE, IN, BETWEEN, Funções
├── fase_03_joins/                 INNER, LEFT, Múltiplos joins
├── fase_04_agregacoes/            GROUP BY, HAVING, Agregações
├── fase_05_ctes_subconsultas_windows/  CTEs, Window Functions
├── fase_06_advanced_ctes_windows/ CTEs Recursivas, LATERAL
│
└── fase_extra_etl/                ETL na Prática (Bronze→Silver→Gold)

📁 queries_uteis/
├── joins_exemplos.sql             Exemplos prontos de JOIN
├── agregacoes_exemplos.sql        SUM, COUNT, AVG, GROUP BY
└── ... mais exemplos

📄 QUICK_REFERENCE.sql             Cheat sheet rápido
📄 progresso.md                     Rastreie seu avanço
```

---

## 🚀 Como Estudar

### Rotina Recomendada (30 min/dia)

```
📍 15 min: Um Exercício
   1. Abra pratica/01_select_basico.sql
   2. Leia as instruções
   3. Tente resolver SEM VER A SOLUÇÃO
   4. Se travar em 5 min, veja a solução
   5. Entenda por que funciona

📍 10 min: Um Desafio
   1. Abra desafio/DESAFIOS_fase_01.sql
   2. Leia o contexto de negócio
   3. Tente resolver
   4. Compare com solução

📍 5 min: Revisar
   1. Releia um conceito da teoria
   2. Anote dúvidas em progresso.md
```

### Semana Tipo

| Dia | Exercício | Desafio | Avanço |
|-----|-----------|---------|--------|
| 2ª  | 01-02     | Ler 1-2 | Base   |
| 3ª  | 03        | Fazer 3 | Prática |
| 4ª  | Revisar   | Fazer 4 | Reforço |
| 5ª  | 01-03     | Fazer 5 | Speed  |
| 6ª  | 02-03     | Fazer 6 | Final  |
| Sábado | Resumir | Revisar | Check  |
| Domingo | Descansar |  |  |

---

## ✅ Checklist: Avançar Para Próxima Fase?

Responda com honestidade:

- [ ] Consegui fazer TODOS os exercícios da fase?
- [ ] Entendi a LÓGICA de cada solução (não só copiar)?
- [ ] Consegui fazer 5+ desafios SEM ver a resposta?
- [ ] Consigo explicar um exercício para um amigo?
- [ ] Levei menos de 10 min para resolver exercícios antigos?

**Se < 4 sim:** Revise antes de avançar  
**Se 4-5 sim:** Parabéns! Próxima fase 🚀

---

## 📊 Dados do Projeto

**10k+ registros reais de fintech brasileira:**

- **10,000 usuários** com CPF, email, endereço, estado
- **80,000 transações** com valor, data, método de pagamento
- **2,000 fraudes** com score de risco
- **15,000 posts** (redes sociais)
- **37,000 comentários**
- **10,000 contas bancárias**

Todos gerados com **Faker pt_BR** para máxima autenticidade.

---

## 🐛 Se Ficar Preso

### "Não entendi a sintaxe"
→ Procure em `queries_uteis/` ou `QUICK_REFERENCE.sql`

### "Não consigo resolver um desafio"
1. Releia o enunciado com atenção
2. Divida em partes menores
3. Comece com um `SELECT *` simples
4. Adicione `WHERE`, depois `GROUP BY`, etc.
5. Se ainda travar, durma e tente amanhã 😴

### "Minha query está muito lenta"
→ Normal para iniciantes! Fase 7-8 cobre performance  
→ Por enquanto, use `LIMIT 100` para testar

### "Acho muito fácil/muito difícil"
→ Cada pessoa aprende no seu ritmo!  
→ Mais rápido? Pule para desafios  
→ Muito difícil? Revise fase anterior

---

## 📈 Progressão Esperada

| Semana | Meta | Conquista |
|--------|------|-----------|
| 1-2 | Fase 1 | Escrevo meu primeiro SELECT ✅ |
| 3-4 | Fase 2 | Filtro dados como um pro 🎯 |
| 5-6 | Fase 3 | Faço JOINs sem medo 💪 |
| 7-8 | Fase 4 | Agrego dados para gráficos 📊 |
| 9-11 | Fase 5 | Window functions me fazem feliz 😊 |
| 12-14 | Fase 6 | Domino CTEs e recursion 🚀 |
| 15-16 | Fase 7 | Otimizo queries com EXPLAIN ⚡ |
| 17-18 | Fase 8 | Desenho índices estratégicos 🧭 |
| 19-20 | Fase 9 | Domino transações e locks 🔒 |
| 21-22 | Fase 10 | Automatizo regras com triggers 🛠️ |
| 23-25 | Fase 11 | Detecto fraudes em tempo real 🕵️ |
| 26-28 | Fase 12 | Particiono dados em escala 🌐 |

---

## 🎁 Bônus: Fase Extra — ETL

Depois que terminar Fase 4, você pode começar a **Fase Extra** (ETL na Prática):

- Limpar dados "sujos"
- Criar camadas Silver (dados limpos)
- Modelar camadas Gold para BI
- Usar window functions para deduplicar

Veja: `exercicios/fase_extra_etl/README.md`

---

## 💡 Dicas Valiosas

### Para Aprender Mais Rápido
- ✏️ Escreva comentários em CADA query explicando o que faz
- 👀 Leia soluções de outras pessoas
- 🔄 Refaça exercícios antigos SEM VER respostas
- 📝 Mantenha um "diário" de sintaxe que aprendeu

### Para Não Desanimar
- ✅ Complete UM exercício por dia = vitória!
- 📊 Veja seu progresso em `progresso.md`
- 🎉 Quando resolve desafio difícil, COMEMORE!
- 👥 Mostre pros amigos o que aprendeu

### Mindset Certo
- SQL é **lógica**, não mágica
- Erros são OK! Todo dev faz query errada
- Começar é mais importante que ser perfeito
- Consistência (30 min/dia) > intensidade (8h fim de semana)

---

## 🤝 Comunidade & Contribuição

- 💬 Dúvidas? Abra [Issue](../../issues)
- 🐛 Encontrou erro? Reporte
- ✨ Tem ideia? Sugira!
- 📝 Quer contribuir? PR bem-vindo

Leia [CONTRIBUTING.md](CONTRIBUTING.md)

---

## 📞 Precisa de Ajuda?

1. **Dúvida sobre SQL?** Procure em `QUICK_REFERENCE.sql`
2. **Exemplo de JOIN?** Veja `queries_uteis/joins_exemplos.sql`
3. **Travou em exercício?** Leia `pratica_respondida/`
4. **Conexão não funciona?** Revise seção [🔌 Conexão](#-conexão-ao-banco-de-dados)
5. **Ainda não resolve?** Abra [Issue](../../issues) com sua dúvida

---

## 📜 Licença

MIT License — Use livremente, dê crédito se fizer sentido.

---

## 📚 Resumo Rápido

| Quer | Faça |
|------|------|
| Começar AGORA | [⚡ Conectar ao Banco](#-começar-agora-3-passos) |
| Entender as fases | [📊 Seu Plano](#-seu-plano-de-aprendizado) |
| Conectar em 5 min | [🔌 Conexão](#-conexão-ao-banco-de-dados) |
| Estudar hoje | [🚀 Como Estudar](#-como-estudar) |
| Saber se está pronto | [✅ Checklist](#-checklist-avançar-para-próxima-fase) |
| Ver dados | [📊 Dados](#-dados-do-projeto) |
| Ajuda | [📞 Ajuda](#-precisa-de-ajuda) |

---

<div align="center">

**Feito com ❤️ para aprender SQL com alegria**

Não é preciso ser gênio, é preciso ser **consistente**.

30 minutos por dia × 3 meses = **SQL fluente** 🚀

Se gostou, dê uma ⭐ no GitHub!

[⬆ Voltar ao Topo](#-aprenda-sql-postgresql--do-zero-ao-sênior)

</div>
