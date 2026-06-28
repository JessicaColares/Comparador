#!/bin/bash

# =============================================
# CONFIGURADOR MULTI-SISTEMA OPERACIONAL
# =============================================

echo "=============================================="
echo "  CONFIGURANDO AMBIENTE PARA MÚLTIPLOS AUTÔMATOS"
echo "=============================================="

# Cores para output (funciona em Linux/Mac, limitado no Windows)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Desabilitar cores no Windows se não suportar
if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "win32" ]]; then
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    NC=''
fi

# =============================================
# DETECÇÃO DO SISTEMA OPERACIONAL
# =============================================
detectar_sistema() {
    echo -e "\n${BLUE}Detectando sistema operacional...${NC}"
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
        echo -e "   ${GREEN}✓ Sistema detectado: Linux${NC}"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        echo -e "   ${GREEN}✓ Sistema detectado: macOS${NC}"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "win32" ]]; then
        OS="windows"
        echo -e "   ${GREEN}✓ Sistema detectado: Windows (Git Bash / Cygwin)${NC}"
    else
        echo -e "   ${YELLOW}⚠ Sistema não detectado automaticamente${NC}"
        OS="unknown"
    fi
}

# =============================================
# MENU DE SELEÇÃO MANUAL
# =============================================
menu_sistema() {
    echo -e "\n${BLUE}=============================================${NC}"
    echo -e "${BLUE}  SELECIONE O SISTEMA OPERACIONAL${NC}"
    echo -e "${BLUE}=============================================${NC}"
    echo "1) Linux (Ubuntu/Debian)"
    echo "2) macOS (Homebrew)"
    echo "3) Windows (WSL - Recomendado)"
    echo "4) Windows (Git Bash / MSYS2 - Limitado)"
    echo "0) Sair"
    echo ""
    echo -n "Escolha uma opção: "
    read opcao
    
    case $opcao in
        1) OS="linux" ;;
        2) OS="macos" ;;
        3) OS="wsl" ;;
        4) OS="windows" ;;
        0) exit 0 ;;
        *) 
            echo -e "${RED}Opção inválida! Usando Linux como padrão${NC}"
            OS="linux"
            ;;
    esac
    
    echo -e "${GREEN}✓ Sistema selecionado: $OS${NC}"
}

# =============================================
# INSTALAÇÃO NO LINUX (Ubuntu/Debian)
# =============================================
instalar_linux() {
    echo -e "\n${BLUE}Instalando dependências para Linux...${NC}"
    echo "=============================================="
    
    # Atualizar repositórios
    echo -e "\n${YELLOW}▶ Atualizando repositórios...${NC}"
    sudo apt-get update -qq
    
    # CUnit
    echo -e "\n${YELLOW}▶ Instalando CUnit...${NC}"
    sudo apt-get install -y libcunit1 libcunit1-dev
    
    # Cppcheck
    echo -e "\n${YELLOW}▶ Instalando Cppcheck...${NC}"
    sudo apt-get install -y cppcheck
    
    # Valgrind
    echo -e "\n${YELLOW}▶ Instalando Valgrind...${NC}"
    sudo apt-get install -y valgrind
    
    # GCC
    echo -e "\n${YELLOW}▶ Instalando GCC...${NC}"
    sudo apt-get install -y gcc build-essential
    
    # Clang
    echo -e "\n${YELLOW}▶ Instalando Clang...${NC}"
    sudo apt-get install -y clang
    
    # SPIN
    echo -e "\n${YELLOW}▶ Instalando SPIN...${NC}"
    sudo apt-get install -y spin
    
    # Graphviz (para gerar imagens dos grafos)
    echo -e "\n${YELLOW}▶ Instalando Graphviz...${NC}"
    sudo apt-get install -y graphviz
    
    # gcov (para cobertura de código)
    echo -e "\n${YELLOW}▶ Instalando gcov...${NC}"
    sudo apt-get install -y gcov
    
    # lcov (para relatórios de cobertura)
    echo -e "\n${YELLOW}▶ Instalando lcov...${NC}"
    sudo apt-get install -y lcov
    
    echo -e "\n${GREEN}✓ Todas as ferramentas foram instaladas!${NC}"
}

