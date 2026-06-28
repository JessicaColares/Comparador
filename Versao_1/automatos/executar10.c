int executar(int a, int b) {
    int resultado = 0;
    int passo = 0;
    
    while (a < b) {
        resultado = 1;
        if (passo % 2 == 0) {
            a = a + 1;
        } else {
            a = a * 2;
        }
        passo++;
    }
    
    return resultado;
}