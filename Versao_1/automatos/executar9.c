int executar(int a, int b) {
    int resultado = 0;
    
    while (a > b) {
        resultado = 1;
        a = a - 1;
    }
    
    return resultado;
}