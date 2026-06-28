int executar(int a, int b) {
    int resultado = 0;
    
    // Testa condições aninhadas SEM loop
    if (a < b) {
        if (a > 0) {
            if (a % 2 == 0) {
                resultado = a / 2;
            } else {
                resultado = a + b;
            }
        } else {
            resultado = a * b;
        }
    } else {
        if (a > 10) {
            resultado = a - b;
        } else {
            resultado = a + b;
        }
    }
    
    return resultado;
}