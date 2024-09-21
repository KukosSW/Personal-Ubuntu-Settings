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
    Test::Utils::test "Installer::install_c_cpp_devtools::make" "make --version"
    Test::Utils::test "Installer::install_c_cpp_devtools::cmake" "cmake --version"
    Test::Utils::test "Installer::install_c_cpp_devtools::ninja" "ninja --version"
    Test::Utils::test "Installer::install_c_cpp_devtools::meson" "meson --version"
    Test::Utils::test "Installer::install_c_cpp_devtools::autoconf" "autoconf --version"
    Test::Utils::test "Installer::install_c_cpp_devtools::automake" "automake --version"
    Test::Utils::test "Installer::install_c_cpp_devtools::pkg-config" "pkg-config --version"
    Test::Utils::test "Installer::install_c_cpp_devtools::ccache" "ccache --version"

    Test::Utils::test "Installer::install_c_cpp_devtools::gcc" "gcc --version"
    Test::Utils::test "Installer::install_c_cpp_devtools::g++" "g++ --version"
    Test::Utils::test "Installer::install_c_cpp_devtools::clang" "clang --version"
    Test::Utils::test "Installer::install_c_cpp_devtools::clang++" "clang++ --version"

    Test::Utils::test "Installer::install_c_cpp_devtools::gdb" "gdb --version"

    Test::Utils::test "Installer::install_c_cpp_devtools::valgrind" "valgrind --version"
    Test::Utils::test "Installer::install_c_cpp_devtools::clang-format" "clang-format --version"
    Test::Utils::test "Installer::install_c_cpp_devtools::clang-tidy" "clang-tidy --version"
    Test::Utils::test "Installer::install_c_cpp_devtools::cppcheck" "cppcheck --version"

    Test::Utils::test "Installer::install_c_cpp_devtools::doxygen" "doxygen --version"
    Test::Utils::test "Installer::install_c_cpp_devtools::graphviz" "dot -V"
    Test::Utils::test "Installer::install_c_cpp_devtools::pandoc" "pandoc --version"
    Test::Utils::test "Installer::install_c_cpp_devtools::groff" "groff --version"
    Test::Utils::test "Installer::install_c_cpp_devtools::ghostscript" "ghostscript --version"
    Test::Utils::test "Installer::install_c_cpp_devtools::wkhtmltopdf" "wkhtmltopdf --version"

    Test::Utils::test "Installer::install_c_cpp_devtools::flex" "flex --version"
    Test::Utils::test "Installer::install_c_cpp_devtools::bison" "bison --version"
    Test::Utils::test "Installer::install_c_cpp_devtools::strace" "strace --version"
    Test::Utils::test "Installer::install_c_cpp_devtools::ltrace" "ltrace --version"

    Test::Utils::test "Installer::install_c_cpp_devtools::libtool" "libtool --version"
    Test::Utils::test "Installer::install_c_cpp_devtools::libtoolize" "libtoolize --version"

    Test::Utils::test "Installer::install_c_cpp_devtools::qemu-x86" "qemu-system-x86_64 --version"
    Test::Utils::test "Installer::install_c_cpp_devtools::qemu-arm" "qemu-system-arm --version"
    Test::Utils::test "Installer::install_c_cpp_devtools::qemu-mips" "qemu-system-mips --version"
    Test::Utils::test "Installer::install_c_cpp_devtools::qemu-ppc" "qemu-system-ppc --version"
    Test::Utils::test "Installer::install_c_cpp_devtools::qemu-sparc" "qemu-system-sparc --version"
    Test::Utils::test "Installer::install_c_cpp_devtools::qemu-riscv" "qemu-system-riscv64 --version"
}

