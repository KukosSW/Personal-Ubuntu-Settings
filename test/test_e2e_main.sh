#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_TOP_DIR="${SCRIPT_DIR}/.."

# @brief Function to print a test failed message
#
# USAGE:
#   Test::Utils::fail "Test name"
# OUTPUT:
#   [TEST] FAILED: Test name
#
# @param $1 - Test name
#
# @return 1
function Test::Utils::fail()
{
    local test_name="${1}"
    printf "%b[TEST] FAILED: %s%b\n" "\033[0;31m" "${test_name}" "\033[0m"

    return 1
}

# @brief Function to print a test passed message
#
# USAGE:
#   Test::Utils::pass "Test name"
# OUTPUT:
#   [TEST] PASSED: Test name
#
# @param $1 - Test name
#
# @return 0
function Test::Utils::pass()
{
    local test_name="${1}"
    printf "%b[TEST] PASSED: %s%b\n" "\033[0;32m" "${test_name}"  "\033[0m"
}

# @brief Function to run a test
# This function runs a test and prints the test name before running the test and prints the result after the test
# If the test fails, it prints the log file content to the stderr and exits with 1
# If the test passes, it prints only the test name and the result, then returns 0
#
# USAGE:
#   Test::Utils::test "Test name" "Test command" "Test arguments"
# OUTPUT:
#   [TEST] Running: Test name
#   [TEST] PASSED: Test name
#
# @param $1 - Test name
# @param $2 - Test command
# @param $3 - Test arguments
# @param $4 - Test arguments
# ...
# @param $@ - Test arguments
#
# @return 0 OR exit 1
function Test::Utils::test()
{
    local test_name="${1}"
    local test_command="${2}"

    # We dont know how many arguments will be passed to the test command
    # So we need to use ${@} to get the rest of the arguments
    # We need to shift 2 to get the rest of the arguments
    shift 2
    local test_args=("${@}")

    # We dont want to spam the output from the test command every time
    # So we will redirect the output to a temporary file
    # Only if the test fails, we will print the content of the log file to the stderr
    local temp_log_file
    temp_log_file=$(mktemp)

    printf "%b[TEST] Running: ${test_name}%b\n" "\033[0;33m" "\033[0m"

    if eval "${test_command}" "${test_args[@]}" >"${temp_log_file}" 2>&1; then
        Test::Utils::pass "${test_name}"

        rm -f "${temp_log_file}"
        return 0
    else
        Test::Utils::fail "${test_name}"

        cat "${temp_log_file}" >&2

        rm -f "${temp_log_file}"
        exit 1
    fi
}

function Test::TestCase::install_git()
{
    Test::Utils::test "PersonalSettings::Installer::install_git::config::user" "git config --list | grep -q \"user.email=kukossw@gmail.com\""
    Test::Utils::test "PersonalSettings::Installer::install_git::config::editor" "git config --list | grep -q \"core.editor=nvim\""
    Test::Utils::test "PersonalSettings::Installer::install_git::config::alias" "git config --list | grep -q \"alias.ci=commit\""
}

function Test::TestCase::install_c_cpp_devtools()
{
    Test::Utils::test "PersonalSettings::Installer::install_c_cpp_devtools::install::gcc" "gcc --version"
    Test::Utils::test "PersonalSettings::Installer::install_c_cpp_devtools::install::g++" "g++ --version"
    Test::Utils::test "PersonalSettings::Installer::install_c_cpp_devtools::install::gdb" "gdb --version"
    Test::Utils::test "PersonalSettings::Installer::install_c_cpp_devtools::install::clang" "clang --version"
    Test::Utils::test "PersonalSettings::Installer::install_c_cpp_devtools::install::make" "make --version"
    Test::Utils::test "PersonalSettings::Installer::install_c_cpp_devtools::install::cmake" "cmake --version"
    Test::Utils::test "PersonalSettings::Installer::install_c_cpp_devtools::install::valgrind" "valgrind --version"
    Test::Utils::test "PersonalSettings::Installer::install_c_cpp_devtools::install::cppcheck" "cppcheck --version"

    Test::Utils::test "PersonalSettings::PackageManager::Apt::install::doxygen" "doxygen --version" || exit 1
    Test::Utils::test "PersonalSettings::PackageManager::Apt::install::pandoc" "pandoc --version" || exit 1
    Test::Utils::test "PersonalSettings::PackageManager::Apt::install::groff" "groff --version" || exit 1
    Test::Utils::test "PersonalSettings::PackageManager::Apt::install::flex" "flex --version" || exit 1
    Test::Utils::test "PersonalSettings::PackageManager::Apt::install::bison" "bison --version" || exit 1
    Test::Utils::test "PersonalSettings::PackageManager::Apt::install::strace" "strace --version" || exit 1
    Test::Utils::test "PersonalSettings::PackageManager::Apt::install::ltrace" "ltrace --version" || exit 1
}

function Test::TestCase::install_latex()
{
    Test::Utils::test "PersonalSettings::PackageManager::Apt::install::texlive-full" "tex --version" || exit 1
    Test::Utils::test "PersonalSettings::PackageManager::Apt::install::latex" "latex --version" || exit 1
    Test::Utils::test "PersonalSettings::PackageManager::Apt::install::pdflatex" "pdflatex --version" || exit 1
    Test::Utils::test "PersonalSettings::PackageManager::Apt::install::gnuplot" "aspell --version" || exit 1
}

function Test::TestSuite::E2E::run()
{
    "${PROJECT_TOP_DIR}/src/main.sh"

    Test::TestCase::install_git
    Test::TestCase::install_c_cpp_devtools
}

Test::TestSuite::E2E::run