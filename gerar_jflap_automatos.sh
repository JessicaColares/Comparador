#!/bin/bash

# =============================================
# GERADOR DE AUTÔMATOS JFLAP (VERSÃO ESTÁVEL)
# =============================================

echo "=============================================="
echo "  GERANDO AUTÔMATOS JFLAP"
echo "=============================================="
echo ""

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Criar diretório
mkdir -p jff_gerados

# =============================================
# FUNÇÃO PARA GERAR COORDENADAS SIMPLES
# =============================================
gerar_coordenadas() {
    local NUM_ESTADOS=$1
    local POSICOES=()
    
    # Posições pré-definidas em formato de grade
    case $NUM_ESTADOS in
        3)
            POSICOES=("100,150" "250,150" "400,150")
            ;;
        4)
            POSICOES=("100,100" "300,100" "100,250" "300,250")
            ;;
        5)
            POSICOES=("100,100" "250,80" "400,100" "150,220" "350,220")
            ;;
        6)
            POSICOES=("80,100" "220,80" "360,80" "120,220" "280,220" "400,200")
            ;;
        7)
            POSICOES=("80,80" "220,60" "360,80" "80,220" "220,240" "360,220" "500,150")
            ;;
        8)
            POSICOES=("60,80" "180,60" "300,60" "420,80" "80,220" "200,240" "320,220" "440,200")
            ;;
        *)
            # Para mais estados, usar posições simples
            for ((i=0; i<$NUM_ESTADOS; i++)); do
                POSICOES+=("$((80 + i * 60)),$((150 + (i % 3) * 80))")
            done
            ;;
    esac
    
    echo "${POSICOES[@]}"
}

