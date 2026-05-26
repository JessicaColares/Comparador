int executar(int a, int b) {
    int estado = 0;  // 0: inicial, 1: processando, 2: final
    
    while (a < b && estado != 2) {
        if (estado == 0) {
            a = a + 1;
            if (a > 0) estado = 1;
        } else if (estado == 1) {
            a = a * 2;
            if (a >= b) estado = 2;
        }
    }
    
    return estado;
}