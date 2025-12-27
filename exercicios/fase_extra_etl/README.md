# Fase Extra — ETL na Prática

> **Objetivo:** Consolidar um pipeline ETL completo: Bronze → Silver → Gold com checks, limpezas, deduplicações e modelagem para BI.

## 📚 O Que Você Vai Aprender

Após esta fase, você saberá:
- ✅ Identificar e categorizar problemas de qualidade de dados
- ✅ Construir camadas Silver com validação e normalização
- ✅ Modelar dimensões e fatos para BI
- ✅ Usar window functions para deduplicação
- ✅ Implementar pipelines idempotentes

## 🗂️ Estrutura

```
├── teoria/
│   └── 01_conceitos.md ..................... ETL, qualidade de dados, Bronze/Silver/Gold
│
├── pratica/
│   ├── 01_detectar_inconsistencias_basicas.sql
│   ├── 02_deduplicar_usuarios_silver.sql
│   ├── 03_limpar_transacoes_silver.sql
│   ├── 04_dim_merchants_gold.sql
│   ├── 05_fato_transacoes_gold.sql
│   └── 06_fraude_curadoria_gold.sql
│
├── pratica_respondida/
│   ├── 01_detectar_inconsistencias_basicas_SOLUCAO.sql
│   ├── 02_deduplicar_usuarios_silver_SOLUCAO.sql
│   ├── 03_limpar_transacoes_silver_SOLUCAO.sql
│   ├── 04_dim_merchants_gold_SOLUCAO.sql
│   ├── 05_fato_transacoes_gold_SOLUCAO.sql
│   └── 06_fraude_curadoria_gold_SOLUCAO.sql
│
└── desafio/
    └── DESAFIOS_fase_extra_etl.sql ......... 6 desafios avançados
```

## 📋 Exercícios

### Pratica (6)
1. **Detectar inconsistências básicas**: Email inválido, CPF/CEP mal formatados, UF inválida.
2. **Deduplicar usuários (Silver)**: Remover duplicatas por CPF, manter mais recente.
3. **Limpar transações (Silver)**: Filtrar amount > 0, status válido, sem datas futuras.
4. **Dimensão de Merchants (Gold)**: Agregação por merchant (contagem, valor total).
5. **Fato de Transações (Gold)**: Agregação por dia, UF, método e tipo.
6. **Curadoria de Fraudes (Gold)**: Join fraud_data com Silver, categorizar risco.

### Desafios (6)
1. **silver_accounts**: Dedup com window function.
2. **Detecção de outliers**: Z-score por usuário.
3. **Auditoria referencial**: Transações órfãs.
4. **Carga incremental**: Watermark idempotente.
5. **Top merchants por UF**: Top-3 com ROW_NUMBER.
6. **Dashboard de qualidade**: Métricas agregadas de DQ.

## 🎯 Fluxo Recomendado

1. **Leia a teoria** (10 min): [teoria/01_conceitos.md](teoria/01_conceitos.md)
2. **Faça os exercícios** (45 min): abra `pratica/01-06` e tente resolver
3. **Compare com soluções** (15 min): veja `pratica_respondida/01-06`
4. **Faça os desafios** (1h+): [desafio/DESAFIOS_fase_extra_etl.sql](desafio/DESAFIOS_fase_extra_etl.sql)

## 📊 Contexto de Dados

- **users**: 10,000 | CPF, email, estado
- **user_accounts**: 10,000 | Dedup por account_number
- **transactions**: 80,000 | 8 por usuário, com status e timestamp
- **fraud_data**: ~2,000 | Score 0.60–1.00, linked a transactions
- **posts**: 15,000 | Faker pt_BR, 0–3 por usuário
- **comments**: 37,000 | 0–5 por post

## 🔑 Pré-requisitos

- Tabelas criadas (veja [Banco.sql](../../Banco.sql))
- Dados carregados (via seed Faker ou SQL)
- Conhecimento de fases 1–4 (SELECT, JOIN, GROUP BY)
- Familiaridade com window functions é +

## 💡 Dicas

- **Comece simples**: query sem agregação, depois adicione `WHERE`/`GROUP BY`
- **Testes**: use `LIMIT 10` ou `LIMIT 1000` para testar rápido
- **Views**: `CREATE OR REPLACE VIEW` facilita reexecução
- **Validação**: `COUNT(*)` antes e depois para confirmar limpeza
