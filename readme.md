# Guia de como usar o programa comparativo

Todos os automatos estão na pasta 'automatos'.

### 1. Dê permissão aos scripts

```
chmod +x testar_multiplos_automatos.sh setup_multiplos_automatos.sh analisar_completo.sh
```

### 2. Configure o ambiente

```
./setup_multiplos_automatos.sh
```

### 3. Execute os testes

```
./testar_multiplos_automatos.sh
```

### 4. Gerador de .jff para JFLAP e analisador de complexidade usando complexidade ciclomática

```
./analisar_completo.sh
```

## Observações

Todos os códigos a serem testados estão na pasta automatos. A versão .jff deles será gerada em jff_gerados.

A princípio eu testei com apenas um autômato na pasta chamada 'Manual', basicamente é só rodar o makefile na pasta principal.

