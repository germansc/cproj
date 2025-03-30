/* ***************************************************************************
 *   Project: PROJECT_TAG
 *      file: test_FILE_TAG.c
 *    author: AUTHOR_TAG
 *   version: 1.0
 *
 * Tests for the FILE_TAG module of the project.
 *
 * DATE_TAG - AUTHOR_TAG
 *
 * ************************************************************************* */

/* ===================================================== [UNITY HEADER FILE] */

#include "unity.h"

/* ======================================================== [MOCKED HEADERS] */

/* Mock any external module that is used by the module under test, prefixing the
 * external declaration header file name with "mock_". */

// #include "mock_os.h"

/* ===================================================== [MODULE UNDER TEST] */

/* In this place include the header file where the external interface of the
 * module under test is declared. */

#include "FILE_TAG.h"

/* ====================================================== [AUXILIAR HEADERS] */

/* If you use any standard system header on the test code (stdlib, math, string,
 * etc.) this is the place to place the inclusion. */

// #include <stdio.h>

/* ========================================================== [TEST GLOBALS] */

/* Use this space to declare any global variables that are used by your test
 * code. */

/* ==================================================== [AUXILIAR TEST CODE] */

/* Use this space to declare any global variables that are used by your test
 * code. */

/* ================================================================= [STUBS] */

/* Define any stub function that will be used throughout the test code.
 *
 * Prefixing the name with "stub_" is not required, but it is highly
 * recommended in order to reduce the global name space clutter. */

/* ============================================= [SET UP AND TEAR DOWN CODE] */

void setUp(void) {}

void tearDown(void) {}

/* ============================================================= [TEST CODE] */

/* Test case function names must be prefixed with "test_" in order to be
 * recognized by Ceedling as such.
 *
 * It is recommended to use the following naming convention:
 *
 * void test_<functionUnderTestName>_<functionTestCaseNumber>(void);
 * */

void test_FILE_TAG_0(void) {
    TEST_IGNORE_MESSAGE("Implement tests for the \"FILE_TAG\" module");
}
