# Relatório de Análise - Autômato 4

## Dados Gerais
- **Arquivo:** executar4.c
- **Data:** dom. 28 jun 2026 17:45:36 -04

## Estrutura de Controle
- if: 4
- else: 1
- else if: 1
- while: 1
- for: 0
- do-while: 0
- switch: 0
- case: 0
- return: 1

## Complexidade Ciclomática
- **Valor:** 7
- **Classificação:** Média - Aceitável
- **Recomendação:** Pode precisar de refatoração futura

## Caminhos Independentes
Total de caminhos: 7

### Casos de Teste Sugeridos
- **Caso 1:** if falso (não entra)
- **Caso 2:** if 1 verdadeiro
- **Caso 3:** if 2 verdadeiro
- **Caso 4:** if 3 verdadeiro
- **Caso 5:** if 4 verdadeiro
- **Caso 6:** else if 1 verdadeiro
- **Caso 7:** Loop 1 - não executa
- **Caso 8:** Loop 1 - executa

## Grafo de Fluxo
- Arquivo DOT: `grafos_gerados/grafo_4.dot`
- Imagem: `grafos_gerados/grafo_4.png`

## Resumo
A complexidade ciclomática de **7** indica que o código possui **7** caminhos independentes.
Para alcançar 100% de cobertura, são necessários pelo menos **7** casos de teste.

**Pode precisar de refatoração futura**
