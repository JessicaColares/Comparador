// =============================================
// TESTES DAIKON (DINÂMICO - DETECÇÃO DE INVARIANTES)
// =============================================

#include <stdio.h>
#include "../Manual/executar.h"

// Simulacao de instrumentacao para Daikon
void daikon_enter(const char *fn, int a, int b) {
    printf("DAIKON_ENTER %s: a=%d, b=%d\n", fn, a, b);
}

void daikon_exit(const char *fn, int result) {
    printf("DAIKON_EXIT %s: resultado=%d\n", fn, result);
}

void test_daikon_caso_1() {
    int a = 5;
    int b = 6;
    
    printf("\nDaikon - %s\n", "Caso 1: Cadeia 112");
    
    // Ponto de instrumentacao (entrada)
    daikon_enter("executar", a, b);
    
    // Execucao real
    int resultado = executar(a, b);
    
    // Ponto de instrumentacao (saida)
    daikon_exit("executar", resultado);
    
    // Registro para analise posterior
    printf("VALORES: a=%d, b=%d, resultado=%d\n", a, b, resultado);
}

void test_daikon_caso_2() {
    int a = 5;
    int b = 10;
    
    printf("\nDaikon - %s\n", "Caso 2: Cadeia 1111112");
    
    // Ponto de instrumentacao (entrada)
    daikon_enter("executar", a, b);
    
    // Execucao real
    int resultado = executar(a, b);
    
    // Ponto de instrumentacao (saida)
    daikon_exit("executar", resultado);
    
    // Registro para analise posterior
    printf("VALORES: a=%d, b=%d, resultado=%d\n", a, b, resultado);
}

void test_daikon_caso_3() {
    int a = 1;
    int b = 3;
    
    printf("\nDaikon - %s\n", "Caso 3: Cadeia 12");
    
    // Ponto de instrumentacao (entrada)
    daikon_enter("executar", a, b);
    
    // Execucao real
    int resultado = executar(a, b);
    
    // Ponto de instrumentacao (saida)
    daikon_exit("executar", resultado);
    
    // Registro para analise posterior
    printf("VALORES: a=%d, b=%d, resultado=%d\n", a, b, resultado);
}

void test_daikon_caso_4() {
    int a = 10;
    int b = 5;
    
    printf("\nDaikon - %s\n", "Caso 4: Nao entra no loop");
    
    // Ponto de instrumentacao (entrada)
    daikon_enter("executar", a, b);
    
    // Execucao real
    int resultado = executar(a, b);
    
    // Ponto de instrumentacao (saida)
    daikon_exit("executar", resultado);
    
    // Registro para analise posterior
    printf("VALORES: a=%d, b=%d, resultado=%d\n", a, b, resultado);
}

void test_daikon_caso_5() {
    int a = 5;
    int b = 5;
    
    printf("\nDaikon - %s\n", "Caso 5: A igual a B");
    
    // Ponto de instrumentacao (entrada)
    daikon_enter("executar", a, b);
    
    // Execucao real
    int resultado = executar(a, b);
    
    // Ponto de instrumentacao (saida)
    daikon_exit("executar", resultado);
    
    // Registro para analise posterior
    printf("VALORES: a=%d, b=%d, resultado=%d\n", a, b, resultado);
}

void test_daikon_caso_6() {
    int a = -5;
    int b = -1;
    
    printf("\nDaikon - %s\n", "Caso 6: Valores negativos");
    
    // Ponto de instrumentacao (entrada)
    daikon_enter("executar", a, b);
    
    // Execucao real
    int resultado = executar(a, b);
    
    // Ponto de instrumentacao (saida)
    daikon_exit("executar", resultado);
    
    // Registro para analise posterior
    printf("VALORES: a=%d, b=%d, resultado=%d\n", a, b, resultado);
}

void test_daikon_caso_7() {
    int a = 6;
    int b = 9;
    
    printf("\nDaikon - %s\n", "Caso 7: Cadeia complexa");
    
    // Ponto de instrumentacao (entrada)
    daikon_enter("executar", a, b);
    
    // Execucao real
    int resultado = executar(a, b);
    
    // Ponto de instrumentacao (saida)
    daikon_exit("executar", resultado);
    
    // Registro para analise posterior
    printf("VALORES: a=%d, b=%d, resultado=%d\n", a, b, resultado);
}

int main() {
    printf("\n=== DAIKON (ANALISE DINAMICA) ===\n");
    printf("Detector de invariantes atraves de execucao instrumentada\n\n");
    printf("Executando casos de teste para coleta de dados...\n\n");
    test_daikon_caso_1();
    test_daikon_caso_2();
    test_daikon_caso_3();
    test_daikon_caso_4();
    test_daikon_caso_5();
    test_daikon_caso_6();
    test_daikon_caso_7();

    printf("\nColeta de dados concluida!\n");
    printf("\nResumo Daikon:\n");
    printf("  - 7 execucoes instrumentadas\n");
    printf("  - Valores capturados em pontos do programa\n");
    printf("  - Dados podem ser analisados para encontrar invariantes\n");
    printf("  - Exemplos de invariantes que poderiam ser detectados:\n");
    printf("     1. resultado sempre e 0 ou 1\n");
    printf("     2. se a <= b, resultado = 0\n");
    printf("     3. durante loop: a sempre decrementa\n");
    printf("  - Classificacao: METODO DINAMICO\n");
    
    printf("\nPara uso real do Daikon:\n");
    printf("  1. Compile com instrumentacao: java daikon.DynComp test_daikon\n");
    printf("  2. Execute: java daikon.Chicory --dtrace-file=test.dtrace ./test_daikon\n");
    printf("  3. Analise: java daikon.Daikon test.dtrace\n");
    
    return 0;
}
