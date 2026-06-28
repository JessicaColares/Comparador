#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/stat.h>

// =============================================
// CONFIGURAÇÃO DE CASOS DE TESTE
// =============================================
// Altere esta constante para adicionar/remover casos de teste
#define NUM_CASOS_TESTE 14

typedef struct {
    char nome[50];
    char cadeia[30];
    int a;
    int b;
    int resultado_esperado;
    char descricao[100];
} CasoTeste;

void criar_diretorio_se_nao_existir(const char *path) {
    struct stat st = {0};
    if (stat(path, &st) == -1) {
        mkdir(path, 0700);
    }
}

// =============================================
// CASOS DE TESTE (Configure aqui!)
// =============================================
// Adicione ou remova casos conforme desejar
// Basta ajustar NUM_CASOS_TESTE e adicionar/remover linhas

void inicializar_casos_teste(CasoTeste *casos, int *num_casos) {
    *num_casos = NUM_CASOS_TESTE;
    
    // Caso 1: Normal
    strcpy(casos[0].nome, "Caso 1: Cadeia 112");
    strcpy(casos[0].cadeia, "112");
    casos[0].a = 5;
    casos[0].b = 6;
    casos[0].resultado_esperado = 1;
    strcpy(casos[0].descricao, "Caso normal com multiplas iteracoes");
    
    // Caso 2: Loop longo
    strcpy(casos[1].nome, "Caso 2: Cadeia 1111112");
    strcpy(casos[1].cadeia, "1111112");
    casos[1].a = 5;
    casos[1].b = 10;
    casos[1].resultado_esperado = 1;
    strcpy(casos[1].descricao, "Loop com muitas iteracoes");
    
    // Caso 3: Loop curto
    strcpy(casos[2].nome, "Caso 3: Cadeia 12");
    strcpy(casos[2].cadeia, "12");
    casos[2].a = 1;
    casos[2].b = 3;
    casos[2].resultado_esperado = 1;
    strcpy(casos[2].descricao, "Loop curto");
    
    // Caso 4: Não entra no loop (a <= b)
    strcpy(casos[3].nome, "Caso 4: Nao entra no loop");
    strcpy(casos[3].cadeia, "0");
    casos[3].a = 10;
    casos[3].b = 5;
    casos[3].resultado_esperado = 0;
    strcpy(casos[3].descricao, "Condicao a <= b, nao entra no while");
    
    // Caso 5: a == b
    strcpy(casos[4].nome, "Caso 5: A igual a B");
    strcpy(casos[4].cadeia, "a_igual_b");
    casos[4].a = 5;
    casos[4].b = 5;
    casos[4].resultado_esperado = 0;
    strcpy(casos[4].descricao, "a == b, loop nao executa");
    
    // Caso 6: Valores negativos
    strcpy(casos[5].nome, "Caso 6: Valores negativos");
    strcpy(casos[5].cadeia, "negativos");
    casos[5].a = -5;
    casos[5].b = -1;
    casos[5].resultado_esperado = 1;
    strcpy(casos[5].descricao, "Valores negativos no loop");
    
    // Caso 7: Padrão complexo
    strcpy(casos[6].nome, "Caso 7: Cadeia complexa");
    strcpy(casos[6].cadeia, "11121112");
    casos[6].a = 6;
    casos[6].b = 9;
    casos[6].resultado_esperado = 1;
    strcpy(casos[6].descricao, "Padrao complexo de execucao");
    
    // =============================================
    // NOVOS CASOS DE TESTE (8 a 14)
    // =============================================
    
    // Caso 8: Valores positivos grandes
    strcpy(casos[7].nome, "Caso 8: Valores positivos grandes");
    strcpy(casos[7].cadeia, "grandes");
    casos[7].a = 100;
    casos[7].b = 200;
    casos[7].resultado_esperado = 1;
    strcpy(casos[7].descricao, "Teste com valores grandes positivos");
    
    // Caso 9: a muito menor que b
    strcpy(casos[8].nome, "Caso 9: a muito menor que b");
    strcpy(casos[8].cadeia, "muito_menor");
    casos[8].a = 1;
    casos[8].b = 1000;
    casos[8].resultado_esperado = 1;
    strcpy(casos[8].descricao, "a muito menor que b, muitas iteracoes");
    
    // Caso 10: a ligeiramente menor que b
    strcpy(casos[9].nome, "Caso 10: a ligeiramente menor que b");
    strcpy(casos[9].cadeia, "ligeiramente_menor");
    casos[9].a = 5;
    casos[9].b = 6;
    casos[9].resultado_esperado = 1;
    strcpy(casos[9].descricao, "a ligeiramente menor que b, poucas iteracoes");
    
    // Caso 11: a negativo, b positivo
    strcpy(casos[10].nome, "Caso 11: a negativo, b positivo");
    strcpy(casos[10].cadeia, "negativo_positivo");
    casos[10].a = -10;
    casos[10].b = 5;
    casos[10].resultado_esperado = 1;
    strcpy(casos[10].descricao, "a negativo e b positivo");
    
    // Caso 12: a positivo, b negativo (não entra)
    strcpy(casos[11].nome, "Caso 12: a positivo, b negativo");
    strcpy(casos[11].cadeia, "positivo_negativo");
    casos[11].a = 10;
    casos[11].b = -5;
    casos[11].resultado_esperado = 0;
    strcpy(casos[11].descricao, "a positivo, b negativo, nao entra no loop");
    
    // Caso 13: ambos zeros
    strcpy(casos[12].nome, "Caso 13: a e b iguais a zero");
    strcpy(casos[12].cadeia, "zeros");
    casos[12].a = 0;
    casos[12].b = 0;
    casos[12].resultado_esperado = 0;
    strcpy(casos[12].descricao, "a == b == 0, loop nao executa");
    
    // Caso 14: a negativo maior que b negativo
    strcpy(casos[13].nome, "Caso 14: a negativo maior que b negativo");
    strcpy(casos[13].cadeia, "negativos_decrescentes");
    casos[13].a = -1;
    casos[13].b = -10;
    casos[13].resultado_esperado = 0;
    strcpy(casos[13].descricao, "a > b, nao entra no loop");
}

