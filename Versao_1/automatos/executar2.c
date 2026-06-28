int executar(int a, int b) {
    int resultado = 0;
    
    // Testando operações aritméticas básicas
    if (a > 0 && b > 0) {
        resultado = a + b;           // Soma
    } else if (a < 0 && b < 0) {
        resultado = a * b;           // Multiplicação (negativo * negativo = positivo)
    } else if (a == 0 || b == 0) {
        resultado = a - b;           // Subtração
    } else {
        resultado = a / b;           // Divisão (cuidado com b=0!)
    }
    
    return resultado;
}