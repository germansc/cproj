# GENERIC C-PROJECT MAKEFILE
# 2023 - germansc
#
# -------------------------------------------------------------- PROJECT SETUP
PROJECT_NAME = GENERIC C PROJECT FOR CROSS AND NON-CROSS COMPILATION
COMPANY = SOFTWARE Division of GSC Industries
AUTHOR = GERMANSC
YEAR = 2023

# TOOLCHAIN  #
CXX = gcc
GDB = gdb
SIZE = size

BUILD_PATH = build

# NOMBRE DEL EJECUTABLE #
PRJ_DIR = $(shell basename $(CURDIR))
BIN_NAME = $(BUILD_PATH)/$(PRJ_DIR)

# EXTENSIONES - LENGUAJE #
SRC_EXT = c

# OPCIONES Y LIBRERÍAS UTILIZADAS #
CFLAGS = -Wall -Wextra
LFLAGS = $(CFLAGS)
LIBS =

release: CFLAGS +=-O2
debug: CFLAGS +=-O0 -g3

# PATHS #
SRC_PATH = src
OBJ_PATH = $(BUILD_PATH)/objects
TEST_SRC_PATH = test/tests

# Listo todos los archivos fuente del directorio de SRC_PATH y los
# subdirectorios.
SRC_LIST = $(shell find $(SRC_PATH) -name '*.$(SRC_EXT)')
SRC_DIRS = $(shell find $(SRC_PATH) -type d)

# Genero el nombre de los archivos objeto a generar a partir de los sources.
OBJECTS = $(SRC_LIST:$(SRC_PATH)/%.$(SRC_EXT)=$(OBJ_PATH)/%.o)

# Genero dependencias para recompilar en modificaciones de headers.
DEPENDS = $(patsubst %.o, %.d, $(OBJECTS))

# INCLUDES - Agrego todos los subdirectorios de SRC_PATH #
INCLUDES = $(SRC_DIRS:%=-I %)

# DEFINES - Custom compilation definitions.
DEFS =

# If it exists, an external config.mki file is sourced here. This file can be
# used to set up some hardware or project specific configuration without
# polluting the makefile. Makefile syntax is expected as the file is simply
# sourced.
ifneq ("$(wildcard config.mki)","")
	include config.mki
endif

# DEFAULT TARGET #
.PHONY: default_target
default_target: help

# ---------------------------------------------------------- AUXILIARY TARGETS
.PHONY: help
help:
	@echo
	@echo $(PROJECT_NAME)
	@echo "----------------------------------------------"
	@echo "$(YEAR) · $(AUTHOR)"
	@echo "$(COMPANY)"
	@echo ""
	@echo ""
	@echo "TARGETS DE COMPILACIÓN:"
	@echo "    debug      : Versión sin optimizaciones y con información de símbolos."
	@echo "    release    : Versión con optimizaciones -O2 y sin información de símbolos."
	@echo "    run        : Compila y ejecuta la versión release."
	@echo ""
	@echo "TARGETS DE DESARROLLO:"
	@echo "    gdb              : Compila la versión debug del software y la"
	@echo "                       carga para ejecutar a través de GDB."
	@echo "    module <path>    : Genera un nuevo módulo en el directorio"
	@echo "                       especificado, con archivos fuente y de test."
	@echo "    test             : Ejecuta todos los tests unitarios del proyecto."
	@echo "    test <test-file> : Ejecuta un test unitario específico."
	@echo ""
	@echo "TARGETS AUXILIARES:"
	@echo "    clean      : Elimina todos los archivos objeto generados"
	@echo "    help       : Esta ayuda."
	@echo ""

.PHONY: clean
clean:
	@echo "Deleting executables and directories..."
	@echo ""
	@$(RM) -r $(BUILD_PATH)

# -------------------------------------------------------------- BUILD TARGETS
.PHONY: all
all: release

.PHONY: release
release: $(BIN_NAME)

.PHONY: debug
debug: $(BIN_NAME)

# Main Executable
$(BIN_NAME): $(OBJECTS)
	@echo ""
	@echo "Linking: $@"
	$(CXX) $(OBJECTS) $(LFLAGS) $(LIBS) -o $@
	@echo ""
	@echo "Build complete -> $(BIN_NAME)"
	@echo "------------------------------------------------"
	$(SIZE) $(BIN_NAME)
	@echo ""


# -------------------------------------------------------------- GENERAL RULES
# General Object compilation rules
-include $(DEPENDS)