// =============================================
// 1. GERADOR PARA CUNIT (DINÂMICO)
// =============================================

void gerar_testes_cunit(const char *dir, CasoTeste *casos, int num_casos) {
    char caminho[100];
    sprintf(caminho, "%s/test_cunit.c", dir);
    FILE *f = fopen(caminho, "w");
    
    fprintf(f, "// =============================================\n");
    fprintf(f, "// TESTES CUNIT (ANÁLISE DINÂMICA)\n");
    fprintf(f, "// Total de testes: %d\n", num_casos);
    fprintf(f, "// =============================================\n\n");
    
    fprintf(f, "#include <stdio.h>\n");
    fprintf(f, "#include <CUnit/CUnit.h>\n");
    fprintf(f, "#include <CUnit/Basic.h>\n");
    fprintf(f, "#include \"../Manual/executar.h\"\n\n");
    
    // Funções de teste
    for (int i = 0; i < num_casos; i++) {
        fprintf(f, "void test_caso_%d(void) {\n", i+1);
        fprintf(f, "    printf(\"CUnit - %s\\n\");\n", casos[i].nome);
        fprintf(f, "    printf(\"  a=%%d, b=%%d, esperado=%%d\\n\", %d, %d, %d);\n",
                casos[i].a, casos[i].b, casos[i].resultado_esperado);
        fprintf(f, "    CU_ASSERT_EQUAL(executar(%d, %d), %d);\n",
                casos[i].a, casos[i].b, casos[i].resultado_esperado);
        fprintf(f, "}\n\n");
    }
    
    // Main
    fprintf(f, "int main() {\n");
    fprintf(f, "    printf(\"\\n=== CUNIT (ANALISE DINAMICA) ===\\n\");\n");
    fprintf(f, "    printf(\"Framework de testes unitarios\\n\\n\");\n");
    
    fprintf(f, "    if (CUE_SUCCESS != CU_initialize_registry())\n");
    fprintf(f, "        return CU_get_error();\n\n");
    
    fprintf(f, "    CU_pSuite suite = CU_add_suite(\"Testes_AF\", NULL, NULL);\n");
    fprintf(f, "    if (NULL == suite) {\n");
    fprintf(f, "        CU_cleanup_registry();\n");
    fprintf(f, "        return CU_get_error();\n");
    fprintf(f, "    }\n\n");
    
    fprintf(f, "    // Adicionando %d testes\\n", num_casos);
    for (int i = 0; i < num_casos; i++) {
        fprintf(f, "    CU_add_test(suite, \"%s\", test_caso_%d);\n",
                casos[i].nome, i+1);
    }
    
    fprintf(f, "\n    CU_basic_set_mode(CU_BRM_VERBOSE);\n");
    fprintf(f, "    CU_basic_run_tests();\n");
    fprintf(f, "    int falhas = CU_get_number_of_failures();\n");
    fprintf(f, "    CU_cleanup_registry();\n");
    fprintf(f, "    \n");
    fprintf(f, "    printf(\"\\nResumo CUnit:\\n\");\n");
    fprintf(f, "    printf(\"  - %d testes executados\\n\", %d);\n", num_casos, num_casos);
    fprintf(f, "    printf(\"  - %%d falhas\\n\", falhas);\n");
    fprintf(f, "    printf(\"  - Verificacao durante execucao\\n\");\n");
    fprintf(f, "    printf(\"  - Classificacao: METODO DINAMICO\\n\");\n");
    fprintf(f, "    \n");
    fprintf(f, "    return falhas;\n");
    fprintf(f, "}\n");
    
    fclose(f);
}

