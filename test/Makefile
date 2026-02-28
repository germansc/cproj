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
	@echo "Calling CEEDLING for cleanup"
	@echo
	$(TOOL) $(TOOLFLAGS) clobber
	@echo
	@echo "Done."
	@echo

.PHONY: all
all:
	@echo
	@echo "Calling CEEDLING (all tests)"
	@echo
	$(TOOL) $(TOOLFLAGS) $(TEST_TARGET_OPTS) test:all
	@echo
	@echo "Done testing for target $(TARGET)."
	@echo

coverage:
	@echo
	@echo "Calling CEEDLING to generate coverage information..."
	@echo
	$(TOOL) $(TOOLFLAGS) $(TEST_TARGET_OPTS) gcov:all report:gcov
	@echo
	@echo "Done testing for target $(TARGET)."
	@echo

report: coverage

#
# General test running rule for individual files
#
test_%.c %.c %::build-info
	$(TOOL) $(TOOLFLAGS) $(TEST_TARGET_OPTS) test:$(@:test_%=%)

#
# General coverage generation rule for individual files
#
cov_%.c cov_%::build-info
	$(TOOL) $(TOOLFLAGS) $(TEST_TARGET_OPTS) gcov:$(@:cov_%=%) report:gcov | grep -v "Could not find"

#
# Print the actual coverage report
#
summary:
	gcovr --root ../src --exclude ".*/test_.*" build/artifacts/gcov/gcovr --print-summary

#
# Empty rule to avoid running test_% on the actual Makefile
#
Makefile: ;

.PHONY: clean all delta report coverage summary help
