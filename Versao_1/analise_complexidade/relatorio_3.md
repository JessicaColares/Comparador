# Relatório de Análise - Autômato 3

## Dados Gerais
- **Arquivo:** executar3.c
- **Data:** dom. 28 jun 2026 17:45:36 -04

## Estrutura de Controle
- if: 2
- else: 2
- else if: 1
- while: 1
- for: 0
- do-while: 0
- switch: 0
- case: 0
- return: 1

## Complexidade Ciclomática
- **Valor:** 5
- **Classificação:** Baixa - Bom
- **Recomendação:** Código simples e fácil de testar

## Caminhos Independentes
Total de caminhos: 5

### Casos de Teste Sugeridos
- **Caso 1:** if falso (não entra)
- **Caso 2:** if 1 verdadeiro
- **Caso 3:** if 2 verdadeiro
- **Caso 4:** else if 1 verdadeiro
- **Caso 5:** Loop 1 - não executa
- **Caso 6:** Loop 1 - executa

## Grafo de Fluxo
- Arquivo DOT: `grafos_gerados/grafo_3.dot`
- Imagem: `grafos_gerados/grafo_3.png`

## Resumo
A complexidade ciclomática de **5** indica que o código possui **5** caminhos independentes.
Para alcançar 100% de cobertura, são necessários pelo menos **5** casos de teste.

**Código simples e fácil de testar**
