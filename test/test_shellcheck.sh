#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_TOP_DIR="${SCRIPT_DIR}/.."

# source libraries
TEST_LIB_PATH="${PROJECT_TOP_DIR}/test/test_lib.sh"
if [[ -f "${TEST_LIB_PATH}" ]]; then
    # shellcheck source=/dev/null
    source "${TEST_LIB_PATH}"
else
    echo "Error: Could not find test_lib.sh at ${TEST_LIB_PATH}"
    exit 1
fi

# @brief Function to run shellcheck on all the scripts
#
# USAGE:
#   Test::TestCase::shellcheck
#
# @return 0 on success, 1 on failure
function Test::TestCase::shellcheck()
{
    # Keep the shellcheck checks in alphabetical order
    Test::Utils::shellcheck_check "${PROJECT_TOP_DIR}/src/install_c_cpp_devtools.sh"
    Test::Utils::shellcheck_check "${PROJECT_TOP_DIR}/src/install_cli_utils.sh"
    Test::Utils::shellcheck_check "${PROJECT_TOP_DIR}/src/install_docker.sh"
    Test::Utils::shellcheck_check "${PROJECT_TOP_DIR}/src/install_git.sh"
    Test::Utils::shellcheck_check "${PROJECT_TOP_DIR}/src/install_latex.sh"
    Test::Utils::shellcheck_check "${PROJECT_TOP_DIR}/src/install_vagrant.sh"
    Test::Utils::shellcheck_check "${PROJECT_TOP_DIR}/src/install_virtualbox.sh"
    Test::Utils::shellcheck_check "${PROJECT_TOP_DIR}/src/main.sh"
    Test::Utils::shellcheck_check "${PROJECT_TOP_DIR}/src/message.sh"
    Test::Utils::shellcheck_check "${PROJECT_TOP_DIR}/src/osinfo.sh"
    Test::Utils::shellcheck_check "${PROJECT_TOP_DIR}/src/package_manager.sh"
}

# If the script is not being sourced, run the tests
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    Test::TestCase::shellcheck
fi