# =============================================
# INSTALAÇÃO NO MACOS (Homebrew)
# =============================================
instalar_macos() {
    echo -e "\n${BLUE}Instalando dependências para macOS...${NC}"
    echo "=============================================="
    
    # Verificar Homebrew
    if ! command -v brew &> /dev/null; then
        echo -e "${YELLOW}⚠ Homebrew não encontrado. Instalando...${NC}"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    
    # CUnit
    echo -e "\n${YELLOW}▶ Instalando CUnit...${NC}"
    brew install cunit
    
    # Cppcheck
    echo -e "\n${YELLOW}▶ Instalando Cppcheck...${NC}"
    brew install cppcheck
    
    # Valgrind (pode não funcionar bem em versões recentes do macOS)
    echo -e "\n${YELLOW}▶ Instalando Valgrind...${NC}"
    brew install valgrind
    
    # GCC
    echo -e "\n${YELLOW}▶ Instalando GCC...${NC}"
    brew install gcc
    
    # Clang (já vem com Xcode Command Line Tools)
    echo -e "\n${YELLOW}▶ Verificando Clang...${NC}"
    if ! command -v clang &> /dev/null; then
        echo -e "   ${YELLOW}Instalando Xcode Command Line Tools...${NC}"
        xcode-select --install
    else
        echo -e "   ${GREEN}✓ Clang já instalado${NC}"
    fi
    
    # SPIN
    echo -e "\n${YELLOW}▶ Instalando SPIN...${NC}"
    brew install spin
    
    # Graphviz (para gerar imagens dos grafos)
    echo -e "\n${YELLOW}▶ Instalando Graphviz...${NC}"
    brew install graphviz
    
    # gcov (já vem com GCC)
    echo -e "\n${YELLOW}▶ Verificando gcov...${NC}"
    if ! command -v gcov &> /dev/null; then
        echo -e "   ${YELLOW}⚠ gcov pode não estar disponível separadamente${NC}"
        echo -e "   ${YELLOW}   Use gcov com o GCC instalado${NC}"
    else
        echo -e "   ${GREEN}✓ gcov disponível${NC}"
    fi
    
    # lcov
    echo -e "\n${YELLOW}▶ Instalando lcov...${NC}"
    brew install lcov
    
    echo -e "\n${GREEN}✓ Todas as ferramentas foram instaladas!${NC}"
    echo -e "${YELLOW}⚠ Nota: Valgrind pode ter limitações no macOS${NC}"
}

# =============================================
# INSTALAÇÃO NO WINDOWS (WSL - Recomendado)
# =============================================
instalar_wsl() {
    echo -e "\n${BLUE}Configurando para Windows via WSL...${NC}"
    echo "=============================================="
    echo -e "${YELLOW}⚠ Você está no WSL (Windows Subsystem for Linux)${NC}"
    echo -e "${YELLOW}⚠ Os comandos serão executados dentro do ambiente Ubuntu${NC}"
    
    # Verificar WSL
    if grep -q Microsoft /proc/version; then
        echo -e "${GREEN}✓ WSL detectado!${NC}"
        instalar_linux
    else
        echo -e "${RED}⚠ WSL não detectado. Instalando via MSYS2...${NC}"
        instalar_windows_msys
    fi
}

