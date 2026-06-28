#!/bin/bash

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# =============================================
# FUNÇÃO PARA ANALISAR COM CPPCHECK (Estático)
# =============================================
analisar_cppcheck() {
    local NUM=$1
    local ARQUIVO="automatos/executar${NUM}.c"
    
    echo -e "\n${BLUE}▶ CPPCHECK (Análise Estática)...${NC}"
    
    if ! command -v cppcheck &> /dev/null; then
        echo -e "${YELLOW}⚠ Cppcheck não instalado. Instale com: sudo apt install cppcheck${NC}"
        return 1
    fi
    
    cppcheck --enable=all --quiet --xml \
        "$ARQUIVO" 2> "resultados_automatos/cppcheck_automato${NUM}.xml"
    
    ERRORS=$(grep -c 'severity="error"' "resultados_automatos/cppcheck_automato${NUM}.xml" 2>/dev/null | tr -d '\n' | xargs)
    WARNINGS=$(grep -c 'severity="warning"' "resultados_automatos/cppcheck_automato${NUM}.xml" 2>/dev/null | tr -d '\n' | xargs)
    
    ERRORS=${ERRORS:-0}
    WARNINGS=${WARNINGS:-0}
    
    if [ "$ERRORS" -eq 0 ] && [ "$WARNINGS" -eq 0 ]; then
        echo -e "   ${GREEN}✓ Sem erros ou warnings${NC}"
        echo "CLEAN" > "resultados_automatos/cppcheck_status_${NUM}.txt"
    else
        echo -e "   ${RED}⚠ Encontrados: $ERRORS erros, $WARNINGS warnings${NC}"
        echo "WARNINGS:${ERRORS}:${WARNINGS}" > "resultados_automatos/cppcheck_status_${NUM}.txt"
    fi
}

# =============================================
# FUNÇÃO PARA ANALISAR COM CLANG/LLVM (Estático)
# =============================================
analisar_clang() {
    local NUM=$1
    local ARQUIVO="automatos/executar${NUM}.c"
    
    echo -e "\n${BLUE}▶ CLANG/LLVM (Análise Estática)...${NC}"
    
    if ! command -v clang &> /dev/null; then
        echo -e "${YELLOW}⚠ Clang não instalado. Instale com: sudo apt install clang${NC}"
        return 1
    fi
    
    # Executa análise estática do Clang
    clang --analyze -Xanalyzer -analyzer-checker=core \
        "$ARQUIVO" 2> "resultados_automatos/clang_automato${NUM}.txt"
    
    # Verifica se encontrou algum problema
    if [ ! -s "resultados_automatos/clang_automato${NUM}.txt" ]; then
        echo -e "   ${GREEN}✓ Nenhum problema detectado${NC}"
        echo "CLEAN" > "resultados_automatos/clang_status_${NUM}.txt"
    else
        local ERRORS=$(grep -c "warning:\|error:" "resultados_automatos/clang_automato${NUM}.txt" 2>/dev/null | tr -d '\n')
        ERRORS=${ERRORS:-0}
        echo -e "   ${RED}⚠ Clang detectou $ERRORS problemas${NC}"
        echo "WARNINGS:${ERRORS}" > "resultados_automatos/clang_status_${NUM}.txt"
    fi
}

# =============================================
# FUNÇÃO PARA ANALISAR COM VALGRIND (Dinâmico)
# =============================================
analisar_valgrind() {
    local NUM=$1
    
    echo -e "\n${BLUE}▶ VALGRIND (Análise de Memória)...${NC}"
    
    if ! command -v valgrind &> /dev/null; then
        echo -e "${YELLOW}⚠ Valgrind não instalado. Instale com: sudo apt install valgrind${NC}"
        return 1
    fi
    
    cd Manual
    cat > test_valgrind.c << EOF
#include "executar.h"
#include <stdio.h>
int main() {
    printf("%d\n", executar(${NUM}, ${NUM}+1));
    return 0;
}
EOF
    
    gcc -g -O0 -o test_valgrind test_valgrind.c executar.c 2>/dev/null
    
    if [ -f test_valgrind ]; then
        valgrind --leak-check=full --error-exitcode=1 \
            --log-file="../resultados_automatos/valgrind_automato${NUM}.txt" \
            ./test_valgrind > /dev/null 2>&1
        
        if grep -q "ERROR SUMMARY: 0 errors" "../resultados_automatos/valgrind_automato${NUM}.txt" 2>/dev/null; then
            echo -e "   ${GREEN}✓ Sem erros de memória${NC}"
            echo "CLEAN" > "../resultados_automatos/valgrind_status_${NUM}.txt"
        else
            local LEAKS=$(grep "definitely lost:" "../resultados_automatos/valgrind_automato${NUM}.txt" 2>/dev/null | awk '{print $4}')
            echo -e "   ${RED}⚠ Vazamento detectado: ${LEAKS:-0} bytes perdidos${NC}"
            echo "LEAK:${LEAKS:-0}" > "../resultados_automatos/valgrind_status_${NUM}.txt"
        fi
        rm -f test_valgrind test_valgrind.c
    else
        echo -e "   ${RED}⚠ Falha na compilação para Valgrind${NC}"
        echo "ERROR" > "../resultados_automatos/valgrind_status_${NUM}.txt"
    fi
    cd ..
}

