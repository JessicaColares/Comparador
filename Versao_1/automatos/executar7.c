int executar(int a, int b) {
    int passos = 0;
    int max_passos = 20;
    
    while (a < b && passos < max_passos) {
        if (a > b/2) {
            a = a + 1;
        } else {
            a = a * 2;
        }
        passos++;
    }
    
    return passos;
}