#!/bin/bash

echo "=============================================="
echo "  TESTANDO MÚLTIPLOS AUTÔMATOS"
echo "=============================================="
echo ""

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Carregar funções das novas ferramentas
source analisar_ferramentas.sh 2>/dev/null || echo -e "${YELLOW}⚠ analisar_ferramentas.sh não encontrado${NC}"

# Criar diretório para resultados
mkdir -p resultados_automatos

# Arquivo de relatório consolidado
RELATORIO="resultados_automatos/relatorio_completo.md"
echo "# RELATÓRIO DE TESTES COM MÚLTIPLOS AUTÔMATOS" > $RELATORIO
echo "" >> $RELATORIO
echo "Data: $(date)" >> $RELATORIO
echo "" >> $RELATORIO
echo "## Resumo dos Resultados" >> $RELATORIO
echo "" >> $RELATORIO
echo "| Autômato | CUnit/Daikon | Cobertura | Falhas | Cppcheck | Clang | Valgrind | ASan | SPIN |" >> $RELATORIO
echo "|----------|--------------|-----------|--------|----------|-------|----------|------|------|" >> $RELATORIO

# =============================================
# FUNÇÃO PARA DETECTAR AUTÔMATOS DISPONÍVEIS
# =============================================
detectar_automatos() {
    local automatos=()
    
    # Verifica se pasta automatos existe
    if [ ! -d "automatos" ]; then
        echo -e "${RED}ERRO: Pasta 'automatos/' não encontrada!${NC}"
        return 1
    fi
    
    # Lista todos os arquivos executar*.c e extrai os números
    for arquivo in automatos/executar*.c; do
        if [ -f "$arquivo" ]; then
            # Extrai o número do arquivo (ex: executar1.c -> 1)
            num=$(basename "$arquivo" | sed 's/executar//' | sed 's/.c//')
            automatos+=($num)
        fi
    done
    
    # Ordena numericamente
    IFS=$'\n' automatos=($(sort -n <<<"${automatos[*]}"))
    unset IFS
    
    echo "${automatos[@]}"
}

# =============================================
# FUNÇÃO PARA OBTER NOME DO AUTÔMATO
# =============================================
get_nome_automato() {
    local NUM=$1
    local NOME=""
    
    # Tenta extrair o nome do comentário do arquivo
    if [ -f "automatos/executar${NUM}.c" ]; then
        # Procura por comentário de nome (ex: // Nome: ...)
        NOME=$(grep -E "//.*Nome:|/\*.*\*/" "automatos/executar${NUM}.c" | head -1 | sed 's/\/\/.*Nome://' | sed 's/\/\*//' | sed 's/\*\///' | xargs)
    fi
    
    # Se não encontrou, usa um nome padrão
    if [ -z "$NOME" ]; then
        NOME="Autômato $NUM"
    fi
    
    echo "$NOME"
}