# =============================================
# FUNÇÃO PARA ANALISAR COM SANITIZERS (Dinâmico)
# =============================================
analisar_sanitizers() {
    local NUM=$1
    
    echo -e "\n${BLUE}▶ SANITIZERS (ASan - AddressSanitizer)...${NC}"
    
    cd Manual
    cat > test_asan.c << EOF
#include "executar.h"
#include <stdio.h>
int main() {
    printf("%d\n", executar(${NUM}, ${NUM}+1));
    return 0;
}
EOF
    
    gcc -fsanitize=address -g -O0 -o test_asan test_asan.c executar.c 2> /dev/null
    
    if [ -f test_asan ]; then
        ./test_asan > /dev/null 2> "../resultados_automatos/sanitizer_automato${NUM}.txt"
        local ASAN_EXIT=$?
        
        if [ $ASAN_EXIT -eq 0 ]; then
            echo -e "   ${GREEN}✓ ASan: Nenhum erro detectado${NC}"
            echo "CLEAN" > "../resultados_automatos/sanitizer_status_${NUM}.txt"
        else
            echo -e "   ${RED}⚠ ASan detectou erro (código $ASAN_EXIT)${NC}"
            echo "ERROR:${ASAN_EXIT}" > "../resultados_automatos/sanitizer_status_${NUM}.txt"
        fi
        rm -f test_asan test_asan.c
    else
        echo -e "   ${RED}⚠ Falha na compilação com ASan${NC}"
        echo "ERROR" > "../resultados_automatos/sanitizer_status_${NUM}.txt"
    fi
    cd ..
}

# =============================================
# FUNÇÃO PARA GERAR MODELO SPIN (Estático)
# =============================================
analisar_spin() {
    local NUM=$1
    local ARQUIVO="automatos/executar${NUM}.c"
    
    echo -e "\n${BLUE}▶ SPIN (Model Checking - Estático)...${NC}"
    
    if ! command -v spin &> /dev/null; then
        echo -e "${YELLOW}⚠ SPIN não instalado. Instale com: sudo apt install spin${NC}"
        echo "N/A" > "resultados_automatos/spin_status_${NUM}.txt"
        return 1
    fi
    
    # Criar modelo Promela simplificado baseado no autômato
    cat > "resultados_automatos/spin_modelo_${NUM}.pml" << EOF
/* Modelo SPIN para o autômato ${NUM} */
int a;
int b;
int resultado;

active proctype Automato() {
    // Valores de teste
    a = ${NUM};
    b = ${NUM} + 1;
    resultado = 0;
    
    // Modelagem simplificada do comportamento
    do
    :: (a < b) -> 
        resultado = 1;
        a = a + 1;
    :: else -> break;
    od;
    
    // Verificação
    assert(resultado == 0 || resultado == 1);
    printf("Autômato %d: resultado = %d\\n", ${NUM}, resultado);
}
EOF
    
    # Tenta verificar o modelo
    spin -a "resultados_automatos/spin_modelo_${NUM}.pml" 2> "resultados_automatos/spin_automato${NUM}.txt"
    
    if [ $? -eq 0 ]; then
        echo -e "   ${GREEN}✓ Modelo SPIN gerado com sucesso${NC}"
        echo "GENERATED" > "resultados_automatos/spin_status_${NUM}.txt"
    else
        echo -e "   ${RED}⚠ Erro na geração do modelo SPIN${NC}"
        echo "ERROR" > "resultados_automatos/spin_status_${NUM}.txt"
    fi
}

# =============================================
# FUNÇÃO PRINCIPAL - EXECUTAR TODAS
# =============================================
executar_todas_ferramentas() {
    local NUM=$1
    
    echo -e "\n${YELLOW}═══════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}  ANALISANDO AUTÔMATO $NUM COM FERRAMENTAS${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════════${NC}"
    
    analisar_cppcheck $NUM
    analisar_clang $NUM
    analisar_valgrind $NUM
    analisar_sanitizers $NUM
    analisar_spin $NUM
    
    echo -e "\n${YELLOW}───────────────────────────────────────────${NC}"
}

# Exportar funções para uso em outros scripts
export -f analisar_cppcheck
export -f analisar_clang
export -f analisar_valgrind
export -f analisar_sanitizers
export -f analisar_spin
export -f executar_todas_ferramentas