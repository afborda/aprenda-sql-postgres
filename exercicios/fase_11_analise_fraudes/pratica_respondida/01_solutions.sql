-- Fase 11: Análise de Fraudes - SOLUÇÕES e DESAFIOS

-- ✅ SOLUÇÕES (resumidas)

-- Exercício 1: Detecção por Valor - SOLUÇÃO
-- Usar multiplicador para flagar transações anormalmente altas

-- Exercício 2: Padrões Suspeitos - SOLUÇÃO
-- Múltiplas contas = posível fraude
-- Múltiplos estados = account takeover

-- Exercício 3: Z-Score - SOLUÇÃO
-- Score > 3 = muito anormal
-- Score > 2 = anormal
-- Usar para alertas automáticos

-- Exercício 4: Geográfico - SOLUÇÃO
-- Se mudança de estado < 2 horas = impossível (velocidade)

-- Exercício 5: Comportamento - SOLUÇÃO
-- Mudança > 300% de transações = anormal
-- Valores 2x maiores = comportamento diferente

-- Exercício 6: Scoring Completo - SOLUÇÃO
-- Combinar múltiplas sinalizações em um score
-- Score >= 70 = alto risco

-- =============================================================================
-- DESAFIOS: Fase 11 - Análise de Fraudes

-- DESAFIO 1: Criar Dashboard de Fraude em Tempo Real
-- Mostrar: Alerts hoje, % fraude, valor em risco, top 10 suspeitos

-- DESAFIO 2: Modelo Predictivo Simples
-- Machine learning básico: se teve fraude antes, probabilidade > do normal

-- DESAFIO 3: Detecção de Account Takeover
-- Comportamento muda drasticamente = conta hackeada

-- DESAFIO 4: Análise de Rede
-- Múltiplos usuários com padrão similar = fraude em rede

-- DESAFIO 5: RFM Segmentation para Fraude
-- Usuários churned com transação grande = fraude provável

-- DESAFIO 6: Sistema Completo
-- Integração de todas as técnicas
-- Scoring automático, alertas, caso de uso em produção