# =============================================
# FUNÇÃO PARA TESTAR UM AUTÔMATO ESPECÍFICO
# =============================================
testar_automato() {
    local NUM=$1
    local NOME=$(get_nome_automato $NUM)
    
    echo -e "\n${YELLOW}═══════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}  TESTANDO AUTÔMATO $NUM: $NOME${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════════${NC}"
    
    # Verificar se o arquivo existe
    if [ ! -f "automatos/executar$NUM.c" ]; then
        echo -e "${RED}ERRO: Arquivo automatos/executar$NUM.c não encontrado!${NC}"
        echo "| $NUM - $NOME | NÃO ENCONTRADO | N/A | N/A | Arquivo faltando |" >> $RELATORIO
        return
    fi
    
    # Backup do executar original
    if [ -f Manual/executar.c ]; then
        cp Manual/executar.c Manual/executar.c.backup
    fi
    
    # Copiar da pasta automatos/
    cp automatos/executar$NUM.c Manual/executar.c
    echo -e "${GREEN}✓ Copiado: automatos/executar$NUM.c → Manual/executar.c${NC}"
    
    # Mostrar primeiras linhas do autômato
    echo -e "${BLUE}▶ Primeiras linhas:${NC}"
    head -3 automatos/executar$NUM.c | sed 's/^/   /'
    
    # Compilar e executar CUnit
    cd cunit
    echo -e "\n${BLUE}▶ Compilando CUnit...${NC}"
    gcc -Wall -g test_cunit.c ../Manual/executar.c -lcunit -o test_cunit 2>/dev/null
    
    echo -e "${BLUE}▶ Executando testes CUnit...${NC}"
    ./test_cunit > ../resultados_automatos/cunit_automato$NUM.txt 2>&1
    CUNIT_RESULT=$?
    cd ..
    
    # Compilar e executar Daikon
    cd daikon
    echo -e "${BLUE}▶ Compilando Daikon...${NC}"
    gcc -Wall -g test_daikon.c ../Manual/executar.c -o test_daikon 2>/dev/null
    
    echo -e "${BLUE}▶ Executando testes Daikon...${NC}"
    ./test_daikon > ../resultados_automatos/daikon_automato$NUM.txt 2>&1
    DAIKON_RESULT=$?
    cd ..
    
    # Executar cobertura
    cd Manual
    echo -e "${BLUE}▶ Analisando cobertura...${NC}"
    make clean > /dev/null 2>&1
    make coverage > ../resultados_automatos/cobertura_automato$NUM.txt 2>&1
    COBERTURA=$(grep -o "[0-9]\+\.[0-9]\+%" ../resultados_automatos/cobertura_automato$NUM.txt | tail -1)
    if [ -z "$COBERTURA" ]; then
        COBERTURA="N/A"
    fi
    cd ..

    # Executar análises com novas ferramentas
    executar_todas_ferramentas $NUM
    
    # Analisar resultados
    if [ $CUNIT_RESULT -eq 0 ] && [ $DAIKON_RESULT -eq 0 ]; then
        STATUS="${GREEN} SUCESSO${NC}"
        STATUS_SIMPLES=" SUCESSO"
    else
        STATUS="${RED} FALHA${NC}"
        STATUS_SIMPLES=" FALHA"
    fi
    
    # Extrair número de falhas
    FALHAS=$(grep "Failures :" resultados_automatos/cunit_automato$NUM.txt | awk '{print $3}')
    if [ -z "$FALHAS" ]; then
        FALHAS="0"
    fi
    
    # Observações
    if grep -q "else" automatos/executar$NUM.c; then
        OBS="Tem branch else"
    else
        OBS="Sem else"
    fi
    
    echo -e "\n${GREEN}▶ RESULTADO:${NC} $STATUS"
    echo -e "${GREEN}▶ COBERTURA:${NC} $COBERTURA"
    echo -e "${GREEN}▶ FALHAS:${NC} $FALHAS"
    
    # Adicionar ao relatório
    echo "| $NUM - $NOME | $STATUS_SIMPLES | $COBERTURA | $FALHAS | $OBS |" >> $RELATORIO
    
    # Restaurar backup
    if [ -f Manual/executar.c.backup ]; then
        mv Manual/executar.c.backup Manual/executar.c
        echo -e "${GREEN}✓ Arquivo original restaurado${NC}"
    fi
    
    echo -e "\n${YELLOW}───────────────────────────────────────────${NC}"
}

# =============================================
# FUNÇÃO PARA GERAR GRÁFICO (DINÂMICO)
# =============================================
gerar_grafico() {
    echo ""
    echo -e "${BLUE} GRÁFICO DE COBERTURA POR AUTÔMATO:${NC}"
    echo "----------------------------------------"
    
    # Obter lista de autômatos do relatório
    automatos=$(grep "^| [0-9]\+ -" $RELATORIO | awk -F'|' '{print $1}' | sed 's/|//' | awk '{print $1}')
    
    for i in $automatos; do
        LINHA=$(grep "^| $i -" $RELATORIO | head -1)
        COBERTURA=$(echo "$LINHA" | awk -F'|' '{print $3}' | sed 's/ //g' | sed 's/%//g' | grep -o "[0-9.]\+" | head -1)
        
        if [ -n "$COBERTURA" ] && [ "$COBERTURA" != "N/A" ] && [ "$COBERTURA" != "✅" ] && [ "$COBERTURA" != "❌" ]; then
            BARS=$(echo "scale=0; $COBERTURA / 5" | bc 2>/dev/null)
            if [ -z "$BARS" ] || [ "$BARS" -lt 0 ] || [ "$BARS" -gt 20 ]; then
                BARS=0
            fi
            
            printf "Autômato %2d: [" $i
            for ((j=1; j<=20; j++)); do
                if [ $j -le $BARS ]; then
                    echo -n "█"
                else
                    echo -n "░"
                fi
            done
            printf "] %.1f%%\n" $COBERTURA
        else
            echo "Autômato $i: [░░░░░░░░░░░░░░░░░░░░] N/A"
        fi
    done
}

