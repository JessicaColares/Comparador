int executar(int a, int b) {
    int resultado = 0;
    int i = 0;
    
    // Primeiro loop
    while (a < b && i < 3) {
        a = a + 2;
        i++;
        resultado = resultado + 1;
    }
    
    // Segundo loop
    while (a > b && resultado < 5) {
        a = a - 1;
        resultado = resultado + 2;
    }
    
    return resultado;
}
