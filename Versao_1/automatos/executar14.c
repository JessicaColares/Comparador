int executar(int a, int b) {
    int resultado = 0;
    int passo = 0;
    int max_iter = 100;  // Limite de segurança
    
    while (a < b && a > 0 && passo < max_iter) {
        resultado = 1;
        if (passo % 2 == 0) {
            a = a * 2;
        } else {
            a = a / 2;
            // Garantir que não fique preso em 1
            if (a == 1 && passo % 2 == 1) {
                a = a + 1;  // Força sair do loop se ficar oscilando
            }
        }
        passo++;
    }
    
    // Se atingiu o limite, indica que o loop foi interrompido
    if (passo >= max_iter) {
        return -1;  // Loop interrompido por segurança
    }
    
    return resultado;
}