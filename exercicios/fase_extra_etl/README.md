# Fase Extra — ETL na Prática

Objetivo: aplicar ETL e qualidade de dados com o dataset realista (Faker pt_BR). Vamos consolidar um pipeline Bronze → Silver → Gold com checks, limpezas, deduplicações e modelagem para BI.

Conteúdo:
- Teoria: conceitos ETL, qualidade (validade, completude, unicidade, consistência, exatidão, tempestividade), Bronze/Silver/Gold, idempotência, auditoria.
- 6 exercícios: detecção de problemas, criação de camadas Silver/Gold e agregações.
- 6 soluções: SQL de referência.
- 6 desafios: problemas práticos de curadoria e orquestração.

Pré-requisitos:
- Tabelas existentes: users, user_accounts, transactions, fraud_data, posts, comments.
- Banco com dados carregados (seeds Faker ou SQL).

Como usar:
- Leia a teoria em teoria/01_conceitos.md.
- Resolva os arquivos em pratica/ e compare com pratica_respondida/.
- Enfrente os desafios em desafio/DESAFIOS_fase_extra_etl.sql.
