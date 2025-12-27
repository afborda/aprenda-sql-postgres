# ETL na Prática (Bronze → Silver → Gold)

## Conceitos fundamentais
- ETL: Extrair, Transformar, Carregar. Preferir cargas idempotentes e reexecutáveis.
- Camadas:
  - Bronze: dados crus, com possíveis inconsistências, duplicidades e formatos variados.
  - Silver: dados limpos e padronizados, chaves únicas, tipos e domínios validados.
  - Gold: dados prontos para consumo analítico/BI, agregados e modelados.
- Qualidade de dados:
  - Validade: formato e domínio corretos (e.g., CPF válido, UF ∈ {AC, AL, ...}).
  - Completude: campos obrigatórios presentes.
  - Unicidade: chaves únicas (e.g., CPF, account_number).
  - Consistência: relação entre atributos coerente (cidade ↔ UF, datas não futuras).
  - Exatidão: valores plausíveis (montantes não negativos, telefones válidos).
  - Tempestividade: dados no tempo correto (sem atrasos ou datas futuras indevidas).
- Boas práticas:
  - Idempotência: mesma execução produz o mesmo resultado.
  - Auditoria: `created_at`, `updated_at`, watermarks de carga.
  - Catálogo de regras: documentar checks e decisões.
  - Observabilidade: métricas de qualidade e relatórios.

## Estratégia para este curso
- Usaremos as tabelas existentes como Bronze.
- Construiremos camadas Silver como `VIEWs` (evita custo de armazenamento e facilita reexecução).
- Publicaremos camadas Gold também como `VIEWs` agregadas.
- Cada exercício direciona uma parte da curadoria.

## Referências úteis
- Expressões regulares para emails.
- Funções de data/hora e CASE para normalização.
- Window functions (PARTITION BY) para deduplicação e top-N.
- Agregações (GROUP BY) para fatos e dimensões.
