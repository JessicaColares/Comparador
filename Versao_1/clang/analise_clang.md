# Análise Estática com Clang/LLVM

## Método: ANÁLISE ESTÁTICA
**Classificação**: Verificação sem execução do código

## Como Usar o Clang Static Analyzer
```bash
# 1. Analisar o código fonte
clang --analyze -Xanalyzer -analyzer-checker=core ../Manual/executar.c

# 2. Verificar vulnerabilidades
clang --analyze -Xanalyzer -analyzer-checker=security ../Manual/executar.c

# 3. Verificar lógica do programa
clang --analyze -Xanalyzer -analyzer-checker=unix ../Manual/executar.c
```

## Casos de Teste para Análise
| Caso | Valores | Comportamento Esperado |
|------|---------|------------------------|
| Caso 1: Cadeia 112 | a=5, b=6 | resultado=1 |
| Caso 2: Cadeia 1111112 | a=5, b=10 | resultado=1 |
| Caso 3: Cadeia 12 | a=1, b=3 | resultado=1 |
| Caso 4: Nao entra no loop | a=10, b=5 | resultado=0 |
| Caso 5: A igual a B | a=5, b=5 | resultado=0 |
| Caso 6: Valores negativos | a=-5, b=-1 | resultado=1 |
| Caso 7: Cadeia complexa | a=6, b=9 | resultado=1 |

## O que Clang pode detectar (estaticamente):
1. **Divisão por zero**: Verifica se b pode ser 0
2. **Buffer overflow**: Analisa limites de arrays
3. **Vazamento de memória**: Verifica alloc/free
4. **Condições sempre verdadeiras/falsas**: Analisa lógica
5. **Dead code**: Código inalcançável

## Exemplo de Análise Manual (simulada):
```c
// Função 'executar' - Análise estática manual
int executar(int a, int b) {
    // POSSÍVEL ISSUE: Se b == 0, divisão por zero
    // ANÁLISE: b vem de parâmetro, precisa verificação
    
    // LOOP: while (a > b)
    // ANÁLISE: Se a <= b, loop não executa (resultado = 0)
    // ANÁLISE: Loop pode ser infinito se a nunca <= b
}
```

## Vantagens da Análise Estática (Clang):
- Detecta bugs antes da execução
- Cobre TODOS os caminhos do código
- Não requer execução do programa
- Pode encontrar bugs complexos

## Limitações:
- Pode gerar falsos positivos
- Não verifica comportamento dinâmico
- Não executa lógica complexa
