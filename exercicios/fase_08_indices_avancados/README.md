# 📑 Fase 8: Índices Avançados

**Nível**: ⭐⭐⭐ (Avançado)  
**Duração**: 2-3 semanas  
**Pré-requisitos**: Fases 1-7 completas

## 🎯 Objetivos

Nesta fase você vai aprender a:
- ✅ Entender diferentes tipos de índices (BTREE, HASH, GIST, BRIN, GIN)
- ✅ Escolher o índice apropriado para cada caso
- ✅ Criar índices compostos (multi-coluna)
- ✅ Índices parciais (índices que cobrem apenas algumas linhas)
- ✅ Índices expressões (em cálculos)
- ✅ Monitorar e manter índices em produção

## 📚 Conteúdo

### Teoria
- Tipos de índices em PostgreSQL
- BTREE: o padrão universal
- HASH: igualdade rápida
- GiST: estruturas de dados geométricas
- BRIN: índices para séries de tempo grandes
- GIN: busca full-text e arrays
- Trade-offs: leitura vs escrita vs espaço em disco

### Prática
6 exercícios focados em estratégias de indexação:

1. **Índices BTREE vs HASH** - Entender quando usar cada um
2. **Índices Compostos** - Acelerar múltiplas colunas
3. **Índices Parciais** - Reduzir tamanho do índice
4. **Índices em Expressões** - Indexar cálculos
5. **Monitorar Índices** - Encontrar índices não usados
6. **Estratégia de Indexação Completa** - Caso de estudo produção

### Desafios
6 desafios práticos:

1. Otimizar índices para query complexa
2. Encontrar e remover índices redundantes
3. Criar estratégia de índice para novo schema
4. Identificar índices que causam lentidão em writes
5. Análise de tamanho e impacto de índices
6. Caso de produção: migrar para índices melhores

## 🔄 Fluxo de Aprendizado

```
├─ Entender tipos de índices
├─ BTREE (padrão): quando e como
├─ Índices especializados (HASH, GIST, BRIN, GIN)
├─ Índices compostos (multi-coluna)
├─ Índices parciais e expressões
├─ Monitoramento e manutenção
└─ Estratégia completa para produção
```

## 💡 Dicas Importantes

1. **BTREE é o padrão** - Use-o a menos que tenha razão específica
2. **Índices têm custos** - Aumentam tempo de INSERT/UPDATE/DELETE
3. **Menos é mais** - Mais índices ≠ mais rápido
4. **Monitor regularmente** - Remova índices não usados
5. **Teste tudo** - Compare EXPLAIN ANALYZE antes e depois

## 🚀 Após esta fase você será capaz de:

- 🏗️ Escolher o tipo de índice apropriado
- 📊 Criar índices compostos e parciais
- 🔍 Monitorar índices em produção
- ⚡ Balancear leitura vs escrita
- 📈 Escalar queries para dados muito grandes

---

**Próxima fase**: Fase 9 - Transactions e Locks
