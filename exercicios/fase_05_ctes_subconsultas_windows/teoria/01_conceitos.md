# CTEs, Subconsultas e Window Functions

## CTE (`WITH`)
- Estrutura: `WITH nome AS (SELECT ...) SELECT ... FROM nome`.
- Uso comum: etapas legíveis, reutilização, pipelines.
- Idempotência e clareza em ETL (pré-agrupamentos, filtros).

## Subconsultas
- Escalares: retornam um valor (ex.: média global).
- Em linha (derived tables): `FROM (SELECT ...) s`.
- Correlacionadas: referenciam a linha externa (`WHERE EXISTS (...)`).

## Window Functions
- `OVER (PARTITION BY ... ORDER BY ...)` não reduz linhas.
- Padrões: `ROW_NUMBER`, `RANK`, `SUM/AVG OVER`, `LAG/LEAD`.
- Úteis para ranking, comparações, médias móveis, dedupe.

## Boas práticas
- Comece com CTE para legibilidade.
- Prefira `JOIN` a subconsultas quando possível (performance).
- Use filtros `WHERE` após calcular janelas (evita cortar partições).
