#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_TOP_DIR="${SCRIPT_DIR}/.."

# source libraries
TEST_SHELLCHECK_PATH="${PROJECT_TOP_DIR}/test/test_shellcheck.sh"
if [[ -f "${TEST_SHELLCHECK_PATH}" ]]; then
    # shellcheck source=/dev/null
    source "${TEST_SHELLCHECK_PATH}"
else
    echo "Error: Could not find test_shellcheck.sh at ${TEST_SHELLCHECK_PATH}"
    exit 1
fi

TEST_TESTCASES_PATH="${PROJECT_TOP_DIR}/test/test_testcases.sh"
if [[ -f "${TEST_TESTCASES_PATH}" ]]; then
    # shellcheck source=/dev/null
    source "${TEST_TESTCASES_PATH}"
else
    echo "Error: Could not find test_testcases.sh at ${TEST_TESTCASES_PATH}"
    exit 1
fi


function Test::TestSuite::E2E::run()
{
    Test::TestCase::shellcheck

    "${PROJECT_TOP_DIR}/src/main.sh" || exit 1
    # Python pipx exported a PATH variable that is not available in the current shell
    # We need to export it again here to make the tests work
    export PATH="${HOME}/.local/bin:${PATH}"

    Test::TestCase::install_c_cpp_devtools
    Test::TestCase::install_cli_utils
    Test::TestCase::install_docker
    Test::TestCase::install_fonts
    Test::TestCase::install_git
    Test::TestCase::install_golang
    Test::TestCase::install_java
    Test::TestCase::install_latex
    Test::TestCase::install_python
    Test::TestCase::install_pipx_apps
    Test::TestCase::install_vagrant
    Test::TestCase::install_virtualbox
}

Test::TestSuite::E2E::run