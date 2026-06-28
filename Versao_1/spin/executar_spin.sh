#!/bin/bash
echo "Executando SPIN Model Checker..."
echo "================================"

echo "1. Gerando verificador..."
spin -a modelo_spin.pml

echo "2. Compilando verificador..."
gcc pan.c -o pan

echo "3. Executando verificação..."
echo "\n=== RESULTADOS SPIN ==="
./pan -a | grep -A 20 "errors:"

echo "\n4. Resumo:"
echo "- Método: Verificação Formal (Estático)"
echo "- Técnica: Model Checking"
echo "- Vantagem: Verificação exaustiva de propriedades"
