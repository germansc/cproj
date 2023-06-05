# MAKEFILE GENERICO PARA USOS MULTIPLES
# 2023 - germansc
#

# -------------------------------------------------------------- PROJECT SETUP
PROJECT_NAME = "GENERIC MAKEFILE FOR CROSS AND NON-CROSS COMPILATION"
COMPANY = "SOFTWARE Division of GSC Industries"
AUTHOR = "Germán Sc"
YEAR = "2023"

# TOOLCHAIN  #
CXX = gcc
SIZE = size

BUILD_PATH = build

# NOMBRE DEL EJECUTABLE #
BIN_NAME = $(BUILD_PATH)/runner

# EXTENSIONES - LENGUAJE #
SRC_EXT = c

# OPCIONES Y LIBRERÍAS UTILIZADAS #
CFLAGS = -Wall -Wextra
LIBS =

release: CFLAGS +=-O2
debug: CFLAGS +=-O0 -g3

# PATHS #
SRC_PATH = src
OBJ_PATH = $(BUILD_PATH)/objects

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

# DEFAULT TARGET #
.PHONY: default_target
default_target: help

# ---------------------------------------------------------- AUXILIARY TARGETS
.PHONY: help
help:
	@echo
	@echo $(PROJECT_NAME)
	@echo "----------------------------------------------"
	@echo "$(COMPANY)"
	@echo "$(AUTHOR) · $(YEAR)"
	@echo ""
	@echo ""
	@echo "TARGETS DE COMPILACIÓN:"
	@echo "    debug      : Versión sin optimizaciones y con información de símbolos."
	@echo "    release    : Versión con optimizaciones -O2 y sin información de símbolos."
	@echo ""
	@echo "TARGETS AUXILIARES:"
	@echo "    clean      : Elimina todos los archivos objeto generados"
	@echo "    help       : Esta ayuda."
	@echo ""

.PHONY: dirs
dirs:
	@mkdir -p $(dir $(OBJECTS))

.PHONY: clean
clean:
	@echo "Deleting executables and directories..."
	@echo ""
	@$(RM) -r $(BUILD_PATH)

# -------------------------------------------------------------- BUILD TARGETS
.PHONY: all
all: release

.PHONY: release
release: dirs $(BIN_NAME)

.PHONY: debug
debug: dirs $(BIN_NAME)

# EJECUTABLE PRINCIPAL #
$(BIN_NAME): $(OBJECTS)
	@echo ""
	@echo "Linking: $@"
	$(CXX) $(OBJECTS) $(LIBS) -o $@
	@echo ""
	@echo "Build complete -> $(BIN_NAME)"
	@echo "------------------------------------------------"
	$(SIZE) $(BIN_NAME)
	@echo ""

# -------------------------------------------------------- DEVELOPMENT TARGETS

# Debugging tool
GDB=gdb

gdb: debug
	@$(GDB) $(BIN_NAME)

# -- Module Generator Target --
# Parse additional arguments as parameters instead of additional targets.
ifeq (module,$(firstword $(MAKECMDGOALS)))
  # use the rest as arguments for "run"
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(RUN_ARGS):;@:)

  MODULE=$(firstword $(RUN_ARGS))
  FILENAME=$(shell basename $(MODULE))
  DIRNAME=$(shell dirname $(MODULE))
endif

module:
	@echo "Creating new $(FILENAME) module at: src/$(DIRNAME)"
	@mkdir -p src/$(DIRNAME)
	@mkdir -p test/tests/$(DIRNAME)
	@cp templates/module.c src/$(DIRNAME)/$(FILENAME).c
	@cp templates/module.h src/$(DIRNAME)/$(FILENAME).h
	@cp templates/test_module.c test/tests/$(DIRNAME)/test_$(FILENAME).c

# -------------------------------------------------------------- GENERAL RULES
# Reglas generales para compilacion de objetos.
-include $(DEPENDS)

$(OBJ_PATH)/%.o: $(SRC_PATH)/%.$(SRC_EXT)
	@echo ""
	@echo "Compiling: $< -> $@"
	$(CXX) $(CFLAGS) $(INCLUDES) -MP -MMD -c $< -o $@
