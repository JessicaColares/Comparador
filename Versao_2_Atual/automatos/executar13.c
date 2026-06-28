int executar(int a, int b) {
    int resultado = 0;
    
    while (a < b) {
        resultado = 1;
        if (a < 0) {
            a = a * -1;
        } else {
            a = a + 1;
        }
    }
    
    return resultado;
}