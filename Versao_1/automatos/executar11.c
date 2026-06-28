int executar(int a, int b) {
    int resultado = 0;
    int max_iter = 50;
    int iter = 0;
    
    while (a < b && iter < max_iter) {
        resultado = 1;
        a = a + 2;
        iter++;
    }
    
    return resultado;
}