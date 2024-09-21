#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_TOP_DIR="${SCRIPT_DIR}/.."

# Prevent double sourcing
if [[ -n "${PERSONAL_SETTINGS_TEST_TESTCASES_SOURCED:-}" ]]; then
    return 0
fi

export PERSONAL_SETTINGS_TEST_TESTCASES_SOURCED=1

# source libraries
TEST_LIB_PATH="${PROJECT_TOP_DIR}/test/test_lib.sh"
if [[ -f "${TEST_LIB_PATH}" ]]; then
    # shellcheck source=/dev/null
    source "${TEST_LIB_PATH}"
else
    echo "Error: Could not find test_lib.sh at ${TEST_LIB_PATH}"
    exit 1
fi

function Test::TestCase::package_manager()
{
    source "${PROJECT_TOP_DIR}/src/package_manager.sh"

    Test::Utils::test "PackageManager::Apt::update" "PersonalSettings::PackageManager::Apt::update"
    Test::Utils::test "PackageManager::Apt::upgrade" "PersonalSettings::PackageManager::Apt::upgrade"
    Test::Utils::test "PackageManager::Apt::full_upgrade" "PersonalSettings::PackageManager::Apt::full_upgrade"
    Test::Utils::test "PackageManager::Apt::fix_broken" "PersonalSettings::PackageManager::Apt::fix_broken"
    Test::Utils::test "PackageManager::Apt::autoremove" "PersonalSettings::PackageManager::Apt::autoremove"
    Test::Utils::test "PackageManager::Apt::clean" "PersonalSettings::PackageManager::Apt::clean"
    Test::Utils::test "PackageManager::Apt::autoclean" "PersonalSettings::PackageManager::Apt::autoclean"
    Test::Utils::test "PackageManager::Apt::install bc" "PersonalSettings::PackageManager::Apt::install" "bc"
    Test::Utils::test "PackageManager::Apt::is_installed bc" "PersonalSettings::PackageManager::Apt::is_installed" "bc"
    Test::Utils::test "PackageManager::Apt::remove bc" "PersonalSettings::PackageManager::Apt::remove" "bc"
    Test::Utils::test "PackageManager::Apt::is_installed bc" "! PersonalSettings::PackageManager::Apt::is_installed" "bc"
    Test::Utils::test "PackageManager::Apt::install libssl-dev" "PersonalSettings::PackageManager::Apt::install" "libssl-dev"
    Test::Utils::test "PackageManager::Apt::is_installed libssl-dev" "PersonalSettings::PackageManager::Apt::is_installed" "libssl-dev"
    Test::Utils::test "PackageManager::Apt::remove libssl-dev" "PersonalSettings::PackageManager::Apt::remove" "libssl-dev"
    Test::Utils::test "PackageManager::Apt::is_installed libssl-dev" "! PersonalSettings::PackageManager::Apt::is_installed" "libssl-dev"
}

function Test::TestCase::install_c_cpp_devtools()
{
    Test::Utils::test "Installer::install_c_cpp_devtools::gcc" "gcc --version"
    Test::Utils::test "Installer::install_c_cpp_devtools::g++" "g++ --version"
    Test::Utils::test "Installer::install_c_cpp_devtools::gdb" "gdb --version"
    Test::Utils::test "Installer::install_c_cpp_devtools::clang" "clang --version"
    Test::Utils::test "Installer::install_c_cpp_devtools::make" "make --version"
    Test::Utils::test "Installer::install_c_cpp_devtools::cmake" "cmake --version"
    Test::Utils::test "Installer::install_c_cpp_devtools::valgrind" "valgrind --version"
    Test::Utils::test "Installer::install_c_cpp_devtools::cppcheck" "cppcheck --version"

    Test::Utils::test "Installer::install_c_cpp_devtools::doxygen" "doxygen --version"
    Test::Utils::test "Installer::install_c_cpp_devtools::pandoc" "pandoc --version"
    Test::Utils::test "Installer::install_c_cpp_devtools::groff" "groff --version"
    Test::Utils::test "Installer::install_c_cpp_devtools::bison" "bison --version"
    Test::Utils::test "Installer::install_c_cpp_devtools::strace" "strace --version"
    Test::Utils::test "Installer::install_c_cpp_devtools::ltrace" "ltrace --version"
}

function Test::TestCase::install_cli_utils()
{
    Test::Utils::test "Installer::install_cli_utils::curl" "curl --version"
    Test::Utils::test "Installer::install_cli_utils::gawk" "awk --version"
    Test::Utils::test "Installer::install_cli_utils::tree" "tree --version"
    Test::Utils::test "Installer::install_cli_utils::rsync" "rsync --version"
    Test::Utils::test "Installer::install_cli_utils::nmap" "nmap --version"
    Test::Utils::test "Installer::install_cli_utils::nala" "nala --version"
}

function Test::TestCase::install_docker()
{
    #shellcheck disable=SC2312
    if uname -r | grep -q "azure"; then
        PersonalSettings::Utils::Message::warning "Azure kernel detected. Skipping docker installation and tests"
        return 0
    elif [[ -f "/.dockerenv" ]]; then
        PersonalSettings::Utils::Message::warning "Docker container detected. Skipping docker installation and tests"
        return 0
    fi

    Test::Utils::test "Installer::install_docker::docker" "docker --version"
}

function Test::TestCase::install_git()
{
    Test::Utils::test "Installer::install_git::config::user" "git config --list | grep -q \"user.email=kukossw@gmail.com\""
    Test::Utils::test "Installer::install_git::config::editor" "git config --list | grep -q \"core.editor=nvim\""
    Test::Utils::test "Installer::install_git::config::alias" "git config --list | grep -q \"alias.ci=commit\""
}

function Test::TestCase::install_latex()
{
    Test::Utils::test "Installer::install_latex::texlive-full" "tex --version"
    Test::Utils::test "Installer::install_latex::latex" "latex --version"
    Test::Utils::test "Installer::install_latex::pdflatex" "pdflatex --version"
    Test::Utils::test "Installer::install_latex::gnuplot" "aspell --version"
}

function Test::TestCase::install_vagrant()
{
    Test::Utils::test "Installer::install_vagrant::vagrant" "vagrant --version"
}

function Test::TestCase::install_virtualbox()
{
    # virtualbox --version starts the GUI, so we need to use --help
    Test::Utils::test "Installer::install_virtualbox::virtualbox" "virtualbox --help"
    Test::Utils::test "Installer::install_virtualbox::vboxmanage" "vboxmanage --version"
}