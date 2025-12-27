# CTEs Avançadas e Window Functions

## CTEs Recursivas
- Estrutura: `WITH RECURSIVE nome AS (base UNION ALL iteração) ...`
- Uso: árvores, hierarquias, séries, caminhos.
- Cuidado: loop infinito; sempre adicione `LIMIT` ou condição de parada.

## LATERAL
- `FROM ... LATERAL (subquery)` permite referência a colunas anteriores.
- Útil com `TOP-N` por grupo ou cálculos que dependem de linha anterior.
- Performance: mais rápido que correlação em muitos casos.

## Window Functions Avançadas
- `NTILE(n)`: divide em n quantis.
- `PERCENT_RANK()`: percentual de ranking (0–1).
- `CUMSUM` com `SUM() OVER (ORDER BY ...)`: soma cumulativa.
- `LAG/LEAD`: acesso a linhas anterior/seguinte.
- `FIRST_VALUE/LAST_VALUE`: primeiro/último em janela.

## Boas práticas
- Teste CTEs recursivas em pequena escala primeiro.
- Use `EXPLAIN ANALYZE` para comparar LATERAL vs subconsultas.
- Combine window functions em um `SELECT` para evitar múltiplos `ORDER BY` (performance).
