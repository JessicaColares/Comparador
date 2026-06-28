#!/bin/bash

# =============================================
# ANALISADOR COMPLETO - FERRAMENTAS UNIFICADAS
# =============================================

echo "=============================================="
echo "  ANALISADOR COMPLETO DE AUTÔMATOS"
echo "  Ferramentas: Complexidade + Testes + JFLAP"
echo "=============================================="
echo ""

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Criar diretórios organizados
mkdir -p analise_complexidade
mkdir -p grafos_gerados
mkdir -p jff_gerados
mkdir -p resultados_automatos
mkdir -p plists
mkdir -p spin_temp

# =============================================
# FUNÇÃO: ANALISAR COMPLEXIDADE E GERAR JFLAP
# =============================================
analisar_automato() {
    local NUM=$1
    local ARQUIVO="automatos/executar${NUM}.c"
    
    if [ ! -f "$ARQUIVO" ]; then
        echo -e "${RED}❌ Autômato $NUM não encontrado${NC}"
        return 1
    fi
    
    local NOME=$(grep -E "//.*Nome:|/\*.*\*/" "$ARQUIVO" 2>/dev/null | head -1 | sed 's/\/\/.*Nome://' | sed 's/\/\*//' | sed 's/\*\///' | xargs)
    [ -z "$NOME" ] && NOME="Autômato $NUM"
    
    echo -e "\n${YELLOW}═══════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}  ANALISANDO: $NOME${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════════${NC}"
    
    # =============================================
    # 1. EXTRAIR ESTRUTURA
    # =============================================
    local IF_COUNT=$(grep -c "\<if\>" "$ARQUIVO" 2>/dev/null)
    local ELSE_COUNT=$(grep -c "\<else\>" "$ARQUIVO" 2>/dev/null)
    local ELSE_IF_COUNT=$(grep -c "\<else if\>" "$ARQUIVO" 2>/dev/null)
    local WHILE_COUNT=$(grep -c "\<while\>" "$ARQUIVO" 2>/dev/null)
    local FOR_COUNT=$(grep -c "\<for\>" "$ARQUIVO" 2>/dev/null)
    local DO_COUNT=$(grep -c "\<do\>" "$ARQUIVO" 2>/dev/null)
    
    echo -e "\n${BLUE}▶ ESTRUTURA DE CONTROLE${NC}"
    echo "  if: $IF_COUNT, else: $ELSE_COUNT, while: $WHILE_COUNT, for: $FOR_COUNT"
    
    # =============================================
    # 2. COMPLEXIDADE CICLOMÁTICA
    # =============================================
    local P=$((IF_COUNT + ELSE_IF_COUNT + WHILE_COUNT + FOR_COUNT + DO_COUNT))
    local COMPLEXIDADE=$((P + 1))
    
    # Classificação
    if [ $COMPLEXIDADE -le 5 ]; then
        CLASSE="Baixa - Bom"
        COR="${GREEN}"
    elif [ $COMPLEXIDADE -le 10 ]; then
        CLASSE="Média - Aceitável"
        COR="${YELLOW}"
    elif [ $COMPLEXIDADE -le 15 ]; then
        CLASSE="Alta - Precisa refatorar"
        COR="${RED}"
    else
        CLASSE="Muito Alta - Urgente refatorar"
        COR="${RED}"
    fi
    
    echo -e "\n${BLUE}▶ COMPLEXIDADE CICLOMÁTICA${NC}"
    echo -e "  Valor: ${GREEN}$COMPLEXIDADE${NC}"
    echo -e "  Classificação: ${COR}$CLASSE${NC}"
    
    # =============================================
    # 3. GERAR CASOS DE TESTE COM VALORES
    # =============================================
    echo -e "\n${BLUE}▶ CASOS DE TESTE SUGERIDOS${NC}"
    echo "  Total de caminhos: $COMPLEXIDADE"
    echo ""
    
    local CASO=1
    local VALORES=()
    
    # Gerar valores baseados na estrutura
    if [ $IF_COUNT -gt 0 ]; then
        echo "  Caso $CASO: if falso → a=10, b=5 (não entra)"
        VALORES+=("10,5,0")
        CASO=$((CASO+1))
        
        echo "  Caso $CASO: if verdadeiro → a=5, b=10 (entra)"
        VALORES+=("5,10,1")
        CASO=$((CASO+1))
    fi
    
    if [ $WHILE_COUNT -gt 0 ]; then
        echo "  Caso $CASO: while não executa → a=10, b=5"
        VALORES+=("10,5,0")
        CASO=$((CASO+1))
        
        echo "  Caso $CASO: while executa → a=5, b=10"
        VALORES+=("5,10,1")
        CASO=$((CASO+1))
    fi
    
    # Se tiver if aninhados, gerar mais casos
    if [ $IF_COUNT -gt 1 ]; then
        echo "  Caso $CASO: if aninhado → a=3, b=10"
        VALORES+=("3,10,1")
        CASO=$((CASO+1))
    fi
    
    # =============================================
    # 4. GERAR GRAFO DE FLUXO (DOT)
    # =============================================
    echo -e "\n${BLUE}▶ GERANDO GRAFO DE FLUXO${NC}"
    
    local GRAFO_DOT="grafos_gerados/grafo_${NUM}.dot"
    local GRAFO_PNG="grafos_gerados/grafo_${NUM}.png"
    
    cat > "$GRAFO_DOT" << EOF
digraph GrafoFluxo_$NUM {
    node [shape=box, style=filled, fillcolor=lightblue];
    edge [color=blue];
    
    // Nós do grafo
    N0 [label="Início"];
EOF

    # Adicionar nós baseados nas estruturas
    local NODE_ID=1
    
    for ((i=1; i<=$IF_COUNT; i++)); do
        cat >> "$GRAFO_DOT" << EOF
    N$NODE_ID [label="if $i"];
EOF
        NODE_ID=$((NODE_ID+1))
    done
    
    for ((i=1; i<=$WHILE_COUNT; i++)); do
        cat >> "$GRAFO_DOT" << EOF
    N$NODE_ID [label="while $i"];
EOF
        NODE_ID=$((NODE_ID+1))
    done
    
    cat >> "$GRAFO_DOT" << EOF
    N$NODE_ID [label="Fim"];
    
    // Transições
EOF

    # Adicionar transições
    for ((i=0; i<$NODE_ID; i++)); do
        echo "    N$i -> N$((i+1));" >> "$GRAFO_DOT"
    done
    
    # Adicionar transições de retorno para loops
    if [ $WHILE_COUNT -gt 0 ]; then
        echo "    N1 -> N2 [label=\"loop\", color=red];" >> "$GRAFO_DOT"
    fi
    
    cat >> "$GRAFO_DOT" << EOF
}
EOF

    # Gerar PNG
    if command -v dot &> /dev/null; then
        dot -Tpng "$GRAFO_DOT" -o "$GRAFO_PNG" 2>/dev/null
        echo -e "  ${GREEN}✓ Grafo gerado: $GRAFO_PNG${NC}"
    else
        echo -e "  ${YELLOW}⚠ Graphviz não instalado${NC}"
    fi
    
    # =============================================
    # 5. GERAR JFLAP COM CAMINHOS DE TESTE
    # =============================================
    echo -e "\n${BLUE}▶ GERANDO JFLAP COM CAMINHOS DE TESTE${NC}"
    
    local JFLAP_OUTPUT="jff_gerados/automato_${NUM}.jff"
    
    cat > "$JFLAP_OUTPUT" << 'EOF'
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!--Created with JFLAP 7.1.-->
EOF

    cat >> "$JFLAP_OUTPUT" << EOF
<!-- Autômato: $NOME (executar${NUM}.c) -->
<!-- Complexidade: $COMPLEXIDADE -->
<structure>
	<type>fa</type>
	<automaton>
		<!--The list of states.-->
EOF

    # Calcular número de estados
    local NUM_ESTADOS=$((COMPLEXIDADE + 2))
    [ $NUM_ESTADOS -lt 3 ] && NUM_ESTADOS=3
    [ $NUM_ESTADOS -gt 10 ] && NUM_ESTADOS=10
    
    # Gerar estados
    for ((i=0; i<$NUM_ESTADOS; i++)); do
        local X=$((80 + i * 70))
        local Y=150
        
        local INITIAL=""
        local FINAL=""
        local LABEL=""
        
        if [ $i -eq 0 ]; then
            INITIAL="<initial/>"
            LABEL="Início"
        elif [ $i -eq $((NUM_ESTADOS-1)) ]; then
            FINAL="<final/>"
            LABEL="Fim"
        elif [ $i -le $IF_COUNT ]; then
            LABEL="if $i"
        elif [ $i -le $((IF_COUNT + WHILE_COUNT)) ]; then
            LABEL="loop $((i-IF_COUNT))"
        else
            LABEL="q$i"
        fi
        
        cat >> "$JFLAP_OUTPUT" << EOF
		<state id="$i" name="q$i">
			<x>$X.0</x>
			<y>$Y.0</y>
			$INITIAL
			$FINAL
EOF
        if [ -n "$LABEL" ]; then
            cat >> "$JFLAP_OUTPUT" << EOF
			<label x="$X.0" y="$((Y-20)).0">$LABEL</label>
EOF
        fi
        cat >> "$JFLAP_OUTPUT" << EOF
		</state>
EOF
    done

    # Transições com símbolos de teste
    cat >> "$JFLAP_OUTPUT" << 'EOF'
		<!--The list of transitions.-->
EOF

    # Adicionar transições com valores de teste
    local TRANS_INDEX=0
    for val in "${VALORES[@]}"; do
        local A=$(echo $val | cut -d',' -f1)
        local B=$(echo $val | cut -d',' -f2)
        local RES=$(echo $val | cut -d',' -f3)
        
        local FROM=$TRANS_INDEX
        local TO=$((TRANS_INDEX + 1))
        
        if [ $TO -ge $NUM_ESTADOS ]; then
            TO=$((NUM_ESTADOS-1))
        fi
        
        cat >> "$JFLAP_OUTPUT" << EOF
		<transition>
			<from>$FROM</from>
			<to>$TO</to>
			<read>a=$A,b=$B</read>
			<label>Teste $((TRANS_INDEX+1)): $RES</label>
		</transition>
EOF
        TRANS_INDEX=$((TRANS_INDEX + 1))
    done

    # Transição final
    cat >> "$JFLAP_OUTPUT" << EOF
		<transition>
			<from>$((NUM_ESTADOS-2))</from>
			<to>$((NUM_ESTADOS-1))</to>
			<read>fim</read>
			<label>Saída</label>
		</transition>
EOF

    cat >> "$JFLAP_OUTPUT" << 'EOF'
	</automaton>
</structure>
EOF

    echo -e "  ${GREEN}✓ JFLAP gerado: $JFLAP_OUTPUT${NC}"
    echo -e "  ${BLUE}ℹ Os símbolos nas transições mostram os valores de teste${NC}"
    
    # =============================================
    # 6. GERAR RELATÓRIO
    # =============================================
    local RELATORIO="analise_complexidade/relatorio_${NUM}.md"
    
    cat > "$RELATORIO" << EOF
# Relatório de Análise - $NOME

## Dados Gerais
- **Arquivo:** executar${NUM}.c
- **Data:** $(date)

## Complexidade Ciclomática
- **Valor:** $COMPLEXIDADE
- **Classificação:** $CLASSE

## Estrutura de Controle
- if: $IF_COUNT
- else: $ELSE_COUNT
- while: $WHILE_COUNT
- for: $FOR_COUNT
- do-while: $DO_COUNT

## Casos de Teste Sugeridos
EOF

    local CT=1
    for val in "${VALORES[@]}"; do
        local A=$(echo $val | cut -d',' -f1)
        local B=$(echo $val | cut -d',' -f2)
        local RES=$(echo $val | cut -d',' -f3)
        echo "- **Caso $CT:** a=$A, b=$B → resultado esperado: $RES" >> "$RELATORIO"
        CT=$((CT+1))
    done

    cat >> "$RELATORIO" << EOF

## Grafo de Fluxo
- Imagem: \`grafos_gerados/grafo_${NUM}.png\`

## JFLAP
- Arquivo: \`jff_gerados/automato_${NUM}.jff\`
- **Os símbolos nas transições mostram os valores de teste**
- Para testar caminhos no JFLAP:
  1. Abra o arquivo .jff no JFLAP
  2. Use "Input → Multiple Run" ou "Input → Step"
  3. Digite os valores mostrados nas transições
  4. Veja se o autômato aceita ou rejeita

## Resumo
Complexidade $COMPLEXIDADE - $CLASSE
EOF

    echo -e "  ${GREEN}✓ Relatório gerado: $RELATORIO${NC}"
    
    # =============================================
    # 7. GERAR PLIST
    # =============================================
    cat > "plists/executar${NUM}.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Automato</key>
	<string>$NUM</string>
	<key>Nome</key>
	<string>$NOME</string>
	<key>Complexidade</key>
	<integer>$COMPLEXIDADE</integer>
	<key>Classificacao</key>
	<string>$CLASSE</string>
	<key>CasosTeste</key>
	<array>
EOF

    for val in "${VALORES[@]}"; do
        local A=$(echo $val | cut -d',' -f1)
        local B=$(echo $val | cut -d',' -f2)
        local RES=$(echo $val | cut -d',' -f3)
        cat >> "plists/executar${NUM}.plist" << EOF
		<dict>
			<key>a</key>
			<integer>$A</integer>
			<key>b</key>
			<integer>$B</integer>
			<key>resultado</key>
			<integer>$RES</integer>
		</dict>
EOF
    done

    cat >> "plists/executar${NUM}.plist" << EOF
	</array>
</dict>
</plist>
EOF

    echo -e "  ${GREEN}✓ PLIST gerado: plists/executar${NUM}.plist${NC}"
}

# =============================================
# FUNÇÃO: TESTAR CAMINHOS NO JFLAP
# =============================================
testar_caminhos_jflap() {
    echo -e "\n${BLUE}▶ TESTANDO CAMINHOS NO JFLAP${NC}"
    echo "  Para testar os caminhos:"
    echo "  1. Abra o JFLAP"
    echo "  2. File → Open → selecione o .jff"
    echo "  3. Input → Multiple Run"
    echo "  4. Digite os valores mostrados nas transições"
    echo ""
    echo "  Exemplo:"
    echo "  - Transição 'a=5,b=10' → digite '510' ou '5,10'"
    echo "  - Transição 'a=10,b=5' → digite '105' ou '10,5'"
    echo ""
    echo "  O JFLAP vai mostrar se o caminho é aceito ou rejeitado!"
}

# =============================================
# FUNÇÃO: LIMPAR ARQUIVOS TEMPORÁRIOS
# =============================================
limpar_temporarios() {
    echo -e "\n${BLUE}▶ LIMPANDO ARQUIVOS TEMPORÁRIOS${NC}"
    
    # Mover arquivos .plist para a pasta plists
    mv executar*.plist plists/ 2>/dev/null && echo "  ✓ .plist movidos para plists/"
    
    # Mover arquivos pan* para spin_temp
    mv pan.* spin_temp/ 2>/dev/null && echo "  ✓ pan.* movidos para spin_temp/"
    
    echo -e "  ${GREEN}✓ Limpeza concluída${NC}"
}

# =============================================
# MENU PRINCIPAL
# =============================================
menu() {
    echo ""
    echo -e "${BLUE}=============================================${NC}"
    echo -e "${BLUE}  ANALISADOR COMPLETO DE AUTÔMATOS${NC}"
    echo -e "${BLUE}=============================================${NC}"
    echo ""
    echo "1) Analisar UM autômato (completo)"
    echo "2) Analisar TODOS os autômatos"
    echo "3) Testar caminhos no JFLAP (instruções)"
    echo "4) Limpar e organizar arquivos"
    echo "5) Ver relatório completo"
    echo "0) Sair"
    echo ""
    echo -n "Escolha: "
    read opcao
    
    case $opcao in
        1)
            echo -n "Número do autômato: "
            read num
            analisar_automato "$num"
            ;;
        2)
            echo -e "\n${GREEN}Analisando TODOS os autômatos...${NC}"
            for arquivo in automatos/executar*.c; do
                if [ -f "$arquivo" ]; then
                    NUM=$(basename "$arquivo" | sed 's/executar//' | sed 's/.c//')
                    analisar_automato "$NUM"
                fi
            done
            echo -e "\n${GREEN}✓ Análise completa!${NC}"
            ;;
        3)
            testar_caminhos_jflap
            ;;
        4)
            limpar_temporarios
            ;;
        5)
            echo -e "\n${BLUE}Relatórios gerados:${NC}"
            ls -la analise_complexidade/*.md 2>/dev/null | awk '{print "  " $9}'
            echo ""
            cat analise_complexidade/RELATORIO_COMPLETO.md 2>/dev/null || echo "  Execute a análise primeiro"
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
    echo -n "Pressione Enter..."
    read
    menu
}

# Criar diretórios
mkdir -p plists spin_temp

# Iniciar
menu