// =============================================
// 2. GERADOR PARA DAIKON (DINÂMICO)
// =============================================

void gerar_testes_daikon(const char *dir, CasoTeste *casos, int num_casos) {
    char caminho[100];
    sprintf(caminho, "%s/test_daikon.c", dir);
    FILE *f = fopen(caminho, "w");
    
    fprintf(f, "// =============================================\n");
    fprintf(f, "// TESTES DAIKON (DINÂMICO - DETECÇÃO DE INVARIANTES)\n");
    fprintf(f, "// Total de testes: %d\n", num_casos);
    fprintf(f, "// =============================================\n\n");
    
    fprintf(f, "#include <stdio.h>\n");
    fprintf(f, "#include \"../Manual/executar.h\"\n\n");
    
    // Função auxiliar para "instrumentação manual"
    fprintf(f, "// Simulacao de instrumentacao para Daikon\n");
    fprintf(f, "void daikon_enter(const char *fn, int a, int b) {\n");
    fprintf(f, "    printf(\"DAIKON_ENTER %%s: a=%%d, b=%%d\\n\", fn, a, b);\n");
    fprintf(f, "}\n\n");
    
    fprintf(f, "void daikon_exit(const char *fn, int result) {\n");
    fprintf(f, "    printf(\"DAIKON_EXIT %%s: resultado=%%d\\n\", fn, result);\n");
    fprintf(f, "}\n\n");
    
    // Funções de teste
    for (int i = 0; i < num_casos; i++) {
        fprintf(f, "void test_daikon_caso_%d() {\n", i+1);
        fprintf(f, "    int a = %d;\n", casos[i].a);
        fprintf(f, "    int b = %d;\n", casos[i].b);
        fprintf(f, "    \n");
        fprintf(f, "    printf(\"\\nDaikon - %%s\\n\", \"%s\");\n", casos[i].nome);
        fprintf(f, "    \n");
        fprintf(f, "    // Ponto de instrumentacao (entrada)\n");
        fprintf(f, "    daikon_enter(\"executar\", a, b);\n");
        fprintf(f, "    \n");
        fprintf(f, "    // Execucao real\n");
        fprintf(f, "    int resultado = executar(a, b);\n");
        fprintf(f, "    \n");
        fprintf(f, "    // Ponto de instrumentacao (saida)\n");
        fprintf(f, "    daikon_exit(\"executar\", resultado);\n");
        fprintf(f, "    \n");
        fprintf(f, "    // Registro para analise posterior\n");
        fprintf(f, "    printf(\"VALORES: a=%%d, b=%%d, resultado=%%d\\n\", a, b, resultado);\n");
        fprintf(f, "}\n\n");
    }
    
    // Main
    fprintf(f, "int main() {\n");
    fprintf(f, "    printf(\"\\n=== DAIKON (ANALISE DINAMICA) ===\\n\");\n");
    fprintf(f, "    printf(\"Detector de invariantes atraves de execucao instrumentada\\n\\n\");\n");
    fprintf(f, "    printf(\"Executando %d casos de teste para coleta de dados...\\n\\n\", %d);\n", num_casos, num_casos);
    
    for (int i = 0; i < num_casos; i++) {
        fprintf(f, "    test_daikon_caso_%d();\n", i+1);
    }
    
    fprintf(f, "\n    printf(\"\\nColeta de dados concluida!\\n\");\n");
    fprintf(f, "    printf(\"\\nResumo Daikon:\\n\");\n");
    fprintf(f, "    printf(\"  - %d execucoes instrumentadas\\n\", %d);\n", num_casos, num_casos);
    fprintf(f, "    printf(\"  - Valores capturados em pontos do programa\\n\");\n");
    fprintf(f, "    printf(\"  - Dados podem ser analisados para encontrar invariantes\\n\");\n");
    fprintf(f, "    printf(\"  - Exemplos de invariantes que poderiam ser detectados:\\n\");\n");
    fprintf(f, "    printf(\"     1. resultado sempre e 0 ou 1\\n\");\n");
    fprintf(f, "    printf(\"     2. se a <= b, resultado = 0\\n\");\n");
    fprintf(f, "    printf(\"     3. durante loop: a sempre decrementa\\n\");\n");
    fprintf(f, "    printf(\"  - Classificacao: METODO DINAMICO\\n\");\n");
    fprintf(f, "    \n");
    fprintf(f, "    printf(\"\\nPara uso real do Daikon:\\n\");\n");
    fprintf(f, "    printf(\"  1. Compile com instrumentacao: java daikon.DynComp test_daikon\\n\");\n");
    fprintf(f, "    printf(\"  2. Execute: java daikon.Chicory --dtrace-file=test.dtrace ./test_daikon\\n\");\n");
    fprintf(f, "    printf(\"  3. Analise: java daikon.Daikon test.dtrace\\n\");\n");
    fprintf(f, "    \n");
    fprintf(f, "    return 0;\n");
    fprintf(f, "}\n");
    
    fclose(f);
}

