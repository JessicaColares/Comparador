#!/bin/bash

# =============================================
# ANALISADOR COMPLETO DE COMPLEXIDADE CICLOMÁTICA
# Versão Corrigida - Sem códigos ANSI nos relatórios
# =============================================

echo "=============================================="
echo "  ANÁLISE DE COMPLEXIDADE CICLOMÁTICA"
echo "  Método: Grafo de Fluxo + Testes Unitários"
echo "=============================================="
echo ""

# Cores para terminal (apenas display)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Criar diretórios
mkdir -p analise_complexidade
mkdir -p grafos_gerados

# =============================================
# FUNÇÃO: CLASSIFICAR COMPLEXIDADE
# =============================================
classificar_complexidade() {
    local COMP=$1
    
    if [ $COMP -le 5 ]; then
        CLASSE="Baixa"
        STATUS="Bom"
        COR="${GREEN}"
        RECOMENDACAO="Código simples e fácil de testar"
    elif [ $COMP -le 10 ]; then
        CLASSE="Média"
        STATUS="Aceitável"
        COR="${YELLOW}"
        RECOMENDACAO="Pode precisar de refatoração futura"
    elif [ $COMP -le 15 ]; then
        CLASSE="Alta"
        STATUS="Precisa refatorar"
        COR="${RED}"
        RECOMENDACAO="Recomenda-se dividir o código em funções menores"
    else
        CLASSE="Muito Alta"
        STATUS="Urgente refatorar"
        COR="${RED}"
        RECOMENDACAO="Código muito complexo, precisa de refatoração imediata"
    fi
    
    # Para o relatório (sem cores)
    CLASSE_REL="$CLASSE - $STATUS"
    
    echo "$CLASSE_REL|$RECOMENDACAO|$COR"
}