# =============================================
# FUNÇÃO PARA GERAR AUTÔMATO
# =============================================
gerar_automato() {
    local NUM=$1
    local OUTPUT="jff_gerados/automato_${NUM}.jff"
    
    echo -e "${BLUE}▶ Gerando autômato para executar${NUM}.c...${NC}"
    
    # Extrair informações do código
    local ARQUIVO="automatos/executar${NUM}.c"
    local NOME=$(grep -E "//.*Nome:|/\*.*\*/" "$ARQUIVO" 2>/dev/null | head -1 | sed 's/\/\/.*Nome://' | sed 's/\/\*//' | sed 's/\*\///' | xargs)
    
    if [ -z "$NOME" ]; then
        NOME="Autômato $NUM"
    fi
    
    # Contar estruturas
    local IF_COUNT=$(grep -c "\<if\>" "$ARQUIVO" 2>/dev/null)
    local ELSE_COUNT=$(grep -c "\<else\>" "$ARQUIVO" 2>/dev/null)
    local WHILE_COUNT=$(grep -c "\<while\>" "$ARQUIVO" 2>/dev/null)
    local FOR_COUNT=$(grep -c "\<for\>" "$ARQUIVO" 2>/dev/null)
    
    local TOTAL_ESTRUTURAS=$((IF_COUNT + ELSE_COUNT + WHILE_COUNT + FOR_COUNT))
    
    # Número de estados
    local NUM_ESTADOS=$((TOTAL_ESTRUTURAS + 2))
    if [ $NUM_ESTADOS -lt 3 ]; then
        NUM_ESTADOS=3
    fi
    if [ $NUM_ESTADOS -gt 8 ]; then
        NUM_ESTADOS=8
    fi
    
    echo -e "${BLUE}▶ Estruturas: $TOTAL_ESTRUTURAS | Estados: $NUM_ESTADOS${NC}"
    
    # Gerar coordenadas
    local COORDENADAS=($(gerar_coordenadas $NUM_ESTADOS))
    
    # Gerar XML
    cat > "$OUTPUT" << 'EOF'
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!--Created with JFLAP 7.1.-->
EOF

    cat >> "$OUTPUT" << EOF
<!-- Autômato: $NOME (executar${NUM}.c) -->
<!-- Estruturas: if=$IF_COUNT, else=$ELSE_COUNT, while=$WHILE_COUNT, for=$FOR_COUNT -->
<structure>
	<type>fa</type>
	<automaton>
		<!--The list of states.-->
EOF

    # Gerar estados
    for ((i=0; i<$NUM_ESTADOS; i++)); do
        # Pegar coordenadas
        local COORD="${COORDENADAS[$i]:-"$((80 + i * 60)),150"}"
        local X=$(echo "$COORD" | cut -d',' -f1)
        local Y=$(echo "$COORD" | cut -d',' -f2)
        
        # Tags especiais
        local INITIAL=""
        local FINAL=""
        local LABEL=""
        local LABEL_Y=$(($Y - 20))
        
        if [ $i -eq 0 ]; then
            INITIAL="<initial/>"
            LABEL="Início"
        elif [ $i -eq $((NUM_ESTADOS-1)) ]; then
            FINAL="<final/>"
            LABEL="Fim"
        else
            # Labels baseados na estrutura
            if [ $i -le $IF_COUNT ]; then
                LABEL="if"
            elif [ $i -le $((IF_COUNT + WHILE_COUNT)) ]; then
                LABEL="loop"
            else
                LABEL="q$i"
            fi
        fi
        
        cat >> "$OUTPUT" << EOF
		<state id="$i" name="q$i">
			<x>$X.0</x>
			<y>$Y.0</y>
			$INITIAL
			$FINAL
EOF

        if [ -n "$LABEL" ]; then
            cat >> "$OUTPUT" << EOF
			<label x="$X.0" y="$LABEL_Y.0">$LABEL</label>
EOF
        fi
        
        cat >> "$OUTPUT" << EOF
		</state>
EOF
    done

    # Transições
    cat >> "$OUTPUT" << 'EOF'
		<!--The list of transitions.-->
EOF

    # Transição inicial
    cat >> "$OUTPUT" << EOF
		<transition>
			<from>0</from>
			<to>1</to>
			<read>a &lt; b</read>
			<label>Entrada</label>
		</transition>
EOF

    # Transições intermediárias
    for ((i=1; i<$((NUM_ESTADOS-1)); i++)); do
        local TO=$((i+1))
        local READ=""
        local LABEL=""
        
        if [ $i -le $IF_COUNT ]; then
            if [ $((i % 2)) -eq 1 ]; then
                READ="true"
                LABEL="Verdadeiro"
            else
                READ="false"
                LABEL="Falso"
            fi
        elif [ $i -le $((IF_COUNT + WHILE_COUNT)) ]; then
            READ="loop"
            LABEL="Iteração"
        else
            READ="processo"
            LABEL="Processo"
        fi
        
        cat >> "$OUTPUT" << EOF
		<transition>
			<from>$i</from>
			<to>$TO</to>
			<read>$READ</read>
			<label>$LABEL</label>
		</transition>
EOF
    done

    # Se tiver loops, adicionar transição de retorno
    if [ $WHILE_COUNT -gt 0 ] || [ $FOR_COUNT -gt 0 ]; then
        local LOOP_FROM=$((NUM_ESTADOS-2))
        cat >> "$OUTPUT" << EOF
		<transition>
			<from>$LOOP_FROM</from>
			<to>1</to>
			<read>loop</read>
			<label>Loop continua</label>
		</transition>
EOF
    fi

    # Transição final
    local FINAL_FROM=$((NUM_ESTADOS-2))
    local FINAL_TO=$((NUM_ESTADOS-1))
    cat >> "$OUTPUT" << EOF
		<transition>
			<from>$FINAL_FROM</from>
			<to>$FINAL_TO</to>
			<read>fim</read>
			<label>Saída</label>
		</transition>
EOF

    cat >> "$OUTPUT" << 'EOF'
	</automaton>
</structure>
EOF

    echo -e "${GREEN}✓ Gerado: $OUTPUT${NC}"
    
    # Testar o arquivo gerado
    testar_arquivo "$OUTPUT"
}

# =============================================
# FUNÇÃO PARA TESTAR ARQUIVO JFLAP
# =============================================
testar_arquivo() {
    local ARQUIVO=$1
    
    # Verificar IDs duplicados
    local IDs=$(grep -o 'id="[0-9]*"' "$ARQUIVO" | sort | uniq -d)
    if [ -n "$IDs" ]; then
        echo -e "  ${RED}⚠ ERRO: IDs duplicados: $IDs${NC}"
        return 1
    fi
    
    # Verificar coordenadas
    if grep -q '<x>.*,.*</x>' "$ARQUIVO"; then
        echo -e "  ${RED}⚠ ERRO: Coordenadas com vírgula!${NC}"
        return 1
    fi
    
    if grep -q '<x>.*\..*\..*</x>' "$ARQUIVO"; then
        echo -e "  ${RED}⚠ ERRO: Coordenadas com múltiplos pontos!${NC}"
        return 1
    fi
    
    # Verificar transições com IDs inválidos
    if grep -q '<from>-1</from>' "$ARQUIVO" || grep -q '<to>-1</to>' "$ARQUIVO"; then
        echo -e "  ${RED}⚠ ERRO: Transição com ID -1!${NC}"
        return 1
    fi
    
    # Verificar se todos os estados têm coordenadas
    if grep -q '<x></x>' "$ARQUIVO" || grep -q '<y></y>' "$ARQUIVO"; then
        echo -e "  ${RED}⚠ ERRO: Coordenadas vazias!${NC}"
        return 1
    fi
    
    echo -e "  ${GREEN}✓ Arquivo válido${NC}"
    return 0
}

