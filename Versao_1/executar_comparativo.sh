#!/bin/bash
echo "========================================"
echo "  EXECUTANDO COMPARATIVO COMPLETO"
echo "========================================"

echo "\n1. COMPILANDO CUNIT..."
cd cunit
gcc test_cunit.c ../Manual/executar.c -lcunit -o test_cunit
cd ..

echo "\n2. EXECUTANDO CUNIT (DINÂMICO)..."
cd cunit
./test_cunit
cd ..

echo "\n3. COMPILANDO DAIKON..."
cd daikon
gcc test_daikon.c ../Manual/executar.c -o test_daikon
cd ..

echo "\n4. EXECUTANDO DAIKON (DINÂMICO)..."
cd daikon
./test_daikon
cd ..

echo "\n5. ANÁLISE CLANG/LLVM (ESTÁTICO)..."
echo "Veja o arquivo: clang/analise_clang.md"
echo "Ou execute manualmente:"
echo "  clang --analyze -Xanalyzer -analyzer-checker=core ../Manual/executar.c"

echo "\n6. SPIN MODEL CHECKER (ESTÁTICO)..."
echo "Para executar SPIN, primeiro instale-o e depois:"
echo "  cd spin && ./executar_spin.sh"

echo "\n7. RELATÓRIO COMPARATIVO..."
echo "Consulte: relatorio/RELATORIO_COMPARATIVO.md"

echo "\n========================================"
echo "  COMPARAÇÃO CONCLUÍDA!"
echo "========================================"
echo "\nResumo dos 4 métodos gerados:"
echo "- 2 métodos DINÂMICOS (CUnit, Daikon)"
echo "- 2 métodos ESTÁTICOS (Clang/LLVM, SPIN)"
echo "- 7 casos de teste cada"
echo "- Relatório comparativo completo"
