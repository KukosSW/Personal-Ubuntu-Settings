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

function Test::TestCase::Unit::package_manager()
{
    # Run tests
    Test::TestCase::package_manager
}

function Test::TestCase::Unit::install_c_cpp_devtools()
{
    # Run installation
    source "${PROJECT_TOP_DIR}/src/install_c_cpp_devtools.sh"
    Test::Utils::test "PersonalSettings::Installer::install_c_cpp_devtools" "PersonalSettings::Installer::install_c_cpp_devtools"

    # Run tests
    Test::TestCase::install_c_cpp_devtools
}

function Test::TestCase::Unit::install_cli_utils()
{
    # Run installation
    source "${PROJECT_TOP_DIR}/src/install_cli_utils.sh"
    Test::Utils::test "PersonalSettings::Installer::install_cli_utils" "PersonalSettings::Installer::install_cli_utils"

    # Run tests
    Test::TestCase::install_cli_utils
}

function Test::TestCase::Unit::install_docker()
{
    # Run installation
    source "${PROJECT_TOP_DIR}/src/install_docker.sh"
    Test::Utils::test "PersonalSettings::Installer::install_docker" "PersonalSettings::Installer::install_docker"

    # Run tests
    Test::TestCase::install_docker
}

function Test::TestCase::Unit::install_fonts()
{
    # Run installation
    source "${PROJECT_TOP_DIR}/src/install_fonts.sh"
    Test::Utils::test "PersonalSettings::Installer::install_fonts" "PersonalSettings::Installer::install_fonts"

    # Run tests
    Test::TestCase::install_fonts
}

function Test::TestCase::Unit::install_git()
{
    # Run installation
    source "${PROJECT_TOP_DIR}/src/install_git.sh"
    Test::Utils::test "PersonalSettings::Installer::install_git" "PersonalSettings::Installer::install_git"

    # Run tests
    Test::TestCase::install_git
}

function Test::TestCase::Unit::install_golang()
{
    # Run installation
    source "${PROJECT_TOP_DIR}/src/install_golang.sh"
    Test::Utils::test "PersonalSettings::Installer::install_golang" "PersonalSettings::Installer::install_golang_devtools"

    # Run tests
    Test::TestCase::install_golang
}

function Test::TestCase::Unit::install_java()
{
    # Run installation
    source "${PROJECT_TOP_DIR}/src/install_java.sh"
    Test::Utils::test "PersonalSettings::Installer::install_java_devtools" "PersonalSettings::Installer::install_java_devtools"

    # Run tests
    Test::TestCase::install_java
}

function Test::TestCase::Unit::install_latex()
{
    # Run installation
    source "${PROJECT_TOP_DIR}/src/install_latex.sh"
    Test::Utils::test "PersonalSettings::Installer::install_latex" "PersonalSettings::Installer::install_latex"

    # Run tests
    Test::TestCase::install_latex
}

function Test::TestCase::Unit::install_vagrant()
{
    # Run installation
    source "${PROJECT_TOP_DIR}/src/install_vagrant.sh"
    Test::Utils::test "PersonalSettings::Installer::install_vagrant" "PersonalSettings::Installer::install_vagrant"

    # Run tests
    Test::TestCase::install_vagrant
}

function Test::TestCase::Unit::install_virtualbox()
{
    # Run installation
    source "${PROJECT_TOP_DIR}/src/install_virtualbox.sh"
    Test::Utils::test "PersonalSettings::Installer::install_virtualbox" "PersonalSettings::Installer::install_virtualbox"

    # Run tests
    Test::TestCase::install_virtualbox
}

function Test::TestSuite::Unit::run()
{
    Test::TestCase::shellcheck

    Test::TestCase::Unit::package_manager

    Test::TestCase::Unit::install_c_cpp_devtools
    Test::TestCase::Unit::install_cli_utils
    Test::TestCase::Unit::install_docker
    Test::TestCase::Unit::install_fonts
    Test::TestCase::Unit::install_git
    Test::TestCase::Unit::install_golang
    Test::TestCase::Unit::install_java
    Test::TestCase::Unit::install_latex
    Test::TestCase::Unit::install_vagrant
    Test::TestCase::Unit::install_virtualbox
}

Test::TestSuite::Unit::run