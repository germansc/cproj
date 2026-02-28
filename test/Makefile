# ***********************************
# Default Rule
# ***********************************
default : help

# ***********************************
#
# Herramientas
#
# ***********************************

# Override exported flags to ensure the used tools.
CC = gcc
CFLAGS =
export CC
export CFLAGS

TOOL = ceedling
RM = rm -rf

TOOLFLAGS ?=
BUILD_PATH = build

# Ceedling copies vendors Unity/CMock sources into the build directory. When
# running from a Nix environment, the copied files inherit the read-only
# permissions from the Nix store, causing permission errors on subsequent runs.
# This macro wraps ceedling calls to fix vendor permissions after execution.
define run-ceedling
	$(TOOL) $(TOOLFLAGS) $(1); _rc=$$?; \
	if [ -d $(BUILD_PATH)/vendor ]; then chmod -R u+w $(BUILD_PATH)/vendor; fi; \
	exit $$_rc
endef

# ***************************************
#
# Opciones de compilación
#
# ***************************************


help:
	@echo "----------------------------------------------"
	@echo "UNIT-TEST MAKEFILE:"
	@echo "----------------------------------------------"
	@echo
	@echo TESTING TARGETS:
	@echo "clean         : Cleanup the test build directories"
	@echo "all           : Run the whole test suite"
	@echo "report        : Generate a coverage report"
	@echo "summary       : Print coverage summary"
	@echo "<source-file> : Run the tests asosciated with the given source file"
	@echo "cov_<source-file> : Generate a coverage report of a specific source file"
	@echo

#
# Clean up the generated files
#
clean:
	@echo
	@echo "Cleaning test build directories..."
	@echo
	@if [ -d $(BUILD_PATH) ]; then chmod -R u+w $(BUILD_PATH) && $(RM) $(BUILD_PATH); fi
	@echo
	@echo "Done."
	@echo

.PHONY: all
all:
	@echo
	@echo "Calling CEEDLING (all tests)"
	@echo
	@$(call run-ceedling,$(TEST_TARGET_OPTS) test:all)
	@echo
	@echo "Done testing for target $(TARGET)."
	@echo

coverage:
	@echo
	@echo "Calling CEEDLING to generate coverage information..."
	@echo
	@$(call run-ceedling,$(TEST_TARGET_OPTS) gcov:all report:gcov)
	@echo
	@echo "Done testing for target $(TARGET)."
	@echo

report: coverage

#
# General test running rule for individual files
#
test_%.c %.c %::build-info
	@$(call run-ceedling,$(TEST_TARGET_OPTS) test:$(@:test_%=%))

#
# General coverage generation rule for individual files
#
cov_%.c cov_%::build-info
	@$(call run-ceedling,$(TEST_TARGET_OPTS) gcov:$(@:cov_%=%) report:gcov) | grep -v "Could not find"

#
# Print the actual coverage report
#
summary:
	gcovr --root ../src --exclude ".*/test_.*" build/artifacts/gcov/gcovr --print-summary

#
# Empty rule to avoid running test_% on the actual Makefile
#
Makefile: ;

.PHONY: clean all report coverage summary help
