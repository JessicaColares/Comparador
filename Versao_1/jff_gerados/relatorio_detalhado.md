# Relatório Detalhado de Autômatos Gerados

## Sumário
- [Complexidade Ciclomática](#complexidade-ciclomática)
- [Lista de Autômatos](#lista-de-autômatos)
- [Como Visualizar no JFLAP](#como-visualizar-no-jflap)

## Complexidade Ciclomática

A complexidade ciclomática mede o número de caminhos linearmente independentes em um programa. 
É calculada como: M = E - N + 2P, onde:
- E = número de arestas (fluxos de controle)
- N = número de nós (instruções)
- P = número de componentes conectados

### Classificação:
- **1-5**: Baixa complexidade (bom)
- **6-10**: Média complexidade (aceitável)
- **11-15**: Alta complexidade (precisa refatorar)
- **> 15**: Muito alta complexidade (urgente refatorar)

## Lista de Autômatos Gerados

- **Autômato 10**: automato_10.jff
- **Autômato 11**: automato_11.jff
- **Autômato 12**: automato_12.jff
- **Autômato 13**: automato_13.jff
- **Autômato 14**: automato_14.jff
- **Autômato 1**: automato_1.jff
- **Autômato 2**: automato_2.jff
- **Autômato 3**: automato_3.jff
- **Autômato 4**: automato_4.jff
- **Autômato 5**: automato_5.jff
- **Autômato 6**: automato_6.jff
- **Autômato 7**: automato_7.jff
- **Autômato 8**: automato_8.jff
- **Autômato 9**: automato_9.jff

## Como Visualizar no JFLAP

1. Baixe o JFLAP em: https://www.jflap.org/
2. Abra o JFLAP
3. Vá em File → Open
4. Selecione o arquivo .jff desejado
5. O autômato será exibido visualmente

### Funcionalidades do JFLAP:
- Visualização gráfica do autômato
- Simulação de entrada
- Teste de aceitação
- Conversão entre tipos de autômatos

