# Relatório de Análise - Autômato 14

## Dados Gerais
- **Arquivo:** executar14.c
- **Data:** dom. 28 jun 2026 17:45:36 -04

## Estrutura de Controle
- if: 3
- else: 1
- else if: 0
- while: 1
- for: 0
- do-while: 1
- switch: 0
- case: 0
- return: 2

## Complexidade Ciclomática
- **Valor:** 6
- **Classificação:** Média - Aceitável
- **Recomendação:** Pode precisar de refatoração futura

## Caminhos Independentes
Total de caminhos: 6

### Casos de Teste Sugeridos
- **Caso 1:** if falso (não entra)
- **Caso 2:** if 1 verdadeiro
- **Caso 3:** if 2 verdadeiro
- **Caso 4:** if 3 verdadeiro
- **Caso 5:** Loop 1 - não executa
- **Caso 6:** Loop 1 - executa
- **Caso 7:** Loop 2 - não executa
- **Caso 8:** Loop 2 - executa

## Grafo de Fluxo
- Arquivo DOT: `grafos_gerados/grafo_14.dot`
- Imagem: `grafos_gerados/grafo_14.png`

## Resumo
A complexidade ciclomática de **6** indica que o código possui **6** caminhos independentes.
Para alcançar 100% de cobertura, são necessários pelo menos **6** casos de teste.

**Pode precisar de refatoração futura**
