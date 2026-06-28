#include <stdio.h>
#include <CUnit/CUnit.h>
#include <CUnit/Basic.h>
#include "executar.h"

// Teste para cadeia "112" (entra no while, executa if, incrementa, sai)
void test_cadeia_112(void) {
    printf("Teste: a=5, b=6 - Cadeia 112\n");
    CU_ASSERT_EQUAL(executar(5, 6), 1);
}

// Teste para cadeia "1111112" (múltiplas iterações)
void test_cadeia_1111112(void) {
    printf("Teste: a=5, b=10 - Cadeia 1111112\n");
    CU_ASSERT_EQUAL(executar(5, 10), 1);
}

// Teste para cadeia "11121112" (padrão específico)
void test_cadeia_11121112(void) {
    printf("Teste: a=6, b=9 - Cadeia 11121112\n");
    CU_ASSERT_EQUAL(executar(6, 9), 1);
}

// Teste quando não entra no while (a >= b)
void test_nao_entra_while(void) {
    printf("Teste: a=10, b=5 - Não entra no while\n");
    CU_ASSERT_EQUAL(executar(10, 5), 0);
}

// Teste quando a == b (não entra no while)
void test_a_igual_b(void) {
    printf("Teste: a=5, b=5 - A igual a B\n");
    CU_ASSERT_EQUAL(executar(5, 5), 0);
}

// Testes adicionais para melhor cobertura
void test_cadeia_12(void) {
    printf("Teste: a=1, b=3 - Cadeia 12\n");
    CU_ASSERT_EQUAL(executar(1, 3), 1);
}

void test_valores_negativos(void) {
    printf("Teste: a=-5, b=-1 - Valores negativos\n");
    CU_ASSERT_EQUAL(executar(-5, -1), 1);
}

int main() {
    // Inicializa o registro do CUnit
    if (CUE_SUCCESS != CU_initialize_registry())
        return CU_get_error();

    // Cria suite de testes
    CU_pSuite suite = CU_add_suite("Suite_Executar", NULL, NULL);
    if (NULL == suite) {
        CU_cleanup_registry();
        return CU_get_error();
    }

    // Adiciona testes à suite (conforme seus slides)
    if ((NULL == CU_add_test(suite, "Cadeia 112", test_cadeia_112)) ||
        (NULL == CU_add_test(suite, "Cadeia 1111112", test_cadeia_1111112)) ||
        (NULL == CU_add_test(suite, "Cadeia 11121112", test_cadeia_11121112)) ||
        (NULL == CU_add_test(suite, "Não entra no while", test_nao_entra_while)) ||
        (NULL == CU_add_test(suite, "A igual a B", test_a_igual_b)) ||
        (NULL == CU_add_test(suite, "Cadeia 12", test_cadeia_12)) ||
        (NULL == CU_add_test(suite, "Valores negativos", test_valores_negativos))) {
        CU_cleanup_registry();
        return CU_get_error();
    }

    // Executa todos os testes no modo básico
    CU_basic_set_mode(CU_BRM_VERBOSE);
    CU_basic_run_tests();
    
    // Limpa e retorna
    CU_cleanup_registry();
    return CU_get_error();
}