$(OBJ_PATH)/%.o: $(SRC_PATH)/%.$(SRC_EXT)
	@echo ""
	@echo "Compiling: $< -> $@"
	@mkdir -p $(dir $@)
	$(CXX) $(CFLAGS) $(DEFS) $(INCLUDES) -MP -MMD -c $< -o $@

# -------------------------------------------------------- DEVELOPMENT TARGETS

# -- Compile and Run the main executable
run: release
	@$(BIN_NAME)

# -- Debug the compiled executable --
gdb: debug
	@$(GDB) $(BIN_NAME)

# -- Module Generator Target --
# Parse additional arguments as parameters instead of additional targets.
ifeq (module,$(firstword $(MAKECMDGOALS)))
  # use the rest as arguments for "run"
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(RUN_ARGS):;@:)

  MODULE_ARG=$(firstword $(RUN_ARGS))
  MODULE=$(MODULE_ARG:src/%=%)
  FILENAME=$(shell basename $(MODULE))
  DIRNAME=$(shell dirname $(MODULE))
  FILENAME_UPPER=$(shell echo $(FILENAME) | tr a-z A-Z)
  DIRNAME_UPPER=$(shell echo $(DIRNAME) | tr a-z A-Z | tr / _)
  DATE_STR=$(shell date '+%B %Y')
endif

module:
	@echo "Creating new $(FILENAME) module at: src/$(DIRNAME)"
	@mkdir -p $(SRC_PATH)/$(DIRNAME)
	@mkdir -p $(TEST_SRC_PATH)/$(DIRNAME)
	@cp templates/module.c $(SRC_PATH)/$(DIRNAME)/$(FILENAME).c
	@cp templates/module.h $(SRC_PATH)/$(DIRNAME)/$(FILENAME).h
	@cp templates/test_module.c $(TEST_SRC_PATH)/$(DIRNAME)/test_$(FILENAME).c
	@sed -i "s|PROJECT_TAG|$(PROJECT_NAME)|g" $(SRC_PATH)/$(DIRNAME)/$(FILENAME).[ch] $(TEST_SRC_PATH)/$(DIRNAME)/test_$(FILENAME).c
	@sed -i "s|DIR_TAG|$(DIRNAME)|g" $(SRC_PATH)/$(DIRNAME)/$(FILENAME).[ch] $(TEST_SRC_PATH)/$(DIRNAME)/test_$(FILENAME).c
	@sed -i "s|FILE_TAG|$(FILENAME)|g" $(SRC_PATH)/$(DIRNAME)/$(FILENAME).[ch] $(TEST_SRC_PATH)/$(DIRNAME)/test_$(FILENAME).c
	@sed -i "s|DIR_UPPER_TAG|$(DIRNAME_UPPER)|g" $(SRC_PATH)/$(DIRNAME)/$(FILENAME).[ch] $(TEST_SRC_PATH)/$(DIRNAME)/test_$(FILENAME).c
	@sed -i "s|FILE_UPPER_TAG|$(FILENAME_UPPER)|g" $(SRC_PATH)/$(DIRNAME)/$(FILENAME).[ch] $(TEST_SRC_PATH)/$(DIRNAME)/test_$(FILENAME).c
	@sed -i "s|AUTHOR_TAG|$(USER)|g" $(SRC_PATH)/$(DIRNAME)/$(FILENAME).[ch] $(TEST_SRC_PATH)/$(DIRNAME)/test_$(FILENAME).c
	@sed -i "s|DATE_TAG|$(DATE_STR)|g" $(SRC_PATH)/$(DIRNAME)/$(FILENAME).[ch] $(TEST_SRC_PATH)/$(DIRNAME)/test_$(FILENAME).c

# --------------------------------------------------------------- TEST TARGETS
#  The tests targets should redirect to the ceedling tool using the 'test'
#  directory as working dir.

# -- Test Target Redirect --
ifeq (test,$(firstword $(MAKECMDGOALS)))
# Parse additional arguments as parameters instead of additional targets.
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(RUN_ARGS):;@:)

  TEST_ARG=$(strip $(firstword $(RUN_ARGS)))
  ifeq ($(TEST_ARG),)
	TEST_ARG="runalltests"
  endif

endif

.PHONY: test
test: ## Redirige el siguiente target al makefile de `test`.
	@echo "Testing $(TEST_ARG)"
	$(MAKE) -C test $(TEST_ARG)

