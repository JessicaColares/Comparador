# RELATÓRIO COMPARATIVO: Métodos de Verificação

## Resumo dos 4 Métodos

| Método | Classificação | Tipo | Requer Execução? |
|--------|---------------|------|------------------|
| **CUnit** | **Dinâmico** | Testes Unitários | SIM |
| **Daikon** | **Dinâmico** | Detecção de Invariantes | SIM (instrumentada) |
| **Clang/LLVM** | **Estático** | Análise Estática | NÃO |
| **SPIN** | **Estático** | Model Checking | NÃO |

## Casos de Teste Utilizados (7 casos)

| # | Nome | a | b | Resultado | Descrição |
|---|------|---|---|-----------|-----------|
| 1 | Caso 1: Cadeia 112 | 5 | 6 | 1 | Caso normal com multiplas iteracoes |
| 2 | Caso 2: Cadeia 1111112 | 5 | 10 | 1 | Loop com muitas iteracoes |
| 3 | Caso 3: Cadeia 12 | 1 | 3 | 1 | Loop curto |
| 4 | Caso 4: Nao entra no loop | 10 | 5 | 0 | Condicao a <= b, nao entra no while |
| 5 | Caso 5: A igual a B | 5 | 5 | 0 | a == b, loop nao executa |
| 6 | Caso 6: Valores negativos | -5 | -1 | 1 | Valores negativos no loop |
| 7 | Caso 7: Cadeia complexa | 6 | 9 | 1 | Padrao complexo de execucao |

## Comparação Detalhada

### 1. CUNIT (Dinâmico)
**Como funciona**: Executa testes e verifica asserções durante execução
**Vantagens**:
- Verificação concreta
- Relatórios detalhados
- Fácil de implementar
**Limitações**:
- Só testa caminhos executados
- Não descobre propriedades automaticamente

### 2. DAIKON (Dinâmico)
**Como funciona**: Instrumenta código e analisa dados de execução
**Vantagens**:
- Descobre invariantes automaticamente
- Pode encontrar propriedades não documentadas
- Útil para compreensão de código
**Limitações**:
- Requer múltiplas execuções
- Pode gerar falsos positivos

### 3. CLANG/LLVM (Estático)
**Como funciona**: Analisa código sem executar
**Vantagens**:
- Detecta bugs antes da execução
- Cobre todos os caminhos
- Análise profunda de fluxo de dados
**Limitações**:
- Falsos positivos
- Não verifica comportamento dinâmico

### 4. SPIN (Estático)
**Como funciona**: Verificação formal por model checking
**Vantagens**:
- Verificação exaustiva
- Garante propriedades formais
- Encontra condições de corrida
**Limitações**:
- Complexo de modelar
- Estado de explosão (muitos estados)

## Conclusão

| Critério | Melhor Método | Por quê? |
|----------|---------------|----------|
| **Verificação de bugs** | Clang/LLVM | Detecta antes da execução |
| **Testes funcionais** | CUnit | Verificação direta e simples |
| **Descobrir propriedades** | Daikon | Encontra invariantes automaticamente |
| **Garantia formal** | SPIN | Verificação matemática |
| **Facilidade de uso** | CUnit | Framework simples e direto |

**Recomendação**: Use múltiplos métodos complementares:
1. Clang/LLVM para análise estática inicial
2. CUnit para testes funcionais
3. Daikon para entender propriedades do código
4. SPIN para verificação crítica
