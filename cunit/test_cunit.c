// =============================================
// TESTES CUNIT (ANÁLISE DINÂMICA)
// =============================================

#include <stdio.h>
#include <CUnit/CUnit.h>
#include <CUnit/Basic.h>
#include "../Manual/executar.h"

void test_caso_1(void) {
    printf("CUnit - Caso 1: Cadeia 112\n");
    printf("  a=%d, b=%d, esperado=%d\n", 5, 6, 1);
    CU_ASSERT_EQUAL(executar(5, 6), 1);
}

void test_caso_2(void) {
    printf("CUnit - Caso 2: Cadeia 1111112\n");
    printf("  a=%d, b=%d, esperado=%d\n", 5, 10, 1);
    CU_ASSERT_EQUAL(executar(5, 10), 1);
}

void test_caso_3(void) {
    printf("CUnit - Caso 3: Cadeia 12\n");
    printf("  a=%d, b=%d, esperado=%d\n", 1, 3, 1);
    CU_ASSERT_EQUAL(executar(1, 3), 1);
}

void test_caso_4(void) {
    printf("CUnit - Caso 4: Nao entra no loop\n");
    printf("  a=%d, b=%d, esperado=%d\n", 10, 5, 0);
    CU_ASSERT_EQUAL(executar(10, 5), 0);
}

void test_caso_5(void) {
    printf("CUnit - Caso 5: A igual a B\n");
    printf("  a=%d, b=%d, esperado=%d\n", 5, 5, 0);
    CU_ASSERT_EQUAL(executar(5, 5), 0);
}

void test_caso_6(void) {
    printf("CUnit - Caso 6: Valores negativos\n");
    printf("  a=%d, b=%d, esperado=%d\n", -5, -1, 1);
    CU_ASSERT_EQUAL(executar(-5, -1), 1);
}

void test_caso_7(void) {
    printf("CUnit - Caso 7: Cadeia complexa\n");
    printf("  a=%d, b=%d, esperado=%d\n", 6, 9, 1);
    CU_ASSERT_EQUAL(executar(6, 9), 1);
}

int main() {
    printf("\n=== CUNIT (ANALISE DINAMICA) ===\n");
    printf("Framework de testes unitarios\n\n");
    if (CUE_SUCCESS != CU_initialize_registry())
        return CU_get_error();

    CU_pSuite suite = CU_add_suite("Testes_AF", NULL, NULL);
    if (NULL == suite) {
        CU_cleanup_registry();
        return CU_get_error();
    }

    CU_add_test(suite, "Caso 1: Cadeia 112", test_caso_1);
    CU_add_test(suite, "Caso 2: Cadeia 1111112", test_caso_2);
    CU_add_test(suite, "Caso 3: Cadeia 12", test_caso_3);
    CU_add_test(suite, "Caso 4: Nao entra no loop", test_caso_4);
    CU_add_test(suite, "Caso 5: A igual a B", test_caso_5);
    CU_add_test(suite, "Caso 6: Valores negativos", test_caso_6);
    CU_add_test(suite, "Caso 7: Cadeia complexa", test_caso_7);

    CU_basic_set_mode(CU_BRM_VERBOSE);
    CU_basic_run_tests();
    int falhas = CU_get_number_of_failures();
    CU_cleanup_registry();
    
    printf("\nResumo CUnit:\n");
    printf("  - 7 testes executados\n");
    printf("  - %d falhas\n", falhas);
    printf("  - Verificacao durante execucao\n");
    printf("  - Classificacao: METODO DINAMICO\n");
    
    return falhas;
}
