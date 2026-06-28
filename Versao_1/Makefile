# Makefile para Comparativo de 4 Métodos
# Compilador
CC = gcc
CFLAGS = -Wall -g -O0
LIBS_CUNIT = -lcunit

# Diretórios
MANUAL_DIR = ../Manual
CUNIT_DIR = cunit
DAIKON_DIR = daikon
CLANG_DIR = clang
SPIN_DIR = spin
RELATORIO_DIR = relatorio

# Alvo principal
all: gerador comparativo

# Compila o gerador
gerador: gerador_comparativo_4metodos.c
	@echo "Compilando gerador comparativo..."
	$(CC) $(CFLAGS) -o gerador_comparativo $^
	@echo " Gerador compilado: gerador_comparativo"

# Gera todos os arquivos
gerar: gerador
	@echo " Gerando arquivos para 4 métodos..."
	./gerador_comparativo

# CUnit - CORRIGIDO: usa ../Manual
cunit: gerar
	@echo "\n=== CUNIT (Dinâmico) ==="
	cd $(CUNIT_DIR) && \
	$(CC) $(CFLAGS) test_cunit.c $(MANUAL_DIR)/executar.c $(LIBS_CUNIT) -o test_cunit
	@echo " CUnit compilado: cunit/test_cunit"

# Daikon - CORRIGIDO: usa ../Manual
daikon: gerar
	@echo "\n=== DAIKON (Dinâmico) ==="
	cd $(DAIKON_DIR) && \
	$(CC) $(CFLAGS) test_daikon.c $(MANUAL_DIR)/executar.c -o test_daikon
	@echo " Daikon compilado: daikon/test_daikon"

# Clang (apresentação)
clang: gerar
	@echo "\n=== CLANG/LLVM (Estático) ==="
	@echo " Arquivos de análise gerados em: $(CLANG_DIR)/"
	@echo " Para análise real, execute:"
	@echo "  clang --analyze -Xanalyzer -analyzer-checker=core $(MANUAL_DIR)/executar.c"

# Spin (apresentação)
spin: gerar
	@echo "\n=== SPIN (Estático) ==="
	@echo " Modelo Promela gerado em: $(SPIN_DIR)/modelo_spin.pml"
	@echo " Para executar, instale SPIN e:"
	@echo "  cd spin && ./executar_spin.sh"

# Executa CUnit
test_cunit: cunit
	@echo "\n EXECUTANDO CUNIT..."
	cd $(CUNIT_DIR) && ./test_cunit

# Executa Daikon
test_daikon: daikon
	@echo "\n EXECUTANDO DAIKON..."
	cd $(DAIKON_DIR) && ./test_daikon

# Executa ambos dinâmicos
test_dinamicos: test_cunit test_daikon
	@echo "\n TESTES DINÂMICOS CONCLUÍDOS!"

# Executa análise completa
comparativo: cunit daikon
	@echo "\n==========================================="
	@echo " EXECUTANDO COMPARAÇÃO COMPLETA"
	@echo "==========================================="
	@chmod +x executar_comparativo.sh 2>/dev/null || true
	@echo "\nExecutando script comparativo..."
	./executar_comparativo.sh

# Versão sem CUnit (se não tiver instalado)
comparativo_sem_cunit: daikon
	@echo "\n==========================================="
	@echo " EXECUTANDO COMPARAÇÃO (SEM CUNIT)"
	@echo "==========================================="
	@echo "\n1. Executando Daikon..."
	cd daikon && ./test_daikon
	@echo "\n2. Análise Clang/LLVM..."
	@echo "   Veja: clang/analise_clang.md"
	@echo "\n3. Modelo SPIN..."
	@echo "   Veja: spin/modelo_spin.pml"
	@echo "\n4. Relatório..."
	@echo "   Veja: relatorio/RELATORIO_COMPARATIVO.md"

# Mostra relatório
relatorio: gerar
	@echo "\n===  RELATÓRIO COMPARATIVO ==="
	@echo "Consulte: $(RELATORIO_DIR)/RELATORIO_COMPARATIVO.md"
	@echo "\n Resumo:"
	@head -20 $(RELATORIO_DIR)/RELATORIO_COMPARATIVO.md

# Limpeza
clean:
	@echo " Limpando arquivos gerados..."
	rm -rf $(CUNIT_DIR) $(DAIKON_DIR) $(CLANG_DIR) $(SPIN_DIR) $(RELATORIO_DIR)
	rm -f gerador_comparativo executar_comparativo.sh

# Limpa mas mantém Manual
clean_gerados:
	@echo " Limpando apenas arquivos gerados..."
	rm -rf $(CUNIT_DIR) $(DAIKON_DIR) $(CLANG_DIR) $(SPIN_DIR) $(RELATORIO_DIR)
	rm -f executar_comparativo.sh

# Mostra estrutura
estrutura:
	@echo " ESTRUTURA ATUAL:"
	@ls -la
	@echo "\n Manual/:"
	@ls -la Manual/
	@echo "\n Conteúdo das pastas geradas:"
	@for dir in cunit daikon clang spin relatorio; do \
		if [ -d $$dir ]; then \
			echo "\n $$dir/:"; \
			ls -la $$dir/; \
		fi; \
	done

# Verifica dependências
check:
	@echo "🔍 VERIFICANDO DEPENDÊNCIAS:"
	@echo -n "gcc: "; which gcc || echo "NÃO ENCONTRADO"
	@echo -n "clang: "; which clang || echo "NÃO ENCONTRADO"
	@echo -n "CUnit: "; pkg-config --exists cunit && echo "OK" || echo "NÃO ENCONTRADO"
	@echo -n "spin: "; which spin || echo "NÃO ENCONTRADO (SPIN)"
	@echo -n "Manual/executar.c: "; [ -f Manual/executar.c ] && echo "OK" || echo "NÃO ENCONTRADO"
	@echo -n "Manual/executar.h: "; [ -f Manual/executar.h ] && echo "OK" || echo "NÃO ENCONTRADO"

# Ajuda
help:
	@echo "MAKEFILE PARA COMPARATIVO DE 4 MÉTODOS"
	@echo "=========================================="
	@echo ""
	@echo "Comandos disponíveis:"
	@echo "  make                     - Compila e gera tudo"
	@echo "  make comparativo         - Executa comparação completa"
	@echo "  make comparativo_sem_cunit - Executa sem CUnit"
	@echo "  make test_cunit          - Executa apenas CUnit"
	@echo "  make test_daikon         - Executa apenas Daikon"
	@echo "  make test_dinamicos      - Executa ambos métodos dinâmicos"
	@echo "  make relatorio           - Mostra relatório"
	@echo "  make estrutura           - Mostra estrutura de arquivos"
	@echo "  make check               - Verifica dependências"
	@echo "  make clean               - Limpa tudo"
	@echo "  make clean_gerados       - Limpa apenas arquivos gerados"
	@echo "  make help                - Mostra esta ajuda"
	@echo ""
	@echo "NOTA: Se não tem CUnit instalado, use 'make comparativo_sem_cunit'"

.PHONY: all gerar cunit daikon clang spin test_cunit test_daikon test_dinamicos comparativo comparativo_sem_cunit relatorio clean clean_gerados estrutura check help