# =============================================
# FUNÇÃO PARA GERAR AUTÔMATO MANUALMENTE
# =============================================
gerar_manual() {
    local OUTPUT="jff_gerados/automato_manual.jff"
    
    echo -e "${BLUE}▶ Gerando autômato manual de exemplo...${NC}"
    
    cat > "$OUTPUT" << 'EOF'
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!--Created with JFLAP 7.1.-->
<structure>
	<type>fa</type>
	<automaton>
		<!--The list of states.-->
		<state id="0" name="q0">
			<x>100.0</x>
			<y>150.0</y>
			<initial/>
			<label x="100.0" y="130.0">Início</label>
		</state>
		<state id="1" name="q1">
			<x>250.0</x>
			<y>150.0</y>
			<label x="250.0" y="130.0">Processo</label>
		</state>
		<state id="2" name="q2">
			<x>400.0</x>
			<y>150.0</y>
			<final/>
			<label x="400.0" y="130.0">Fim</label>
		</state>
		<!--The list of transitions.-->
		<transition>
			<from>0</from>
			<to>1</to>
			<read>0</read>
			<label>Entrada</label>
		</transition>
		<transition>
			<from>1</from>
			<to>2</to>
			<read>1</read>
			<label>Saída</label>
		</transition>
	</automaton>
</structure>
EOF

    echo -e "${GREEN}✓ Gerado: $OUTPUT${NC}"
}

# =============================================
# MENU
# =============================================
menu() {
    echo ""
    echo -e "${BLUE}=============================================${NC}"
    echo -e "${BLUE}  GERADOR DE AUTÔMATOS JFLAP${NC}"
    echo -e "${BLUE}=============================================${NC}"
    echo ""
    echo "1) Gerar JFLAP para TODOS os autômatos"
    echo "2) Gerar JFLAP para autômato específico"
    echo "3) Gerar autômato manual (exemplo funcional)"
    echo "4) Listar autômatos disponíveis"
    echo "5) Testar todos os arquivos gerados"
    echo "6) Limpar arquivos JFLAP"
    echo "0) Sair"
    echo ""
    echo -n "Escolha uma opção: "
    read opcao
    
    case $opcao in
        1)
            echo -e "\n${GREEN}Gerando JFLAP para TODOS os autômatos...${NC}"
            echo ""
            for arquivo in automatos/executar*.c; do
                if [ -f "$arquivo" ]; then
                    NUM=$(basename "$arquivo" | sed 's/executar//' | sed 's/.c//')
                    gerar_automato "$NUM"
                    echo ""
                fi
            done
            echo -e "${GREEN}✓ Todos os autômatos gerados!${NC}"
            echo "Arquivos em: jff_gerados/"
            ;;
        2)
            echo -n "Digite o número do autômato: "
            read num
            if [ -f "automatos/executar${num}.c" ]; then
                gerar_automato "$num"
            else
                echo -e "${RED}Autômato $num não encontrado!${NC}"
            fi
            ;;
        3)
            gerar_manual
            ;;
        4)
            echo -e "\n${BLUE}Autômatos disponíveis:${NC}"
            for arquivo in automatos/executar*.c; do
                if [ -f "$arquivo" ]; then
                    NUM=$(basename "$arquivo" | sed 's/executar//' | sed 's/.c//')
                    NOME=$(grep -E "//.*Nome:|/\*.*\*/" "$arquivo" 2>/dev/null | head -1 | sed 's/\/\/.*Nome://' | sed 's/\/\*//' | sed 's/\*\///' | xargs)
                    if [ -z "$NOME" ]; then
                        NOME="Autômato $NUM"
                    fi
                    echo "  $NUM - $NOME"
                fi
            done
            ;;
        5)
            echo -e "\n${BLUE}Testando arquivos JFLAP...${NC}"
            for arquivo in jff_gerados/*.jff; do
                if [ -f "$arquivo" ]; then
                    echo -e "\n${YELLOW}▶ $(basename $arquivo)${NC}"
                    testar_arquivo "$arquivo"
                fi
            done
            ;;
        6)
            rm -f jff_gerados/*.jff
            echo -e "${GREEN}Arquivos JFLAP limpos!${NC}"
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

# Criar diretório
mkdir -p jff_gerados

# Iniciar menu
menu