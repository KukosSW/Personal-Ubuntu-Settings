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

# @brief Function to run shellcheck on a script
#
# USAGE:
#   Test::Utils::shellcheck_check "script"
# OUTPUT:
#   [TEST] Running: Shellcheck: script
#   [TEST] PASSED: Shellcheck: script
#
# @param $1 - Script to run shellcheck
#
# @return 0 OR exit 1
function Test::Utils::shellcheck_check()
{
    local script="${1}"

    printf "%b[TEST] Running: Shellcheck: ${script}%b\n" "\033[0;33m" "\033[0m"
    if shellcheck --shell=bash --enable=all --external-sources "${script}"; then
        Test::Utils::pass "Shellcheck: ${script}"

        return 0
    else
        Test::Utils::fail "Shellcheck: ${script}"

        exit 1
    fi
}

function Test::TestCase::shellcheck()
{
    Test::Utils::shellcheck_check "${PROJECT_TOP_DIR}/src/message.sh"
    Test::Utils::shellcheck_check "${PROJECT_TOP_DIR}/src/package_manager.sh"
    Test::Utils::shellcheck_check "${PROJECT_TOP_DIR}/src/install_cli_utils.sh"
    Test::Utils::shellcheck_check "${PROJECT_TOP_DIR}/src/install_git.sh"
    Test::Utils::shellcheck_check "${PROJECT_TOP_DIR}/src/install_c_cpp_devtools.sh"
    Test::Utils::shellcheck_check "${PROJECT_TOP_DIR}/src/install_latex.sh"
    Test::Utils::shellcheck_check "${PROJECT_TOP_DIR}/src/main.sh"
}

function Test::TestCase::package_manager()
{
    source "${PROJECT_TOP_DIR}/src/package_manager.sh"

    Test::Utils::test "PersonalSettings::PackageManager::Apt::update" "PersonalSettings::PackageManager::Apt::update"
    Test::Utils::test "PersonalSettings::PackageManager::Apt::upgrade" "PersonalSettings::PackageManager::Apt::upgrade"
    Test::Utils::test "PersonalSettings::PackageManager::Apt::full_upgrade" "PersonalSettings::PackageManager::Apt::full_upgrade"
    Test::Utils::test "PersonalSettings::PackageManager::Apt::fix_broken" "PersonalSettings::PackageManager::Apt::fix_broken"
    Test::Utils::test "PersonalSettings::PackageManager::Apt::autoremove" "PersonalSettings::PackageManager::Apt::autoremove"
    Test::Utils::test "PersonalSettings::PackageManager::Apt::clean" "PersonalSettings::PackageManager::Apt::clean"
    Test::Utils::test "PersonalSettings::PackageManager::Apt::autoclean" "PersonalSettings::PackageManager::Apt::autoclean"
    Test::Utils::test "PersonalSettings::PackageManager::Apt::install bc" "PersonalSettings::PackageManager::Apt::install" "bc"
    Test::Utils::test "PersonalSettings::PackageManager::Apt::is_installed bc" "PersonalSettings::PackageManager::Apt::is_installed" "bc"
    Test::Utils::test "PersonalSettings::PackageManager::Apt::remove bc" "PersonalSettings::PackageManager::Apt::remove" "bc"
    Test::Utils::test "PersonalSettings::PackageManager::Apt::is_installed bc" "! PersonalSettings::PackageManager::Apt::is_installed" "bc"
    Test::Utils::test "PersonalSettings::PackageManager::Apt::install libssl-dev" "PersonalSettings::PackageManager::Apt::install" "libssl-dev"
    Test::Utils::test "PersonalSettings::PackageManager::Apt::is_installed libssl-dev" "PersonalSettings::PackageManager::Apt::is_installed" "libssl-dev"
    Test::Utils::test "PersonalSettings::PackageManager::Apt::remove libssl-dev" "PersonalSettings::PackageManager::Apt::remove" "libssl-dev"
    Test::Utils::test "PersonalSettings::PackageManager::Apt::is_installed libssl-dev" "! PersonalSettings::PackageManager::Apt::is_installed" "libssl-dev"
}

