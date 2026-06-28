# Relatório de Análise - Autômato 3

## Dados Gerais
- **Arquivo:** executar3.c
- **Data:** dom. 28 jun 2026 18:02:41 -04

## Complexidade Ciclomática
- **Valor:** 5
- **Classificação:** Baixa - Bom

## Estrutura de Controle
- if: 2
- else: 2
- while: 1
- for: 0
- do-while: 0

## Casos de Teste Sugeridos
- **Caso 1:** a=10, b=5 → resultado esperado: 0
- **Caso 2:** a=5, b=10 → resultado esperado: 1
- **Caso 3:** a=10, b=5 → resultado esperado: 0
- **Caso 4:** a=5, b=10 → resultado esperado: 1
- **Caso 5:** a=3, b=10 → resultado esperado: 1

## Grafo de Fluxo
- Imagem: `grafos_gerados/grafo_3.png`

## JFLAP
- Arquivo: `jff_gerados/automato_3.jff`
- **Os símbolos nas transições mostram os valores de teste**
- Para testar caminhos no JFLAP:
  1. Abra o arquivo .jff no JFLAP
  2. Use "Input → Multiple Run" ou "Input → Step"
  3. Digite os valores mostrados nas transições
  4. Veja se o autômato aceita ou rejeita

## Resumo
Complexidade 5 - Baixa - Bom
