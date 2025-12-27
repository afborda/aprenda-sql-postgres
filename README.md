# aprenda-sql-postgres

![Aprenda SQL Postgres](assets/img.png)

> Aprenda PostgreSQL do zero ao sênior com exercícios práticos, desafios contextualizados e dados reais de fintech brasileira

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-12+-blue.svg)](https://www.postgresql.org/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![GitHub Stars](https://img.shields.io/github/stars/afborda/aprenda-sql-postgres?style=social)](https://github.com/afborda/aprenda-sql-postgres)

---

## 🎯 Para Quem é Este Projeto?

✅ **Iniciantes** que querem aprender SQL do zero  
✅ **Desenvolvedores** que precisam melhorar suas queries  
✅ **Analistas de dados** buscando prática  
✅ **Profissionais** migrando para PostgreSQL  
✅ **Qualquer pessoa** que quer dominar SQL progressivamente  

---

## 🚀 O Que Você Vai Aprender

### 📊 12 Fases Progressivas

| Fase | Tópicos | Dificuldade | Status |
|------|---------|-------------|--------|
| **1** | SELECT, WHERE, ORDER BY, LIMIT | ⭐ Básico | ✅ Completo |
| **2** | LIKE, IN, BETWEEN, Funções String/Data | ⭐ Básico | ✅ Completo |
| **3** | INNER JOIN, LEFT JOIN, Múltiplos JOINs | ⭐⭐ Intermediário | ✅ Completo |
| **4** | GROUP BY, HAVING, Agregações, Relatórios | ⭐⭐ Intermediário | ✅ Completo |
| **5-6** | CTEs, Subconsultas, Window Functions | ⭐⭐⭐ Intermediário+ | 📅 Planejado |
| **7-8** | Views, Índices, Otimização | ⭐⭐⭐⭐ Avançado | 📅 Planejado |
| **9-10** | Triggers, Procedures, Transações | ⭐⭐⭐⭐ Avançado+ | 📅 Planejado |
| **11-12** | Performance, Particionamento, Big Data | ⭐⭐⭐⭐⭐ Expert | 📅 Planejado |

### 🎯 Metodologia de Aprendizado

- ✅ **Baby Steps**: Progressão gradual e natural, sem pulos
- ✅ **Contexto Real**: Dados de fintech brasileira (CPF, PIX, fraudes)
- ✅ **Exercícios Práticos**: 40+ exercícios com soluções detalhadas
- ✅ **Desafios de Negócio**: Cenários reais de marketing, compliance, fraudes
- ✅ **30 min/dia**: Aprenda sem pressa, com consistência

---

## 📂 Estrutura do Projeto

```
📁 aprenda-sql-postgres/
├── 📄 Banco.sql ..................... Banco completo com 110 usuários BR + seed
├── 📁 exercicios/
│   ├── fase_01_fundamentos/ ...... SELECT, WHERE, ORDER BY (✅ completo)
│   │   ├── pratica/ ............... 3 exercícios em branco
│   │   ├── pratica_respondida/ ... 3 soluções comentadas
│   │   ├── desafio/ .............. 6 desafios contextualizados
│   │   ├── teoria/ ............... Conceitos (em breve)
│   │   └── README.md ............. Guia completo
│   │
│   ├── fase_02_intermediario/ .... LIKE, IN, BETWEEN, Funções (✅ completo)
│   │   ├── pratica/ ............... 4 exercícios em branco
│   │   ├── pratica_respondida/ ... 4 soluções comentadas
│   │   ├── desafio/ .............. 6 desafios contextualizados
│   │   ├── teoria/ ............... Conceitos (em breve)
│   │   └── README.md ............. Guia completo
│   │
│   ├── fase_03_joins/ ............ INNER, LEFT, Múltiplos (✅ completo)
│   │   ├── pratica/ ............... 3 exercícios em branco
│   │   ├── pratica_respondida/ ... 3 soluções comentadas
│   │   ├── desafio/ .............. 6 desafios contextualizados
│   │   ├── teoria/ ............... Conceitos (em breve)
│   │   └── README.md ............. Guia completo
│   │
│   └── fase_04_agregacoes/ ....... GROUP BY, HAVING, Agregações (✅ completo)
│       ├── pratica/ ............... 4 exercícios em branco
│       ├── pratica_respondida/ ... 4 soluções comentadas
│       ├── desafio/ .............. 6 desafios contextualizados
│       ├── teoria/ ............... Conceitos (em breve)
│       └── README.md ............. Guia completo
│
├── 📁 scripts/
│   └── seed_extra_100.sql ....... Seed idempotente (+100 registros)
├── 📁 queries_uteis/
│   └── por_topico/ ............... 21+ exemplos prontos para uso
├── 📁 docs/
│   └── ROADMAP_COMPLETO.md ....... Teoria das 12 fases
├── 📄 QUICK_REFERENCE.sql ........ Referência rápida de SQL
├── 📄 progresso.md ............... Template de tracking pessoal
├── 📄 CONTRIBUTING.md ............ Como contribuir
└── 📄 LICENSE .................... MIT License
```

### 📈 Estatísticas do Projeto

- **48+ Exercícios** com soluções detalhadas (12 exercícios × 4 fases)
- **24+ Desafios** contextualizados (6 desafios × 4 fases)
- **21+ Queries** de exemplo prontas para usar
- **4 Fases Completas** (básico → intermediário+)
- **110+ Registros** de dados reais brasileiros
- **6 Tabelas** com relacionamentos complexos


---

## 🎯 Como Começar Hoje

### 1️⃣ Setup (5 min)
```bash
# 1. Crie o banco de dados
psql -U seu_usuario -d seu_banco -f Banco.sql

# 2. Verifique os dados
SELECT COUNT(*) FROM users;  -- deve retornar 10
```

### 2️⃣ Primeira Aula (20 min)
```bash
# 1. Abra o arquivo
cat exercicios/fase_01_fundamentos/01_select_basico.sql

# 2. Resolva os exercícios
# 3. Compare com a solução
# 4. Avance para o próximo
```

### 3️⃣ Fazer Desafios (15 min)
```bash
# 1. Abra DESAFIOS_fase_01.sql
# 2. Tente resolver SEM VER A SOLUÇÃO
# 3. Execute e teste
# 4. Valide os resultados
```

---

## 📋 Rotina Diária (30-45 minutos)

```
15 min: Exercício prático
        └─ Abra um arquivo da fase atual
        └─ Tente resolver sem ajuda
        └─ Confira a solução

15 min: Desafio contextualizado
        └─ Leia o contexto de negócio
        └─ Tente resolver
        └─ Valide resultados

10 min: Revisão de conceitos
        └─ Releia a teoria correspondente
        └─ Anote dúvidas
        └─ Consulte queries_uteis/
```

---

## 📂 Como Navegar o Projeto

### Para Cada Fase (1, 2, 3, 4...)

Cada fase possui a seguinte estrutura:

```
fase_XX_topico/
├── pratica/              ← Abra aqui primeiro!
│   ├── 01_exercicio.sql   (complete os [ESCREVA AQUI])
│   ├── 02_exercicio.sql
│   └── ...
│
├── pratica_respondida/   ← Apenas se pedir ajuda
│   ├── 01_exercicio_SOLUCAO.sql
│   ├── 02_exercicio_SOLUCAO.sql
│   └── ...
│
├── desafio/              ← Depois dos exercícios
│   └── DESAFIOS_fase_XX.sql  (6 desafios com soluções)
│
├── teoria/               ← Em desenvolvimento
│   ├── 01_conceitos.md
│   └── ...
│
└── README.md             ← Leia primeiro (10 min)
```

### Fluxo Recomendado

1. **Leia o README.md** da fase (entenda os tópicos)
2. **Abra pratica/01_exercicio.sql** (leia as instruções)
3. **Escreva sua solução** (tente sem ajuda)
4. **Confira pratica_respondida/** (valide seu código)
5. **Faça os 6 desafios** em desafio/ (aplique tudo)
6. **Avance para próxima fase**

---

## ✅ Checklist de Completude

### Antes de Avançar para a Próxima Fase

- [ ] Fiz TODOS os exercícios
- [ ] Entendi CADA query
- [ ] Resolvi TODOS os desafios
- [ ] Consigo resolver em < 10 minutos
- [ ] Taxa de acerto >= 90%
- [ ] Revisei a teoria

---

## 📊 Velocidade Esperada

| Fase | Exercícios | Desafios | Tempo/dia | Dias | Total |
|------|-----------|----------|-----------|------|-------|
| 1    | 3         | 6        | 30 min    | 7    | 3.5h  |
| 2    | 5         | 8        | 30 min    | 10   | 5h    |
| 3    | 5         | 8        | 30 min    | 10   | 5h    |
| 4    | 5         | 8        | 45 min    | 14   | 10.5h |

**Total Fases 1-4: ~24 horas** (1 mês em 30 min/dia)

---

## 🎯 Competências por Fase

### Fase 1: Fundamentos ⭐
Você saberá:
- [ ] Escrever SELECT
- [ ] Filtrar com WHERE
- [ ] Ordenar com ORDER BY

### Fase 2: Intermediário ⭐⭐
Você saberá:
- [ ] Pattern matching (LIKE)
- [ ] Funções (string, data)
- [ ] CASE WHEN

### Fase 3: JOINs ⭐⭐
Você saberá:
- [ ] INNER JOIN
- [ ] LEFT JOIN
- [ ] Múltiplos JOINs

### Fase 4: Agregação ⭐⭐
Você saberá:
- [ ] GROUP BY
- [ ] COUNT, SUM, AVG
- [ ] HAVING

---

## 🐛 Troubleshooting

### Problema: "Esqueci a sintaxe de SELECT"
**Solução:** Abra `queries_uteis/` e veja exemplos

### Problema: "Não consigo resolver um desafio"
**Solução:** 
1. Releia o enunciado
2. Veja exemplos similares
3. Tente uma query mais simples primeiro
4. Construa incrementalmente

### Problema: "Minha query está lenta"
**Solução:** Isso será tratado na Fase 7 (Performance)
Por enquanto: `LIMIT 100` para testar

### Problema: "Consigo resolver mas demorando muito"
**Solução:** Normal! A velocidade vem com prática
Meta: 30 min/dia × 30 dias = fluidez

---

## 🚀 Além das Aulas

### Praticar Diariamente
- Comece pelo menos 1 exercício por dia
- Incremente para 2-3 quando ficar confortável
- Faça revisões semanais

### Explorar Dados Reais
Depois de cada fase, faça perguntas sobre SEU banco:
- "Quantos usuários temos por estado?"
- "Qual é o valor médio de transação?"
- "Quem é o usuário mais ativo?"

### Rever Conceitos
Toda semana:
1. Pegue um exercício antigo
2. Resolva novamente SEM VER A SOLUÇÃO
3. Medía o tempo
4. Note se melhorou

---

## 📈 Rastreamento de Progresso

**Arquivo:** `progresso.md`

Atualize semanalmente:
- [ ] Quantos exercícios completou?
- [ ] Qual era sua velocidade?
- [ ] Qual foi sua taxa de acerto?
- [ ] O que foi fácil/difícil?

---

## 🤝 Como Contribuir

Este projeto é **open source** e aceita contribuições! 

- 🐛 **Encontrou um erro?** Abra uma [Issue](../../issues/new)
- ✨ **Tem uma ideia?** Sugira melhorias
- 📝 **Quer adicionar conteúdo?** Envie um Pull Request

Leia o [CONTRIBUTING.md](CONTRIBUTING.md) para mais detalhes.

---

## 📜 Licença

Este projeto está sob a licença MIT. Veja [LICENSE](LICENSE) para mais detalhes.

---

## ⭐ Apoie Este Projeto

Se este projeto te ajudou:

- ⭐ Dê uma estrela no GitHub
- 🔄 Compartilhe com amigos
- 💬 Dê feedback e sugestões
- 🤝 Contribua com novos exercícios

---

## 🎓 Recursos Extras

### Quando Ficar Confuso
1. Veja exemplos similares em `queries_uteis/`
2. Leia a teoria no `ROADMAP_COMPLETO.md`
3. Procure por "DICA:" nos exercícios

### Quando Quiser Aprender Mais
1. Procure por "BONUS:" nos desafios
2. Crie suas próprias queries sobre os dados
3. Simule problemas reais que quer resolver

### Quando Estiver Preso
```
1. Pause por 15 minutos
2. Veja uma query similiar resolvida
3. Tente novamente
4. Se ainda tiver dúvida, pule e volte depois
```

---

## 💡 Dicas de Ouro

### ✨ Para Aprender Mais Rápido
- Escreva comentários explicativos em CADA query
- Leia o código dos outros (soluções)
- Tente reescrever queries de outras formas

### ✨ Para Não Perder Motivation
- Complete um desafio por dia = ✅
- Veja seu progresso crescer no `progresso.md`
- Quando resolver um desafio duro, celebre!

### ✨ Para Praticar 30 Min/Dia
```
15 min: 1 exercício (tentar + solução)
10 min: 1 desafio (tentar)
5 min:  Atualizar progresso.md
```

---

## 📞 Contato e Comunidade

- 💬 **Dúvidas?** Abra uma [Issue](../../issues) com tag `question`
- 🐛 **Bugs?** Abra uma [Issue](../../issues) com tag `bug`
- 💡 **Sugestões?** Abra uma [Issue](../../issues) com tag `enhancement`

---

<div align="center">

**Feito com ❤️ para a comunidade brasileira de dados**

Se este projeto te ajudou, considere dar uma ⭐

[⬆ Voltar ao topo](#-aprenda-sql-postgres)

</div>

---

## 🚀 Próximos Passos

1. **Hoje:** Começar Fase 1, Exercício 1
2. **Semana 1:** Terminar Fase 1
3. **Semana 2:** Fazer Fase 2
4. **Mês 1:** Fases 1-2 completas
5. **Mês 6:** Fases 1-8 (nível intermediário)
6. **Ano 1:** Sênior em PostgreSQL 🎉

---

## 📞 Dúvidas?

Se ficar preso:
1. Procure a resposta nos arquivos
2. Releia o enunciado do exercício
3. Veja exemplos similares
4. Tente uma abordagem diferente

**Você consegue!** 💪

---

Bom estudo! 🚀📚

---

## 🌐 Acesso Público ao Banco (Neon)

Para praticar sem instalar nada, conecte ao banco público READ-ONLY:

- Host: ep-odd-dream-ah5ij0pt-pooler.c-3.us-east-1.aws.neon.tech
- Database: neondb
- User: aluno_readonly
- Password: AprendaSQL2025!
- Port: 5432
- SSL: required

### psql (terminal)
```bash
psql "postgresql://aluno_readonly:AprendaSQL2025!@ep-odd-dream-ah5ij0pt-pooler.c-3.us-east-1.aws.neon.tech/neondb?sslmode=require"
```

### DBeaver / Postico / TablePlus
- Protocol: PostgreSQL
- SSL: require
- Credenciais conforme acima

### Ferramentas recomendadas (GUI)

As opções abaixo permitem conectar, navegar pelas tabelas e executar queries de forma visual. Use as credenciais da seção acima (SSL obrigatório).

#### Postico 2 (macOS)
- Instale via App Store ou site oficial.
- Abra o app → New Favorite → tipo "PostgreSQL".
- Preencha: Host, Database, User, Password, SSL: "require".
- Clique em "Connect" e rode: `SELECT COUNT(*) FROM users;`.

#### DBeaver (Windows, macOS, Linux)
- Baixe em dbeaver.io e instale.
- File → New → Database → PostgreSQL.
- Host, Database, User, Password; em SSL marque "Use SSL" e modo "require".
- Teste a conexão e finalize.

#### TablePlus (macOS, Windows)
- Instale via tableplus.com.
- New Connection → PostgreSQL → informe Host, Database, User, Password.
- Em SSL, marque "Require SSL" e conecte.

#### Beekeeper Studio (Linux, Windows, macOS)
- Instale via beekeeperstudio.io ou gerenciador de pacotes.
- New Connection → PostgreSQL → informe credenciais e SSL: require.

#### pgAdmin 4
- Instale via site oficial ou gerenciador de pacotes.
- Create Server → Host, Database (opcional), User, Password.
- Em SSL, defina "Require".

#### DataGrip (JetBrains)
- Instale via JetBrains Toolbox.
- Add Data Source → PostgreSQL → informe Host/DB/User/Password.
- Em SSL, selecione "require".

#### VS Code
- Instale uma extensão de SQL, por exemplo: "SQLTools" + "SQLTools PostgreSQL Driver" ou "PostgreSQL".
- Crie uma conexão usando a URI abaixo ou preenchendo os campos.
- Abra arquivos `.sql` e execute suas queries diretamente.

### Strings de conexão e variáveis de ambiente

#### URI (copie e cole)
```
postgresql://aluno_readonly:AprendaSQL2025!@ep-odd-dream-ah5ij0pt-pooler.c-3.us-east-1.aws.neon.tech/neondb?sslmode=require
```

#### Via variáveis de ambiente (psql)
```bash
export PGHOST=ep-odd-dream-ah5ij0pt-pooler.c-3.us-east-1.aws.neon.tech
export PGDATABASE=neondb
export PGUSER=aluno_readonly
export PGPASSWORD=AprendaSQL2025!
export PGSSLMODE=require
psql
```

#### Testes rápidos após conectar (psql)
```sql
-- listar tabelas
\dt
-- contar usuários
SELECT COUNT(*) FROM users;
-- exemplo nas transações
SELECT COUNT(*) FROM transactions;
```

### Tabelas disponíveis
- `users` (10 registros)
- `transactions` (10)
- `posts` (10)
- `comments` (11)
- `fraud_data` (6)
- `user_accounts` (10)

Este usuário é somente leitura: não permite INSERT/UPDATE/DELETE/TRUNCATE.

Se algo sair do ar, recriamos os dados via `Banco.sql`.

### Dataset ampliado (público)
Em 26/12/2025 ampliamos o dataset do banco público com ~100 registros adicionais para cada entidade principal.

- users: 110
- transactions: 110
- posts: 110
- comments: 111
- fraud_data: 56
- user_accounts: 110

Como foi gerado:
- Script idempotente: `scripts/seed_extra_100.sql`
- Usa `generate_series`, arrays de cidades/estados e guardas `ON CONFLICT`/`NOT EXISTS`
- Pode ser reexecutado sem duplicar dados

Para contribuir com mais dados, abra uma Issue ou PR sugerindo novos seeds.