function Test::TestCase::install_cli_utils()
{
    source "${PROJECT_TOP_DIR}/src/install_cli_utils.sh"

    Test::Utils::test "PersonalSettings::Installer::install_cli_utils" "PersonalSettings::Installer::install_cli_utils"

    Test::Utils::test "PersonalSettings::Installer::install_cli_utils::curl" "curl --version"
    Test::Utils::test "PersonalSettings::Installer::install_cli_utils::gawk" "awk --version"
    Test::Utils::test "PersonalSettings::Installer::install_cli_utils::tree" "tree --version"
    Test::Utils::test "PersonalSettings::Installer::install_cli_utils::rsync" "rsync --version"
    Test::Utils::test "PersonalSettings::Installer::install_cli_utils::nmap" "nmap --version"
    Test::Utils::test "PersonalSettings::Installer::install_cli_utils::nala" "nala --version"
}

function Test::TestCase::install_git()
{
    source "${PROJECT_TOP_DIR}/src/install_git.sh"

    Test::Utils::test "PersonalSettings::Installer::install_git" "PersonalSettings::Installer::install_git"

    Test::Utils::test "PersonalSettings::Installer::install_git::git" "git --version"
    Test::Utils::test "PersonalSettings::Installer::install_git::config::user" "git config --list | grep -q \"user.email=kukossw@gmail.com\""
    Test::Utils::test "PersonalSettings::Installer::install_git::config::editor" "git config --list | grep -q \"core.editor=nvim\""
    Test::Utils::test "PersonalSettings::Installer::install_git::config::alias" "git config --list | grep -q \"alias.ci=commit\""
    Test::Utils::test "PersonalSettings::Installer::install_git::gh" "gh --version"
    Test::Utils::test "PersonalSettings::Installer::install_git::lazygit" "lazygit --version"
}

function Test::TestCase::install_c_cpp_devtools()
{
    source "${PROJECT_TOP_DIR}/src/install_c_cpp_devtools.sh"

    Test::Utils::test "PersonalSettings::Installer::install_c_cpp_devtools" "PersonalSettings::Installer::install_c_cpp_devtools"

    Test::Utils::test "PersonalSettings::Installer::install_c_cpp_devtools::install::gcc" "gcc --version"
    Test::Utils::test "PersonalSettings::Installer::install_c_cpp_devtools::install::g++" "g++ --version"
    Test::Utils::test "PersonalSettings::Installer::install_c_cpp_devtools::install::gdb" "gdb --version"
    Test::Utils::test "PersonalSettings::Installer::install_c_cpp_devtools::install::clang" "clang --version"
    Test::Utils::test "PersonalSettings::Installer::install_c_cpp_devtools::install::make" "make --version"
    Test::Utils::test "PersonalSettings::Installer::install_c_cpp_devtools::install::cmake" "cmake --version"
    Test::Utils::test "PersonalSettings::Installer::install_c_cpp_devtools::install::valgrind" "valgrind --version"
    Test::Utils::test "PersonalSettings::Installer::install_c_cpp_devtools::install::cppcheck" "cppcheck --version"

    Test::Utils::test "PersonalSettings::Installer::install_c_cpp_devtools::doxygen" "doxygen --version"
    Test::Utils::test "PersonalSettings::Installer::install_c_cpp_devtools::pandoc" "pandoc --version"
    Test::Utils::test "PersonalSettings::Installer::install_c_cpp_devtools::groff" "groff --version"
    Test::Utils::test "PersonalSettings::Installer::install_c_cpp_devtools::flex" "flex --version"
    Test::Utils::test "PersonalSettings::Installer::install_c_cpp_devtools::bison" "bison --version"
    Test::Utils::test "PersonalSettings::Installer::install_c_cpp_devtools::strace" "strace --version"
    Test::Utils::test "PersonalSettings::Installer::install_c_cpp_devtools::ltrace" "ltrace --version"
}

function Test::TestCase::install_latex()
{
    source "${PROJECT_TOP_DIR}/src/install_latex.sh"

    Test::Utils::test "PersonalSettings::Installer::install_latex" "PersonalSettings::Installer::install_latex"

    Test::Utils::test "PersonalSettings::PackageManager::Installer::install_latex::texlive-full" "tex --version"
    Test::Utils::test "PersonalSettings::PackageManager::Installer::install_latex::latex" "latex --version"
    Test::Utils::test "PersonalSettings::PackageManager::Installer::install_latex::pdflatex" "pdflatex --version"
    Test::Utils::test "PersonalSettings::PackageManager::Installer::install_latex::gnuplot" "aspell --version"
}

function Test::TestSuite::run()
{
    Test::TestCase::shellcheck

    Test::TestCase::package_manager

    Test::TestCase::install_cli_utils
    Test::TestCase::install_git
    Test::TestCase::install_c_cpp_devtools
    Test::TestCase::install_latex
}

Test::TestSuite::run