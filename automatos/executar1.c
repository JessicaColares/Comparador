int executar(int a, int b) {
    int c = 0;
    
    while (a < b) {
        c = 1;
        if (a < b)
            a = a + 1;
        else
            a = a - 1;
    }
    
    return c;
}