# =============================================
# FUNÇÃO PARA RESUMO DE INVARIANTES (DINÂMICO)
# =============================================
resumo_invariantes() {
    echo ""
    echo -e "${BLUE} RESUMO DE INVARIANTES DETECTADOS:${NC}"
    echo "----------------------------------------"
    
    # Obter lista de autômatos testados
    automatos=$(grep "^| [0-9]\+ -" $RELATORIO 2>/dev/null | awk -F'|' '{print $1}' | sed 's/|//' | awk '{print $1}')
    
    if [ -z "$automatos" ]; then
        echo "Nenhum resultado encontrado. Execute testes primeiro."
        return
    fi
    
    for i in $automatos; do
        NOME=$(get_nome_automato $i)
        echo -e "\n${YELLOW}Autômato $i - $NOME:${NC}"
        if [ -f "resultados_automatos/daikon_automato$i.txt" ]; then
            grep -E "invariantes|VALORES|resultado|DAIKON|a=|b=" resultados_automatos/daikon_automato$i.txt 2>/dev/null | head -5 | sed 's/^/   /'
        else
            echo "   Arquivo não encontrado"
        fi
    done
}

# =============================================
# FUNÇÃO PARA LISTAR AUTÔMATOS DISPONÍVEIS
# =============================================
listar_automatos() {
    echo -e "\n${BLUE} AUTÔMATOS DISPONÍVEIS:${NC}"
    echo "----------------------------------------"
    
    local automatos=$(ls automatos/executar*.c 2>/dev/null | sed 's/automatos\/executar//' | sed 's/.c//' | sort -n)
    
    if [ -z "$automatos" ]; then
        echo "Nenhum autômato encontrado em automatos/"
        return 1
    fi
    
    for num in $automatos; do
        NOME=$(get_nome_automato $num)
        printf "  %2d - %s\n" $num "$NOME"
    done
    
    echo "----------------------------------------"
    return 0
}

# =============================================
# MENU PRINCIPAL
# =============================================
menu() {
    # Atualiza lista de autômatos
    AUTOMATOS_LISTA=($(detectar_automatos))
    TOTAL_AUTOMATOS=${#AUTOMATOS_LISTA[@]}
    
    echo ""
    echo -e "${BLUE}=============================================${NC}"
    echo -e "${BLUE}  MENU DE TESTES COM MÚLTIPLOS AUTÔMATOS${NC}"
    echo -e "${BLUE}=============================================${NC}"
    echo -e "${GREEN} Autômatos disponíveis: $TOTAL_AUTOMATOS${NC}"
    echo ""
    echo "1) Testar TODOS os autômatos"
    echo "2) Testar autômato específico"
    echo "3) Listar autômatos disponíveis"
    echo "4) Mostrar resultados já obtidos"
    echo "5) Gerar gráfico de cobertura"
    echo "6) Ver resumo de invariantes"
    echo "7) Limpar resultados"
    echo "0) Sair"
    echo ""
    echo -n "Escolha uma opção: "
    read opcao
    
    case $opcao in
        1)
            echo -e "\n${GREEN}Testando TODOS os ${TOTAL_AUTOMATOS} autômatos...${NC}"
            
            if [ ${#AUTOMATOS_LISTA[@]} -eq 0 ]; then
                echo -e "${RED}ERRO: Nenhum autômato encontrado em automatos/!${NC}"
                echo "Crie arquivos no formato executarN.c"
            else
                for num in "${AUTOMATOS_LISTA[@]}"; do
                    testar_automato $num
                done
                echo -e "\n${GREEN} Todos os testes concluídos!${NC}"
                echo " Resultados salvos em: resultados_automatos/"
                gerar_grafico
            fi
            ;;
        2)
            listar_automatos
            echo -n "Digite o número do autômato: "
            read num
            if [[ " ${AUTOMATOS_LISTA[@]} " =~ " ${num} " ]]; then
                testar_automato $num
            else
                echo -e "${RED}Autômato $num não encontrado!${NC}"
            fi
            ;;
        3)
            listar_automatos
            ;;
        4)
            echo -e "\n${BLUE}Resultados já obtidos:${NC}"
            if [ -f "$RELATORIO" ]; then
                cat $RELATORIO
            else
                echo "Nenhum resultado encontrado. Execute testes primeiro."
            fi
            ;;
        5)
            if [ -f "$RELATORIO" ]; then
                gerar_grafico
            else
                echo "Nenhum resultado encontrado. Execute testes primeiro."
            fi
            ;;
        6)
            resumo_invariantes
            ;;
        7)
            rm -rf resultados_automatos
            mkdir -p resultados_automatos
            echo -e "${GREEN}Resultados limpos!${NC}"
            ;;
        0)
            echo -e "\n${GREEN}Até mais!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Opção inválida!${NC}"
            ;;
    esac
    
    echo ""
    echo -n "Pressione Enter para continuar..."
    read
    menu
}

# Iniciar menu
menu