// =============================================
// 3. GERADOR PARA CLANG/LLVM (ESTÁTICO)
// =============================================

void gerar_analise_clang(const char *dir, CasoTeste *casos, int num_casos) {
    char caminho[100];
    sprintf(caminho, "%s/analise_clang.md", dir);
    FILE *f = fopen(caminho, "w");
    
    fprintf(f, "# Análise Estática com Clang/LLVM\n\n");
    fprintf(f, "## Método: ANÁLISE ESTÁTICA\n");
    fprintf(f, "**Classificação**: Verificação sem execução do código\n\n");
    
    fprintf(f, "## Como Usar o Clang Static Analyzer\n");
    fprintf(f, "```bash\n");
    fprintf(f, "# 1. Analisar o código fonte\n");
    fprintf(f, "clang --analyze -Xanalyzer -analyzer-checker=core ../Manual/executar.c\n\n");
    
    fprintf(f, "# 2. Verificar vulnerabilidades\n");
    fprintf(f, "clang --analyze -Xanalyzer -analyzer-checker=security ../Manual/executar.c\n\n");
    
    fprintf(f, "# 3. Verificar lógica do programa\n");
    fprintf(f, "clang --analyze -Xanalyzer -analyzer-checker=unix ../Manual/executar.c\n");
    fprintf(f, "```\n\n");
    
    fprintf(f, "## Casos de Teste para Análise (%d casos)\n\n", num_casos);
    fprintf(f, "| Caso | Valores | Comportamento Esperado |\n");
    fprintf(f, "|------|---------|------------------------|\n");
    
    for (int i = 0; i < num_casos; i++) {
        fprintf(f, "| %s | a=%d, b=%d | resultado=%d |\n",
                casos[i].nome, casos[i].a, casos[i].b, casos[i].resultado_esperado);
    }
    
    fprintf(f, "\n## O que Clang pode detectar (estaticamente):\n");
    fprintf(f, "1. **Divisão por zero**: Verifica se b pode ser 0\n");
    fprintf(f, "2. **Buffer overflow**: Analisa limites de arrays\n");
    fprintf(f, "3. **Vazamento de memória**: Verifica alloc/free\n");
    fprintf(f, "4. **Condições sempre verdadeiras/falsas**: Analisa lógica\n");
    fprintf(f, "5. **Dead code**: Código inalcançável\n\n");
    
    fprintf(f, "## Exemplo de Análise Manual (simulada):\n");
    fprintf(f, "```c\n");
    fprintf(f, "// Função 'executar' - Análise estática manual\n");
    fprintf(f, "int executar(int a, int b) {\n");
    fprintf(f, "    // POSSÍVEL ISSUE: Se b == 0, divisão por zero\n");
    fprintf(f, "    // ANÁLISE: b vem de parâmetro, precisa verificação\n");
    fprintf(f, "    \n");
    fprintf(f, "    // LOOP: while (a > b)\n");
    fprintf(f, "    // ANÁLISE: Se a <= b, loop não executa (resultado = 0)\n");
    fprintf(f, "    // ANÁLISE: Loop pode ser infinito se a nunca <= b\n");
    fprintf(f, "}\n");
    fprintf(f, "```\n\n");
    
    fprintf(f, "## Vantagens da Análise Estática (Clang):\n");
    fprintf(f, "- Detecta bugs antes da execução\n");
    fprintf(f, "- Cobre TODOS os caminhos do código\n");
    fprintf(f, "- Não requer execução do programa\n");
    fprintf(f, "- Pode encontrar bugs complexos\n\n");
    
    fprintf(f, "## Limitações:\n");
    fprintf(f, "- Pode gerar falsos positivos\n");
    fprintf(f, "- Não verifica comportamento dinâmico\n");
    fprintf(f, "- Não executa lógica complexa\n");
    
    fclose(f);
}

