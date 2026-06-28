int executar(int a, int b) {
    int resultado = 0;
    int passo = 0;
    
    while (a < b && a > 0) {
        resultado = 1;
        if (passo % 2 == 0) {
            a = a * 2;
        } else {
            a = a / 2;
        }
        passo++;
    }
    
    return resultado;
}