# =============================================
# INSTALAÇÃO NO WINDOWS (MSYS2/Git Bash - Limitado)
# =============================================
instalar_windows_msys() {
    echo -e "\n${BLUE}Instalando dependências para Windows (MSYS2/Git Bash)...${NC}"
    echo "=============================================="
    echo -e "${YELLOW}⚠ ATENÇÃO: A instalação no Windows nativo é LIMITADA${NC}"
    echo -e "${YELLOW}⚠ Recomenda-se usar WSL para experiência completa${NC}"
    echo ""
    
    # Verificar pacote manager
    if command -v pacman &> /dev/null; then
        echo -e "${GREEN}✓ Pacman detectado (MSYS2)${NC}"
        
        # Atualizar pacotes
        pacman -Syu --noconfirm
        
        # Instalar ferramentas básicas (limitadas)
        echo -e "\n${YELLOW}▶ Instalando GCC...${NC}"
        pacman -S --noconfirm mingw-w64-x86_64-gcc
        
        echo -e "\n${YELLOW}▶ Instalando Clang...${NC}"
        pacman -S --noconfirm mingw-w64-x86_64-clang
        
        # Graphviz (pode estar disponível no MSYS2)
        echo -e "\n${YELLOW}▶ Tentando instalar Graphviz...${NC}"
        pacman -S --noconfirm mingw-w64-x86_64-graphviz || echo -e "   ${YELLOW}⚠ Graphviz não disponível no MSYS2${NC}"
        
        echo -e "\n${YELLOW}⚠ CUnit, Cppcheck, Valgrind e SPIN podem não estar disponíveis${NC}"
        
    elif command -v choco &> /dev/null; then
        echo -e "${GREEN}✓ Chocolatey detectado${NC}"
        choco install gcc cppcheck graphviz -y
    else
        echo -e "${RED}⚠ Nenhum gerenciador de pacotes detectado${NC}"
        echo -e "${YELLOW}Para instalar as ferramentas manualmente:${NC}"
        echo "  1. Instale o WSL (Windows Subsystem for Linux)"
        echo "  2. Ou instale o MSYS2 (https://www.msys2.org/)"
        echo "  3. Ou instale o Chocolatey (https://chocolatey.org/)"
        echo ""
        echo -e "${YELLOW}Para Graphviz no Windows:${NC}"
        echo "  Baixe em: https://graphviz.org/download/"
    fi
    
    echo -e "\n${YELLOW}⚠ RECOMENDAÇÃO: Instale o WSL para melhor experiência${NC}"
    echo "   Comandos: wsl --install (no PowerShell como administrador)"
}

# =============================================
# VERIFICAÇÃO DO DIRETÓRIO
# =============================================
verificar_diretorio() {
    # No Windows/WSL, verificar caminhos alternativos
    if [ ! -d "Manual" ]; then
        if [ -d "../Manual" ]; then
            cd ..
        elif [ -d "../../Manual" ]; then
            cd ../..
        else
            echo -e "${RED}Erro: Diretório 'Manual' não encontrado!${NC}"
            echo "Execute este script do diretório Comparativo/"
            exit 1
        fi
    fi
    
    echo -e "${GREEN}✓ Diretório correto: $(pwd)${NC}"
}

# =============================================
# PERMISSÕES DOS SCRIPTS
# =============================================
configurar_permissoes() {
    echo -e "\n${BLUE}Configurando permissões dos scripts...${NC}"
    echo "=============================================="
    
    # No Windows, chmod pode não funcionar
    if [[ "$OS" != "windows" ]]; then
        chmod +x testar_multiplos_automatos.sh 2>/dev/null && echo -e "   ${GREEN}✓ testar_multiplos_automatos.sh${NC}"
        chmod +x analisar_ferramentas.sh 2>/dev/null && echo -e "   ${GREEN}✓ analisar_ferramentas.sh${NC}"
        chmod +x analisar_complexidade.sh 2>/dev/null && echo -e "   ${GREEN}✓ analisar_complexidade.sh${NC}"
        chmod +x gerar_jflap_automatos.sh 2>/dev/null && echo -e "   ${GREEN}✓ gerar_jflap_automatos.sh${NC}"
    else
        echo -e "   ${YELLOW}⚠ Permissões não configuradas (Windows)${NC}"
    fi
}

# =============================================
# VERIFICAÇÃO DE INSTALAÇÃO
# =============================================
verificar_instalacao() {
    echo -e "\n${BLUE}Verificando ferramentas instaladas...${NC}"
    echo "=============================================="
    
    local FERRAMENTAS=("gcc" "clang" "spin" "dot" "gcov" "lcov" "cppcheck" "valgrind")
    local INSTALADAS=0
    local FALTANDO=0
    
    for tool in "${FERRAMENTAS[@]}"; do
        if command -v "$tool" &> /dev/null; then
            echo -e "   ${GREEN}✓ $tool${NC}"
            INSTALADAS=$((INSTALADAS+1))
        else
            echo -e "   ${RED}✗ $tool (não encontrado)${NC}"
            FALTANDO=$((FALTANDO+1))
        fi
    done
    
    echo ""
    echo -e "   ${BLUE}Resumo:${NC} $INSTALADAS instaladas, $FALTANDO faltando"
    
    if [ $FALTANDO -gt 0 ]; then
        echo -e "   ${YELLOW}⚠ Algumas ferramentas não foram encontradas.${NC}"
        echo -e "   ${YELLOW}   Execute 'sudo apt-get install <ferramenta>' ou 'brew install <ferramenta>'${NC}"
    else
        echo -e "   ${GREEN}✓ Todas as ferramentas estão instaladas!${NC}"
    fi
}