// =============================================
// 4. GERADOR PARA SPIN MODEL CHECKER (ESTÁTICO)
// =============================================

void gerar_modelo_spin(const char *dir, CasoTeste *casos, int num_casos) {
    char caminho[100];
    sprintf(caminho, "%s/modelo_spin.pml", dir);
    FILE *f = fopen(caminho, "w");
    
    fprintf(f, "/*\n");
    fprintf(f, " * Modelo Promela para SPIN Model Checker\n");
    fprintf(f, " * Verificação Formal - ANÁLISE ESTÁTICA\n");
    fprintf(f, " * Total de casos: %d\n", num_casos);
    fprintf(f, " * Modela a função 'executar' como processo\n");
    fprintf(f, " */\n\n");
    
    fprintf(f, "#define MAX_ITER 20\n\n");
    
    fprintf(f, "// Protótipo da função executar\n");
    fprintf(f, "int executar(int a, int b) {\n");
    fprintf(f, "    int resultado = 0;\n");
    fprintf(f, "    \n");
    fprintf(f, "    // Modelando o while (a > b)\n");
    fprintf(f, "    do\n");
    fprintf(f, "    :: (a > b) -> \n");
    fprintf(f, "        if\n");
    fprintf(f, "        :: (a %% 2 == 0) -> a = a / 2;\n");
    fprintf(f, "        :: else -> a = 3*a + 1;\n");
    fprintf(f, "        fi;\n");
    fprintf(f, "        resultado = 1;\n");
    fprintf(f, "    :: else -> break;\n");
    fprintf(f, "    od;\n");
    fprintf(f, "    \n");
    fprintf(f, "    return resultado;\n");
    fprintf(f, "}\n\n");
    
    fprintf(f, "// Processo de teste\n");
    fprintf(f, "proctype TestarCasos() {\n");
    fprintf(f, "    printf(\"=== SPIN MODEL CHECKER (ANALISE ESTATICA) ===\\n\");\n");
    fprintf(f, "    printf(\"Verificacao formal por model checking\\n\");\n");
    fprintf(f, "    printf(\"Total de casos: %d\\n\\n\", %d);\n", num_casos, num_casos);
    fprintf(f, "    \n");
    
    for (int i = 0; i < num_casos; i++) {
        fprintf(f, "    // %s\n", casos[i].nome);
        fprintf(f, "    printf(\"Teste %%d: a=%%d, b=%%d\\n\", %d, %d, %d);\n",
                i+1, casos[i].a, casos[i].b);
        fprintf(f, "    int resultado = executar(%d, %d);\n",
                casos[i].a, casos[i].b);
        fprintf(f, "    assert(resultado == %d);\n", casos[i].resultado_esperado);
        fprintf(f, "    printf(\"  Resultado: %%d (esperado: %%d)\\n\\n\", resultado, %d);\n",
                casos[i].resultado_esperado);
        fprintf(f, "    \n");
    }
    
    fprintf(f, "    printf(\"\\nVerificacao concluida!\\n\");\n");
    fprintf(f, "    printf(\"\\nResumo SPIN:\\n\");\n");
    fprintf(f, "    printf(\"  - %d propriedades verificadas\\n\", %d);\n", num_casos, num_casos);
    fprintf(f, "    printf(\"  - Model checking exaustivo\\n\");\n");
    fprintf(f, "    printf(\"  - Verificacao formal de propriedades\\n\");\n");
    fprintf(f, "    printf(\"  - Classificacao: METODO ESTATICO\\n\");\n");
    fprintf(f, "}\n\n");
    
    fprintf(f, "// Processo inicial\n");
    fprintf(f, "init {\n");
    fprintf(f, "    run TestarCasos();\n");
    fprintf(f, "}\n\n");
    
    fprintf(f, "// PROPRIEDADES A VERIFICAR (LTL - Linear Temporal Logic)\n");
    fprintf(f, "// 1. Nunca divisão por zero\n");
    fprintf(f, "ltl nunca_divisao_zero { [] (b != 0) }\n\n");
    
    fprintf(f, "// 2. Sempre termina (não fica em loop infinito)\n");
    fprintf(f, "ltl sempre_termina { <> (a <= b) }\n\n");
    
    fprintf(f, "// 3. Resultado é sempre 0 ou 1\n");
    fprintf(f, "ltl resultado_valido { [] (resultado == 0 || resultado == 1) }\n\n");
    
    fprintf(f, "/*\n");
    fprintf(f, " * Para executar com SPIN:\n");
    fprintf(f, " * 1. spin -a modelo_spin.pml\n");
    fprintf(f, " * 2. gcc pan.c -o pan\n");
    fprintf(f, " * 3. ./pan -a (verifica todas as propriedades)\n");
    fprintf(f, " */\n");
    
    fclose(f);
    
    // Gerar também um script de execução
    sprintf(caminho, "%s/executar_spin.sh", dir);
    f = fopen(caminho, "w");
    
    fprintf(f, "#!/bin/bash\n");
    fprintf(f, "echo \"Executando SPIN Model Checker...\"\n");
    fprintf(f, "echo \"================================\"\n\n");
    
    fprintf(f, "echo \"1. Gerando verificador...\"\n");
    fprintf(f, "spin -a modelo_spin.pml\n\n");
    
    fprintf(f, "echo \"2. Compilando verificador...\"\n");
    fprintf(f, "gcc pan.c -o pan\n\n");
    
    fprintf(f, "echo \"3. Executando verificação...\"\n");
    fprintf(f, "echo \"\\n=== RESULTADOS SPIN ===\"\n");
    fprintf(f, "./pan -a | grep -A 20 \"errors:\"\n\n");
    
    fprintf(f, "echo \"\\n4. Resumo:\"\n");
    fprintf(f, "echo \"- Método: Verificação Formal (Estático)\"\n");
    fprintf(f, "echo \"- Técnica: Model Checking\"\n");
    fprintf(f, "echo \"- Vantagem: Verificação exaustiva de propriedades\"\n");
    
    fclose(f);
    chmod(caminho, 0755);
}

