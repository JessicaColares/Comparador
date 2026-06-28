int executar(int a, int b) {
    int resultado = 0;
    
    while (a < b && resultado < 10) {
        if (a > 0) {
            a = a * 2;
            resultado = resultado + 1;
        } else if (a == 0) {
            a = a + 5;
            resultado = resultado + 2;
        } else {
            a = a * (-1);
            resultado = resultado + 3;
        }
    }
    
    return resultado;
}