# =============================================
# FUNÇÃO: ANALISAR CÓDIGO
# =============================================
analisar_codigo() {
    local ARQUIVO=$1
    local NUM=$2
    local NOME=$3
    
    echo -e "\n${YELLOW}═══════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}  ANALISANDO: $NOME${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════════${NC}"
    
    # =============================================
    # 1. EXTRAIR ESTRUTURA DE CONTROLE
    # =============================================
    echo -e "\n${BLUE}▶ 1. ESTRUTURA DE CONTROLE${NC}"
    echo "----------------------------------------"
    
    # Contar estruturas
    local IF_COUNT=$(grep -c "\<if\>" "$ARQUIVO" 2>/dev/null)
    local ELSE_COUNT=$(grep -c "\<else\>" "$ARQUIVO" 2>/dev/null)
    local ELSE_IF_COUNT=$(grep -c "\<else if\>" "$ARQUIVO" 2>/dev/null)
    local WHILE_COUNT=$(grep -c "\<while\>" "$ARQUIVO" 2>/dev/null)
    local FOR_COUNT=$(grep -c "\<for\>" "$ARQUIVO" 2>/dev/null)
    local DO_COUNT=$(grep -c "\<do\>" "$ARQUIVO" 2>/dev/null)
    local SWITCH_COUNT=$(grep -c "\<switch\>" "$ARQUIVO" 2>/dev/null)
    local CASE_COUNT=$(grep -c "\<case\>" "$ARQUIVO" 2>/dev/null)
    local RETURN_COUNT=$(grep -c "\<return\>" "$ARQUIVO" 2>/dev/null)
    
    echo "   if: $IF_COUNT"
    echo "   else: $ELSE_COUNT"
    echo "   else if: $ELSE_IF_COUNT"
    echo "   while: $WHILE_COUNT"
    echo "   for: $FOR_COUNT"
    echo "   do-while: $DO_COUNT"
    echo "   switch: $SWITCH_COUNT"
    echo "   case: $CASE_COUNT"
    echo "   return: $RETURN_COUNT"
    
    # =============================================
    # 2. CALCULAR COMPLEXIDADE CICLOMÁTICA
    # =============================================
    echo -e "\n${BLUE}▶ 2. COMPLEXIDADE CICLOMÁTICA${NC}"
    echo "----------------------------------------"
    
    # Método 1: P + 1 (nós de decisão + 1)
    # P = número de predicados (if, while, for, case, etc.)
    local P=$((IF_COUNT + ELSE_IF_COUNT + WHILE_COUNT + FOR_COUNT + DO_COUNT + CASE_COUNT))
    local COMPLEXIDADE=$((P + 1))
    
    echo "   Método 1 (P + 1): $COMPLEXIDADE"
    echo "   → Complexidade Ciclomática: $COMPLEXIDADE"
    
    # Classificar
    local CLASSIFICACAO=$(classificar_complexidade $COMPLEXIDADE)
    local CLASSE_REL=$(echo "$CLASSIFICACAO" | cut -d'|' -f1)
    local RECOMENDACAO=$(echo "$CLASSIFICACAO" | cut -d'|' -f2)
    local COR=$(echo "$CLASSIFICACAO" | cut -d'|' -f3)
    
    echo -e "   Classificação: ${COR}${CLASSE_REL}${NC}"
    echo "   Recomendação: $RECOMENDACAO"
    
    # =============================================
    # 3. GERAR CASOS DE TESTE (CORRIGIDO)
    # =============================================
    echo -e "\n${BLUE}▶ 3. CASOS DE TESTE NECESSÁRIOS${NC}"
    echo "----------------------------------------"
    echo "   Total de caminhos independentes: $COMPLEXIDADE"
    echo ""
    
    # Gerar casos baseados na complexidade
    local CASO=1
    
    # Se tem if, gerar casos para if/else
    if [ $IF_COUNT -gt 0 ]; then
        echo "   Caso $CASO: if falso (não entra)"
        CASO=$((CASO+1))
        
        # Para cada if, gerar caso verdadeiro
        for ((i=1; i<=$IF_COUNT; i++)); do
            echo "   Caso $CASO: if $i verdadeiro (entra)"
            CASO=$((CASO+1))
        done
    fi
    
    # Se tem else if, gerar casos
    if [ $ELSE_IF_COUNT -gt 0 ]; then
        for ((i=1; i<=$ELSE_IF_COUNT; i++)); do
            echo "   Caso $CASO: else if $i verdadeiro"
            CASO=$((CASO+1))
        done
    fi
    
    # Se tem loops, gerar casos para cada loop
    local TOTAL_LOOPS=$((WHILE_COUNT + FOR_COUNT + DO_COUNT))
    if [ $TOTAL_LOOPS -gt 0 ]; then
        for ((i=1; i<=$TOTAL_LOOPS; i++)); do
            echo "   Caso $CASO: Loop $i - não executa"
            CASO=$((CASO+1))
            echo "   Caso $CASO: Loop $i - executa"
            CASO=$((CASO+1))
        done
    fi
    
    # Ajustar se geramos mais casos que a complexidade
    local TOTAL_CASOS=$((CASO-1))
    if [ $TOTAL_CASOS -gt $COMPLEXIDADE ]; then
        echo ""
        echo -e "   ${YELLOW}⚠ Nota: Foram identificados $TOTAL_CASOS possíveis caminhos,"
        echo "   mas a complexidade ciclomática é $COMPLEXIDADE."
        echo "   Os casos de teste devem cobrir os $COMPLEXIDADE caminhos independentes.${NC}"
    fi
    
    # =============================================
    # 4. GERAR GRAFO DE FLUXO (DOT)
    # =============================================
    echo -e "\n${BLUE}▶ 4. GERANDO GRAFO DE FLUXO${NC}"
    echo "----------------------------------------"
    
    local GRAFO_DOT="grafos_gerados/grafo_${NUM}.dot"
    local GRAFO_PNG="grafos_gerados/grafo_${NUM}.png"
    
    # Número de nós baseado na complexidade
    local NUM_NOS=$((COMPLEXIDADE * 2 + 2))
    if [ $NUM_NOS -lt 4 ]; then
        NUM_NOS=4
    fi
    if [ $NUM_NOS -gt 20 ]; then
        NUM_NOS=20
    fi
    
    # Criar arquivo DOT
    cat > "$GRAFO_DOT" << EOF
digraph GrafoFluxo_$NUM {
    node [shape=box, style=filled, fillcolor=lightblue];
    edge [color=blue];
    
    // Nós do grafo de fluxo
    N0 [label="Início"];
EOF

    # Adicionar nós baseados nas estruturas
    local NODE_ID=1
    
    # Nós para estruturas de controle
    for ((i=1; i<=$IF_COUNT; i++)); do
        if [ $i -le $NUM_NOS ]; then
            cat >> "$GRAFO_DOT" << EOF
    N$NODE_ID [label="if $i"];
EOF
            NODE_ID=$((NODE_ID+1))
        fi
    done
    
    for ((i=1; i<=$WHILE_COUNT; i++)); do
        if [ $NODE_ID -lt $NUM_NOS ]; then
            cat >> "$GRAFO_DOT" << EOF
    N$NODE_ID [label="while $i"];
EOF
            NODE_ID=$((NODE_ID+1))
        fi
    done
    
    for ((i=1; i<=$FOR_COUNT; i++)); do
        if [ $NODE_ID -lt $NUM_NOS ]; then
            cat >> "$GRAFO_DOT" << EOF
    N$NODE_ID [label="for $i"];
EOF
            NODE_ID=$((NODE_ID+1))
        fi
    done
    
    # Adicionar nós de processo
    while [ $NODE_ID -lt $((NUM_NOS-1)) ]; do
        cat >> "$GRAFO_DOT" << EOF
    N$NODE_ID [label="Processo"];
EOF
        NODE_ID=$((NODE_ID+1))
    done
    
    cat >> "$GRAFO_DOT" << EOF
    N$NODE_ID [label="Fim"];
    
    // Transições
EOF

    # Adicionar transições
    for ((i=0; i<$NODE_ID; i++)); do
        local TO=$((i+1))
        echo "    N$i -> N$TO;" >> "$GRAFO_DOT"
    done
    
    # Adicionar transições de retorno para loops
    if [ $WHILE_COUNT -gt 0 ] || [ $FOR_COUNT -gt 0 ] || [ $DO_COUNT -gt 0 ]; then
        echo "    N1 -> N2 [label=\"loop\", color=red];" >> "$GRAFO_DOT"
    fi
    
    # Adicionar transições de decisão
    if [ $IF_COUNT -gt 0 ]; then
        echo "    N0 -> N1 [label=\"if\", color=green];" >> "$GRAFO_DOT"
        if [ $NODE_ID -gt 2 ]; then
            echo "    N1 -> N$((NODE_ID-1)) [label=\"else\", color=green];" >> "$GRAFO_DOT"
        fi
    fi
    
    cat >> "$GRAFO_DOT" << EOF
}
EOF

    echo -e "${GREEN}✓ Grafo gerado: $GRAFO_DOT${NC}"
    
    # Gerar PNG com Graphviz
    if command -v dot &> /dev/null; then
        dot -Tpng "$GRAFO_DOT" -o "$GRAFO_PNG" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ Imagem gerada: $GRAFO_PNG${NC}"
        else
            echo -e "${YELLOW}⚠ Não foi possível gerar a imagem${NC}"
        fi
    else
        echo -e "${YELLOW}⚠ Graphviz não instalado.${NC}"
    fi
    
    # =============================================
    # 5. GERAR RELATÓRIO (SEM CORES ANSI)
    # =============================================
    local RELATORIO="analise_complexidade/relatorio_${NUM}.md"
    
    cat > "$RELATORIO" << EOF
# Relatório de Análise - $NOME

## Dados Gerais
- **Arquivo:** executar${NUM}.c
- **Data:** $(date)

## Estrutura de Controle
- if: $IF_COUNT
- else: $ELSE_COUNT
- else if: $ELSE_IF_COUNT
- while: $WHILE_COUNT
- for: $FOR_COUNT
- do-while: $DO_COUNT
- switch: $SWITCH_COUNT
- case: $CASE_COUNT
- return: $RETURN_COUNT

## Complexidade Ciclomática
- **Valor:** $COMPLEXIDADE
- **Classificação:** $CLASSE_REL
- **Recomendação:** $RECOMENDACAO

## Caminhos Independentes
Total de caminhos: $COMPLEXIDADE

### Casos de Teste Sugeridos
EOF

    # Adicionar casos de teste ao relatório (sem duplicação)
    CASO=1
    if [ $IF_COUNT -gt 0 ]; then
        echo "- **Caso $CASO:** if falso (não entra)" >> "$RELATORIO"
        CASO=$((CASO+1))
        for ((i=1; i<=$IF_COUNT; i++)); do
            echo "- **Caso $CASO:** if $i verdadeiro" >> "$RELATORIO"
            CASO=$((CASO+1))
        done
    fi
    
    if [ $ELSE_IF_COUNT -gt 0 ]; then
        for ((i=1; i<=$ELSE_IF_COUNT; i++)); do
            echo "- **Caso $CASO:** else if $i verdadeiro" >> "$RELATORIO"
            CASO=$((CASO+1))
        done
    fi
    
    if [ $TOTAL_LOOPS -gt 0 ]; then
        for ((i=1; i<=$TOTAL_LOOPS; i++)); do
            echo "- **Caso $CASO:** Loop $i - não executa" >> "$RELATORIO"
            CASO=$((CASO+1))
            echo "- **Caso $CASO:** Loop $i - executa" >> "$RELATORIO"
            CASO=$((CASO+1))
        done
    fi

    cat >> "$RELATORIO" << EOF

## Grafo de Fluxo
- Arquivo DOT: \`grafos_gerados/grafo_${NUM}.dot\`
- Imagem: \`grafos_gerados/grafo_${NUM}.png\`

## Resumo
A complexidade ciclomática de **$COMPLEXIDADE** indica que o código possui **$COMPLEXIDADE** caminhos independentes.
Para alcançar 100% de cobertura, são necessários pelo menos **$COMPLEXIDADE** casos de teste.

**$RECOMENDACAO**
EOF

    echo -e "${GREEN}✓ Relatório gerado: $RELATORIO${NC}"
    
    # Mostrar resumo
    echo -e "\n${BLUE}▶ RESUMO DA ANÁLISE${NC}"
    echo "----------------------------------------"
    echo -e "   Complexidade Ciclomática: ${GREEN}$COMPLEXIDADE${NC}"
    echo -e "   Classificação: ${COR}${CLASSE_REL}${NC}"
    echo -e "   Caminhos independentes: ${GREEN}$COMPLEXIDADE${NC}"
    echo -e "   Casos de teste necessários: ${GREEN}$COMPLEXIDADE${NC}"
}

# =============================================
# FUNÇÃO: GERAR RELATÓRIO COMPLETO
# =============================================
gerar_relatorio_completo() {
    local RELATORIO="analise_complexidade/RELATORIO_COMPLETO.md"
    
    cat > "$RELATORIO" << 'EOF'
# RELATÓRIO COMPLETO DE ANÁLISE DE COMPLEXIDADE

## Metodologia

Baseado na abordagem apresentada nos slides "IARTES-VV&T-04-MétodosEstruturadosValidação-03-teste-unitario-Junit-ComplexGraph":

1. **Análise Estrutural**: Identificação de todas as estruturas de controle
2. **Cálculo da Complexidade Ciclomática**: Usando o método P + 1
3. **Geração do Grafo de Fluxo**: Visualização dos caminhos possíveis
4. **Identificação de Casos de Teste**: Baseados nos caminhos independentes

## Classificação de Complexidade

| Complexidade | Classificação | Ação Recomendada |
|--------------|---------------|------------------|
| 1-5 | Baixa | Código simples, fácil de testar |
| 6-10 | Média | Aceitável, pode refatorar |
| 11-15 | Alta | Precisa refatorar |
| > 15 | Muito Alta | Refatoração urgente |

## Resultados por Autômato

EOF

    # Ordenar arquivos por número
    for arquivo in $(ls analise_complexidade/relatorio_*.md 2>/dev/null | sort -V); do
        if [ -f "$arquivo" ]; then
            NUM=$(basename "$arquivo" | sed 's/relatorio_//' | sed 's/.md//')
            # Extrair informações
            COMPLEXIDADE=$(grep -E "^\*\*Valor:\*\*" "$arquivo" | grep -o "[0-9]\+" | head -1)
            CLASSE=$(grep -E "^\*\*Classificação:\*\*" "$arquivo" | sed 's/^\*\*Classificação:\*\* //')
            
            if [ -z "$COMPLEXIDADE" ]; then
                COMPLEXIDADE="N/A"
            fi
            if [ -z "$CLASSE" ]; then
                CLASSE="N/A"
            fi
            
            echo "### Autômato $NUM" >> "$RELATORIO"
            echo "- **Complexidade:** $COMPLEXIDADE" >> "$RELATORIO"
            echo "- **Classificação:** $CLASSE" >> "$RELATORIO"
            echo "" >> "$RELATORIO"
        fi
    done

    # Adicionar resumo estatístico
    cat >> "$RELATORIO" << 'EOF'

## Resumo Estatístico

EOF

    # Calcular média
    local SOMA=0
    local CONT=0
    for arquivo in $(ls analise_complexidade/relatorio_*.md 2>/dev/null | sort -V); do
        if [ -f "$arquivo" ]; then
            COMP=$(grep -E "^\*\*Valor:\*\*" "$arquivo" | grep -o "[0-9]\+" | head -1)
            if [ -n "$COMP" ]; then
                SOMA=$((SOMA + COMP))
                CONT=$((CONT + 1))
            fi
        fi
    done

    if [ $CONT -gt 0 ]; then
        MEDIA=$((SOMA / CONT))
        echo "- **Total de autômatos analisados:** $CONT" >> "$RELATORIO"
        echo "- **Complexidade média:** $MEDIA" >> "$RELATORIO"
        echo "- **Complexidade mínima:** $(ls analise_complexidade/relatorio_*.md 2>/dev/null | xargs grep -E "^\*\*Valor:\*\*" | grep -o "[0-9]\+" | sort -n | head -1)" >> "$RELATORIO"
        echo "- **Complexidade máxima:** $(ls analise_complexidade/relatorio_*.md 2>/dev/null | xargs grep -E "^\*\*Valor:\*\*" | grep -o "[0-9]\+" | sort -n | tail -1)" >> "$RELATORIO"
    fi

    echo -e "\n${GREEN}✓ Relatório completo gerado: $RELATORIO${NC}"
}

# =============================================
# MENU PRINCIPAL
# =============================================
menu() {
    echo ""
    echo -e "${BLUE}=============================================${NC}"
    echo -e "${BLUE}  ANÁLISE DE COMPLEXIDADE CICLOMÁTICA${NC}"
    echo -e "${BLUE}  Baseado na metodologia dos slides${NC}"
    echo -e "${BLUE}=============================================${NC}"
    echo ""
    echo "1) Analisar UM autômato específico"
    echo "2) Analisar TODOS os autômatos"
    echo "3) Gerar relatório completo"
    echo "4) Visualizar grafos (requer Graphviz)"
    echo "5) Limpar análises"
    echo "0) Sair"
    echo ""
    echo -n "Escolha uma opção: "
    read opcao
    
    case $opcao in
        1)
            echo -n "Digite o número do autômato: "
            read num
            if [ -f "automatos/executar${num}.c" ]; then
                NOME=$(grep -E "//.*Nome:|/\*.*\*/" "automatos/executar${num}.c" 2>/dev/null | head -1 | sed 's/\/\/.*Nome://' | sed 's/\/\*//' | sed 's/\*\///' | xargs)
                if [ -z "$NOME" ]; then
                    NOME="Autômato $num"
                fi
                analisar_codigo "automatos/executar${num}.c" "$num" "$NOME"
            else
                echo -e "${RED}Autômato $num não encontrado!${NC}"
            fi
            ;;
        2)
            echo -e "\n${GREEN}Analisando TODOS os autômatos...${NC}"
            for arquivo in automatos/executar*.c; do
                if [ -f "$arquivo" ]; then
                    NUM=$(basename "$arquivo" | sed 's/executar//' | sed 's/.c//')
                    NOME=$(grep -E "//.*Nome:|/\*.*\*/" "$arquivo" 2>/dev/null | head -1 | sed 's/\/\/.*Nome://' | sed 's/\/\*//' | sed 's/\*\///' | xargs)
                    if [ -z "$NOME" ]; then
                        NOME="Autômato $NUM"
                    fi
                    analisar_codigo "$arquivo" "$NUM" "$NOME"
                fi
            done
            gerar_relatorio_completo
            echo -e "\n${GREEN}✓ Análise completa!${NC}"
            ;;
        3)
            gerar_relatorio_completo
            ;;
        4)
            if command -v dot &> /dev/null; then
                echo -e "\n${BLUE}Grafos gerados:${NC}"
                ls -la grafos_gerados/*.png 2>/dev/null | awk '{print "  " $9}'
                echo ""
                echo "Para visualizar:"
                echo "  eog grafos_gerados/grafo_*.png  # Linux"
                echo "  open grafos_gerados/grafo_*.png # macOS"
            else
                echo -e "${YELLOW}Graphviz não instalado.${NC}"
            fi
            ;;
        5)
            rm -rf analise_complexidade grafos_gerados
            mkdir -p analise_complexidade grafos_gerados
            echo -e "${GREEN}Análises limpas!${NC}"
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

# Criar diretórios
mkdir -p analise_complexidade grafos_gerados

# Iniciar
menu