// =============================================
// GERADOR DE RELATÓRIO COMPARATIVO
// =============================================

void gerar_relatorio_comparativo(const char *dir, CasoTeste *casos, int num_casos) {
    char caminho[100];
    sprintf(caminho, "%s/RELATORIO_COMPARATIVO.md", dir);
    FILE *f = fopen(caminho, "w");
    
    fprintf(f, "# RELATÓRIO COMPARATIVO: Métodos de Verificação\n\n");
    fprintf(f, "**Data:** %s\n\n", __DATE__);
    fprintf(f, "**Total de casos de teste:** %d\n\n", num_casos);
    
    fprintf(f, "## Resumo dos 4 Métodos\n\n");
    
    fprintf(f, "| Método | Classificação | Tipo | Requer Execução? |\n");
    fprintf(f, "|--------|---------------|------|------------------|\n");
    fprintf(f, "| **CUnit** | **Dinâmico** | Testes Unitários | SIM |\n");
    fprintf(f, "| **Daikon** | **Dinâmico** | Detecção de Invariantes | SIM (instrumentada) |\n");
    fprintf(f, "| **Clang/LLVM** | **Estático** | Análise Estática | NÃO |\n");
    fprintf(f, "| **SPIN** | **Estático** | Model Checking | NÃO |\n\n");
    
    fprintf(f, "## Casos de Teste Utilizados (%d casos)\n\n", num_casos);
    fprintf(f, "| # | Nome | a | b | Resultado | Descrição |\n");
    fprintf(f, "|---|------|---|---|-----------|-----------|\n");
    
    for (int i = 0; i < num_casos; i++) {
        fprintf(f, "| %d | %s | %d | %d | %d | %s |\n",
                i+1, casos[i].nome, casos[i].a, casos[i].b,
                casos[i].resultado_esperado, casos[i].descricao);
    }
    
    fprintf(f, "\n## Comparação Detalhada\n\n");
    
    fprintf(f, "### 1. CUNIT (Dinâmico)\n");
    fprintf(f, "**Como funciona**: Executa testes e verifica asserções durante execução\n");
    fprintf(f, "**Vantagens**:\n");
    fprintf(f, "- Verificação concreta\n");
    fprintf(f, "- Relatórios detalhados\n");
    fprintf(f, "- Fácil de implementar\n");
    fprintf(f, "**Limitações**:\n");
    fprintf(f, "- Só testa caminhos executados\n");
    fprintf(f, "- Não descobre propriedades automaticamente\n\n");
    
    fprintf(f, "### 2. DAIKON (Dinâmico)\n");
    fprintf(f, "**Como funciona**: Instrumenta código e analisa dados de execução\n");
    fprintf(f, "**Vantagens**:\n");
    fprintf(f, "- Descobre invariantes automaticamente\n");
    fprintf(f, "- Pode encontrar propriedades não documentadas\n");
    fprintf(f, "- Útil para compreensão de código\n");
    fprintf(f, "**Limitações**:\n");
    fprintf(f, "- Requer múltiplas execuções\n");
    fprintf(f, "- Pode gerar falsos positivos\n\n");
    
    fprintf(f, "### 3. CLANG/LLVM (Estático)\n");
    fprintf(f, "**Como funciona**: Analisa código sem executar\n");
    fprintf(f, "**Vantagens**:\n");
    fprintf(f, "- Detecta bugs antes da execução\n");
    fprintf(f, "- Cobre todos os caminhos\n");
    fprintf(f, "- Análise profunda de fluxo de dados\n");
    fprintf(f, "**Limitações**:\n");
    fprintf(f, "- Falsos positivos\n");
    fprintf(f, "- Não verifica comportamento dinâmico\n\n");
    
    fprintf(f, "### 4. SPIN (Estático)\n");
    fprintf(f, "**Como funciona**: Verificação formal por model checking\n");
    fprintf(f, "**Vantagens**:\n");
    fprintf(f, "- Verificação exaustiva\n");
    fprintf(f, "- Garante propriedades formais\n");
    fprintf(f, "- Encontra condições de corrida\n");
    fprintf(f, "**Limitações**:\n");
    fprintf(f, "- Complexo de modelar\n");
    fprintf(f, "- Estado de explosão (muitos estados)\n\n");
    
    fprintf(f, "## Conclusão\n\n");
    fprintf(f, "| Critério | Melhor Método | Por quê? |\n");
    fprintf(f, "|----------|---------------|----------|\n");
    fprintf(f, "| **Verificação de bugs** | Clang/LLVM | Detecta antes da execução |\n");
    fprintf(f, "| **Testes funcionais** | CUnit | Verificação direta e simples |\n");
    fprintf(f, "| **Descobrir propriedades** | Daikon | Encontra invariantes automaticamente |\n");
    fprintf(f, "| **Garantia formal** | SPIN | Verificação matemática |\n");
    fprintf(f, "| **Facilidade de uso** | CUnit | Framework simples e direto |\n\n");
    
    fprintf(f, "**Recomendação**: Use múltiplos métodos complementares:\n");
    fprintf(f, "1. Clang/LLVM para análise estática inicial\n");
    fprintf(f, "2. CUnit para testes funcionais\n");
    fprintf(f, "3. Daikon para entender propriedades do código\n");
    fprintf(f, "4. SPIN para verificação crítica\n");
    
    fclose(f);
}