# =============================================
# MENU PRINCIPAL
# =============================================
menu_principal() {
    echo ""
    echo -e "${BLUE}=============================================${NC}"
    echo -e "${BLUE}  CONFIGURADOR MULTI-SISTEMA${NC}"
    echo -e "${BLUE}=============================================${NC}"
    echo "1) Detectar sistema automaticamente"
    echo "2) Escolher sistema manualmente"
    echo "3) Verificar instalação"
    echo "0) Sair"
    echo ""
    echo -n "Escolha uma opção: "
    read opcao
    
    case $opcao in
        1)
            detectar_sistema
            if [[ "$OS" == "unknown" ]]; then
                menu_sistema
            fi
            ;;
        2)
            menu_sistema
            ;;
        3)
            verificar_instalacao
            return
            ;;
        0)
            echo -e "\n${GREEN}Até mais!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Opção inválida!${NC}"
            menu_principal
            return
            ;;
    esac
    
    # Verificar diretório
    verificar_diretorio
    
    # Instalar conforme sistema
    case $OS in
        linux)
            instalar_linux
            ;;
        macos)
            instalar_macos
            ;;
        wsl)
            instalar_wsl
            ;;
        windows)
            instalar_windows_msys
            ;;
        *)
            echo -e "${RED}Sistema não suportado!${NC}"
            exit 1
            ;;
    esac
    
    # Configurar permissões
    configurar_permissoes
    
    # Criar pastas
    if [ ! -d "automatos" ]; then
        mkdir -p automatos
        echo -e "   ${GREEN}✓ Pasta 'automatos/' criada${NC}"
    fi
    
    if [ ! -d "grafos_gerados" ]; then
        mkdir -p grafos_gerados
        echo -e "   ${GREEN}✓ Pasta 'grafos_gerados/' criada${NC}"
    fi
    
    if [ ! -d "analise_complexidade" ]; then
        mkdir -p analise_complexidade
        echo -e "   ${GREEN}✓ Pasta 'analise_complexidade/' criada${NC}"
    fi
    
    # Resumo final
    echo -e "\n${BLUE}=============================================="
    echo -e "  AMBIENTE CONFIGURADO COM SUCESSO!"
    echo -e "==============================================${NC}"
    
    echo -e "\n${YELLOW}Scripts disponíveis:${NC}"
    echo -e "   ${GREEN}./testar_multiplos_automatos.sh${NC} - Executa testes com CUnit/Daikon"
    echo -e "   ${GREEN}./analisar_complexidade.sh${NC}   - Análise de complexidade ciclomática"
    echo -e "   ${GREEN}./gerar_jflap_automatos.sh${NC}   - Gera autômatos para JFLAP"
    
    echo -e "\n${YELLOW}Notas importantes:${NC}"
    if [[ "$OS" == "windows" ]]; then
        echo -e "   • Execute os scripts no Git Bash ou WSL"
        echo -e "   • Algumas ferramentas podem não estar disponíveis"
        echo -e "   • Recomenda-se usar WSL para experiência completa"
    elif [[ "$OS" == "macos" ]]; then
        echo -e "   • Valgrind pode ter limitações no macOS"
        echo -e "   • Certifique-se de ter o Xcode Command Line Tools instalado"
        echo -e "   • Graphviz instalado para gerar imagens dos grafos"
    else
        echo -e "   • Todas as ferramentas foram instaladas"
        echo -e "   • Graphviz instalado para gerar imagens dos grafos"
    fi
}

# Iniciar
menu_principal