function Test::TestCase::install_cli_utils()
{
    Test::Utils::test "Installer::install_cli_utils::bc" "bc --version"
    Test::Utils::test "Installer::install_cli_utils::curl" "curl --version"
    Test::Utils::test "Installer::install_cli_utils::wget" "wget --version"
    Test::Utils::test "Installer::install_cli_utils::tree" "tree --version"
    Test::Utils::test "Installer::install_cli_utils::tar" "tar --version"
    Test::Utils::test "Installer::install_cli_utils::gawk" "gawk --version"
    Test::Utils::test "Installer::install_cli_utils::awk" "awk --version"
    Test::Utils::test "Installer::install_cli_utils::sed" "sed --version"
    Test::Utils::test "Installer::install_cli_utils::grep" "grep --version"

    Test::Utils::test "Installer::install_cli_utils::htop" "htop --version"
    Test::Utils::test "Installer::install_cli_utils::btop" "btop --version"
    Test::Utils::test "Installer::install_cli_utils::neofetch" "command -v neofetch"

    Test::Utils::test "Installer::install_cli_utils::unzip" "command -v unzip"
    Test::Utils::test "Installer::install_cli_utils::zip" "zip --version"
    Test::Utils::test "Installer::install_cli_utils::gzip" "gzip --version"
    Test::Utils::test "Installer::install_cli_utils::bzip2" "bzip2 --version"
    Test::Utils::test "Installer::install_cli_utils::xz-utils" "xz --version"
    Test::Utils::test "Installer::install_cli_utils::p7zip" "command -v 7z"
    Test::Utils::test "Installer::install_cli_utils::rar" "command -v rar"
    Test::Utils::test "Installer::install_cli_utils::unrar" "command -v unrar"
    Test::Utils::test "Installer::install_cli_utils::lzma" "lzma --version"
    Test::Utils::test "Installer::install_cli_utils::zstd" "zstd --version"
    Test::Utils::test "Installer::install_cli_utils::arj" "command -v arj"

    Test::Utils::test "Installer::install_cli_utils::net-tools" "ifconfig --version"
    Test::Utils::test "Installer::install_cli_utils::nmap" "nmap --version"
    Test::Utils::test "Installer::install_cli_utils::traceroute" "traceroute --version"
    Test::Utils::test "Installer::install_cli_utils::whois" "whois --version"
    Test::Utils::test "Installer::install_cli_utils::ipcalc" "ipcalc --version"
    Test::Utils::test "Installer::install_cli_utils::iputils-ping" "command -v ping"
    Test::Utils::test "Installer::install_cli_utils::iputils-tracepath" "command -v tracepath"
    Test::Utils::test "Installer::install_cli_utils::iputils-arping" "command -v arping"
    Test::Utils::test "Installer::install_cli_utils::iproute2" "command -v ip"
    Test::Utils::test "Installer::install_cli_utils::dnsutils" "command -v dig"
    Test::Utils::test "Installer::install_cli_utils::tcpdump" "tcpdump --version"
    Test::Utils::test "Installer::install_cli_utils::openssh-client" "command -v ssh"
    Test::Utils::test "Installer::install_cli_utils::openssh-server" "command -v sshd"
    Test::Utils::test "Installer::install_cli_utils::telnet" "telnet --version"
    Test::Utils::test "Installer::install_cli_utils::ftp" "command -v ftp"
    Test::Utils::test "Installer::install_cli_utils::rsync" "rsync --version"
    Test::Utils::test "Installer::install_cli_utils::speedtest-cli" "speedtest --version"
    Test::Utils::test "Installer::install_cli_utils::sshpass" "command -v sshpass"

    Test::Utils::test "Installer::install_cli_utils::tmux" "command -v tmux"
    Test::Utils::test "Installer::install_cli_utils::screen" "command -v screen"
    Test::Utils::test "Installer::install_cli_utils::gnome-terminal" "command -v gnome-terminal"
    Test::Utils::test "Installer::install_cli_utils::xfce4-terminal" "command -v xfce4-terminal"
    Test::Utils::test "Installer::install_cli_utils::kitty" "command -v kitty"
    Test::Utils::test "Installer::install_cli_utils::xterm" "command -v xterm"
    Test::Utils::test "Installer::install_cli_utils::tilix" "command -v tilix"

    Test::Utils::test "Installer::install_cli_utils::vim" "vim --version"
    Test::Utils::test "Installer::install_cli_utils::nano" "nano --version"
    Test::Utils::test "Installer::install_cli_utils::gedit" "gedit --version"
    Test::Utils::test "Installer::install_cli_utils::nvim" "nvim --version"

    Test::Utils::test "Installer::install_cli_utils::nala" "nala --version"
    Test::Utils::test "Installer::install_cli_utils::shellcheck" "shellcheck --version"
    Test::Utils::test "Installer::install_cli_utils::jq" "jq --version"
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
    Test::Utils::test "Installer::install_git::git" "git --version"
    Test::Utils::test "Installer::install_git::config::user" "git config --list | grep -q \"user.email=kukossw@gmail.com\""
    Test::Utils::test "Installer::install_git::config::editor" "git config --list | grep -q \"core.editor=nvim\""
    Test::Utils::test "Installer::install_git::config::alias" "git config --list | grep -q \"alias.ci=commit\""
}

function Test::TestCase::install_latex()
{
    Test::Utils::test "Installer::install_latex::latex" "latex --version"
    Test::Utils::test "Installer::install_latex::biber" "biber --version"
    Test::Utils::test "Installer::install_latex::imagemagick" "convert --version"
    Test::Utils::test "Installer::install_latex::pdf2svg" "command -v pdf2svg"
    Test::Utils::test "Installer::install_latex::ghostscript" "gs --version"
    Test::Utils::test "Installer::install_latex::texlive-full" "tex --version"
    Test::Utils::test "Installer::install_latex::pdflatex" "pdflatex --version"
    Test::Utils::test "Installer::install_latex::fontconfig" "fc-list"
    Test::Utils::test "Installer::install_latex::gnuplot" "gnuplot --version"
    Test::Utils::test "Installer::install_latex::latexdiff" "latexdiff --version"
    Test::Utils::test "Installer::install_latex::aspell" "aspell --version"
    Test::Utils::test "Installer::install_latex::hunspell" "hunspell --version"
    Test::Utils::test "Installer::install_latex::pdftk" "pdftk --version"
    Test::Utils::test "Installer::install_latex::poppler-utils" "command -v pdfinfo"
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