// =============================================
// MAIN - GERADOR COMPLETO
// =============================================

int main() {
    printf("===============================================\n");
    printf("  GERADOR COMPARATIVO - 4 MÉTODOS DE VERIFICAÇÃO\n");
    printf("===============================================\n\n");
    
    printf("MÉTODOS DINÂMICOS:\n");
    printf("  1. CUnit - Testes unitários\n");
    printf("  2. Daikon - Detecção de invariantes\n\n");
    
    printf("MÉTODOS ESTÁTICOS:\n");
    printf("  3. Clang/LLVM - Análise estática\n");
    printf("  4. SPIN - Model checking\n\n");
    
    // Criar diretórios
    criar_diretorio_se_nao_existir("cunit");
    criar_diretorio_se_nao_existir("daikon");
    criar_diretorio_se_nao_existir("clang");
    criar_diretorio_se_nao_existir("spin");
    criar_diretorio_se_nao_existir("relatorio");
    
    // Inicializar casos de teste (agora dinâmico!)
    CasoTeste casos[NUM_CASOS_TESTE];
    int num_casos;
    inicializar_casos_teste(casos, &num_casos);
    
    printf("Gerando arquivos...\n");
    printf("===================\n");
    printf("Total de casos de teste: %d\n\n", num_casos);
    
    // 1. Gerar CUnit
    printf("1. Gerando testes CUnit (dinâmico)...\n");
    gerar_testes_cunit("cunit", casos, num_casos);
    
    // 2. Gerar Daikon
    printf("2. Gerando testes Daikon (dinâmico)...\n");
    gerar_testes_daikon("daikon", casos, num_casos);
    
    // 3. Gerar Clang/LLVM
    printf("3. Gerando análise Clang/LLVM (estático)...\n");
    gerar_analise_clang("clang", casos, num_casos);
    
    // 4. Gerar SPIN
    printf("4. Gerando modelo SPIN (estático)...\n");
    gerar_modelo_spin("spin", casos, num_casos);
    
    // 5. Gerar relatório comparativo
    printf("5. Gerando relatório comparativo...\n");
    gerar_relatorio_comparativo("relatorio", casos, num_casos);
    
    // 6. Gerar script principal
    FILE *script = fopen("executar_comparativo.sh", "w");
    if (script) {
        fprintf(script, "#!/bin/bash\n");
        fprintf(script, "echo \"========================================\"\n");
        fprintf(script, "echo \"  EXECUTANDO COMPARATIVO COMPLETO\"\n");
        fprintf(script, "echo \"========================================\"\n\n");
        
        fprintf(script, "echo \"\\n1. COMPILANDO CUNIT...\"\n");
        fprintf(script, "cd cunit\n");
        fprintf(script, "gcc test_cunit.c ../Manual/executar.c -lcunit -o test_cunit\n");
        fprintf(script, "cd ..\n\n");
        
        fprintf(script, "echo \"\\n2. EXECUTANDO CUNIT (DINÂMICO)...\"\n");
        fprintf(script, "cd cunit\n");
        fprintf(script, "./test_cunit\n");
        fprintf(script, "cd ..\n\n");
        
        fprintf(script, "echo \"\\n3. COMPILANDO DAIKON...\"\n");
        fprintf(script, "cd daikon\n");
        fprintf(script, "gcc test_daikon.c ../Manual/executar.c -o test_daikon\n");
        fprintf(script, "cd ..\n\n");
        
        fprintf(script, "echo \"\\n4. EXECUTANDO DAIKON (DINÂMICO)...\"\n");
        fprintf(script, "cd daikon\n");
        fprintf(script, "./test_daikon\n");
        fprintf(script, "cd ..\n\n");
        
        fprintf(script, "echo \"\\n5. ANÁLISE CLANG/LLVM (ESTÁTICO)...\"\n");
        fprintf(script, "echo \"Veja o arquivo: clang/analise_clang.md\"\n");
        fprintf(script, "echo \"Ou execute manualmente:\"\n");
        fprintf(script, "echo \"  clang --analyze -Xanalyzer -analyzer-checker=core ../Manual/executar.c\"\n\n");
        
        fprintf(script, "echo \"\\n6. SPIN MODEL CHECKER (ESTÁTICO)...\"\n");
        fprintf(script, "echo \"Para executar SPIN, primeiro instale-o e depois:\"\n");
        fprintf(script, "echo \"  cd spin && ./executar_spin.sh\"\n\n");
        
        fprintf(script, "echo \"\\n7. RELATÓRIO COMPARATIVO...\"\n");
        fprintf(script, "echo \"Consulte: relatorio/RELATORIO_COMPARATIVO.md\"\n\n");
        
        fprintf(script, "echo \"\\n========================================\"\n");
        fprintf(script, "echo \"  COMPARAÇÃO CONCLUÍDA!\"\n");
        fprintf(script, "echo \"========================================\"\n");
        fprintf(script, "echo \"\\nResumo dos 4 métodos gerados:\"\n");
        fprintf(script, "echo \"- 2 métodos DINÂMICOS (CUnit, Daikon)\"\n");
        fprintf(script, "echo \"- 2 métodos ESTÁTICOS (Clang/LLVM, SPIN)\"\n");
        fprintf(script, "echo \"- %d casos de teste cada\"\n", num_casos);
        fprintf(script, "echo \"- Relatório comparativo completo\"\n");
        
        fclose(script);
        chmod("executar_comparativo.sh", 0755);
    }
    
    printf("\n===============================================\n");
    printf("  GERAÇÃO CONCLUÍDA COM SUCESSO!\n");
    printf("===============================================\n\n");
    
    printf("Arquivos gerados em:\n");
    printf("  cunit/          - Testes CUnit (dinâmico) - %d testes\n", num_casos);
    printf("  daikon/         - Testes Daikon (dinâmico) - %d execuções\n", num_casos);
    printf("  clang/          - Análise Clang/LLVM (estático)\n");
    printf("  spin/           - Modelo SPIN (estático)\n");
    printf("  relatorio/      - Relatório comparativo\n\n");
    
    printf("Para executar toda a comparação:\n");
    printf("  chmod +x executar_comparativo.sh\n");
    printf("  ./executar_comparativo.sh\n\n");
    
    printf("Ou execute cada método separadamente:\n");
    printf("  1. cd cunit && gcc test_cunit.c ../Manual/executar.c -lcunit -o test_cunit && ./test_cunit\n");
    printf("  2. cd daikon && gcc test_daikon.c ../Manual/executar.c -o test_daikon && ./test_daikon\n");
    printf("  3. Veja clang/analise_clang.md\n");
    printf("  4. cd spin && ./executar_spin.sh (requer SPIN instalado)\n");
    
    return 0;
}