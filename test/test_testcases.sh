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

MESSAGE_PATH="${PROJECT_TOP_DIR}/src/message.sh"
if [[ -f "${MESSAGE_PATH}" ]]; then
    # shellcheck source=/dev/null
    source "${MESSAGE_PATH}"
else
    echo "Error: Could not find message.sh at ${MESSAGE_PATH}"
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
    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::build-essential" "build-essential"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::make" "make"
    Test::Utils::is_command_available "Installer::install_c_cpp_devtools::cmd_available::make" "make"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::cmake" "cmake"
    Test::Utils::is_command_available "Installer::install_c_cpp_devtools::cmd_available::cmake" "cmake"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::ninja" "ninja-build"
    Test::Utils::is_command_available "Installer::install_c_cpp_devtools::cmd_available::ninja" "ninja"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::meson" "meson"
    Test::Utils::is_command_available "Installer::install_c_cpp_devtools::cmd_available::meson" "meson"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::autoconf" "autoconf"
    Test::Utils::is_command_available "Installer::install_c_cpp_devtools::cmd_available::autoconf" "autoconf"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::automake" "automake"
    Test::Utils::is_command_available "Installer::install_c_cpp_devtools::cmd_available::automake" "automake"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::pkg-config" "pkg-config"
    Test::Utils::is_command_available "Installer::install_c_cpp_devtools::cmd_available::pkg-config" "pkg-config"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::ccache" "ccache"
    Test::Utils::is_command_available "Installer::install_c_cpp_devtools::cmd_available::ccache" "ccache"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::gcc" "gcc"
    Test::Utils::is_command_available "Installer::install_c_cpp_devtools::cmd_available::gcc" "gcc"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::g++" "g++"
    Test::Utils::is_command_available "Installer::install_c_cpp_devtools::cmd_available::g++" "g++"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::clang" "clang"
    Test::Utils::is_command_available "Installer::install_c_cpp_devtools::cmd_available::clang" "clang"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::clang++" "clang++"
    Test::Utils::is_command_available "Installer::install_c_cpp_devtools::cmd_available::clang++" "clang++"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::gdb" "gdb"
    Test::Utils::is_command_available "Installer::install_c_cpp_devtools::cmd_available::gdb" "gdb"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::valgrind" "valgrind"
    Test::Utils::is_command_available "Installer::install_c_cpp_devtools::cmd_available::valgrind" "valgrind"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::clang-format" "clang-format"
    Test::Utils::is_command_available "Installer::install_c_cpp_devtools::cmd_available::clang-format" "clang-format"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::clang-tidy" "clang-tidy"
    Test::Utils::is_command_available "Installer::install_c_cpp_devtools::cmd_available::clang-tidy" "clang-tidy"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::cppcheck" "cppcheck"
    Test::Utils::is_command_available "Installer::install_c_cpp_devtools::cmd_available::cppcheck" "cppcheck"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::doxygen" "doxygen"
    Test::Utils::is_command_available "Installer::install_c_cpp_devtools::cmd_available::doxygen" "doxygen"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::graphviz" "graphviz"
    Test::Utils::is_command_available "Installer::install_c_cpp_devtools::cmd_available::dot" "dot"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::pandoc" "pandoc"
    Test::Utils::is_command_available "Installer::install_c_cpp_devtools::cmd_available::pandoc" "pandoc"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::groff" "groff"
    Test::Utils::is_command_available "Installer::install_c_cpp_devtools::cmd_available::groff" "groff"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::ghostscript" "ghostscript"
    Test::Utils::is_command_available "Installer::install_c_cpp_devtools::cmd_available::ghostscript" "ghostscript"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::wkhtmltopdf" "wkhtmltopdf"
    Test::Utils::is_command_available "Installer::install_c_cpp_devtools::cmd_available::wkhtmltopdf" "wkhtmltopdf"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::llvm" "llvm"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::flex" "flex"
    Test::Utils::is_command_available "Installer::install_c_cpp_devtools::cmd_available::flex" "flex"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::bison" "bison"
    Test::Utils::is_command_available "Installer::install_c_cpp_devtools::cmd_available::bison" "bison"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::strace" "strace"
    Test::Utils::is_command_available "Installer::install_c_cpp_devtools::cmd_available::strace" "strace"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::ltrace" "ltrace"
    Test::Utils::is_command_available "Installer::install_c_cpp_devtools::cmd_available::ltrace" "ltrace"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::binutils" "binutils"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::elfutils" "elfutils"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::libelf-dev" "libelf-dev"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::libtool" "libtool"
    Test::Utils::is_command_available "Installer::install_c_cpp_devtools::cmd_available::libtool" "libtool"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::qemu-x86" "qemu-system-x86"
    Test::Utils::is_command_available "Installer::install_c_cpp_devtools::cmd_available::qemu-x86" "qemu-system-x86_64"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::qemu-arm" "qemu-system-arm"
    Test::Utils::is_command_available "Installer::install_c_cpp_devtools::cmd_available::qemu-arm" "qemu-system-arm"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::qemu-mips" "qemu-system-mips"
    Test::Utils::is_command_available "Installer::install_c_cpp_devtools::cmd_available::qemu-mips" "qemu-system-mips"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::qemu-ppc" "qemu-system-ppc"
    Test::Utils::is_command_available "Installer::install_c_cpp_devtools::cmd_available::qemu-ppc" "qemu-system-ppc"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::qemu-sparc" "qemu-system-sparc"
    Test::Utils::is_command_available "Installer::install_c_cpp_devtools::cmd_available::qemu-sparc" "qemu-system-sparc"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::qemu-riscv" "qemu-system-misc"
    Test::Utils::is_command_available "Installer::install_c_cpp_devtools::cmd_available::qemu-riscv" "qemu-system-riscv64"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::qemu-user" "qemu-user"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::qemu-user-binfmt" "qemu-user-binfmt"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::qemu-utils" "qemu-utils"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::qemu-efi-arm" "qemu-efi-arm"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::qemu-efi-aarch64" "qemu-efi-aarch64"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::ovmf" "ovmf"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::virt-manager" "virt-manager"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::libvirt-daemon-system" "libvirt-daemon-system"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::libvirt-clients" "libvirt-clients"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::libssl-dev" "libssl-dev"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::libcurl4-openssl-dev" "libcurl4-openssl-dev"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::libreadline-dev" "libreadline-dev"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::libncurses-dev" "libncurses-dev"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::libsqlite3-dev" "libsqlite3-dev"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::libxml2-dev" "libxml2-dev"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::libxslt1-dev" "libxslt1-dev"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::libyaml-dev" "libyaml-dev"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::libffi-dev" "libffi-dev"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::libgdbm-dev" "libgdbm-dev"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::libbz2-dev" "libbz2-dev"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::liblzma-dev" "liblzma-dev"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::libzstd-dev" "libzstd-dev"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::liblz4-dev" "liblz4-dev"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::libpcre2-dev" "libpcre2-dev"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::libpcre3-dev" "libpcre3-dev"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::libpcre-ocaml-dev" "libpcre-ocaml-dev"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::qtbase5-dev" "qtbase5-dev"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::qtchooser" "qtchooser"
    Test::Utils::is_command_available "Installer::install_c_cpp_devtools::cmd_available::qtchooser" "qtchooser"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::qt5-qmake" "qt5-qmake"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::qtbase5-dev-tools" "qtbase5-dev-tools"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::qttools5-dev" "qttools5-dev"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::qttools5-dev-tools" "qttools5-dev-tools"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::qtcreator" "qtcreator"
    Test::Utils::is_command_available "Installer::install_c_cpp_devtools::cmd_available::qtcreator" "qtcreator"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::libqt5widgets5t64" "libqt5widgets5t64"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::libqt5gui5t64" "libqt5gui5t64"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::libqt5core5t64" "libqt5core5t64"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::libqt5network5t64" "libqt5network5t64"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::libqt5multimedia5" "libqt5multimedia5"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::libqt5multimedia5-plugins" "libqt5multimedia5-plugins"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::qtmultimedia5-dev" "qtmultimedia5-dev"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::libqt5xml5t64" "libqt5xml5t64"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::libqt5svg5-dev" "libqt5svg5-dev"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::libqt5quick5" "libqt5quick5"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::qtdeclarative5-dev" "qtdeclarative5-dev"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::libqt5sql5t64" "libqt5sql5t64"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::libqt5sql5-sqlite" "libqt5sql5-sqlite"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::libqt5opengl5-dev" "libqt5opengl5-dev"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::qtquickcontrols2-5-dev" "qtquickcontrols2-5-dev"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::qml-module-qtquick-controls2" "qml-module-qtquick-controls2"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::qtwebengine5-dev" "qtwebengine5-dev"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::qml-module-qtwebengine" "qml-module-qtwebengine"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::qt6-base-dev" "qt6-base-dev"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::qt6-base-dev-tools" "qt6-base-dev-tools"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::qt6-tools-dev" "qt6-tools-dev"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::qt6-tools-dev-tools" "qt6-tools-dev-tools"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::qt6-l10n-tools" "qt6-l10n-tools"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::qt6-3d-dev" "qt6-3d-dev"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::qt6-svg-dev" "qt6-svg-dev"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::qt6-declarative-dev" "qt6-declarative-dev"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::qt6-multimedia-dev" "qt6-multimedia-dev"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::qt6-networkauth-dev" "qt6-networkauth-dev"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::qt6-quick3d-dev" "qt6-quick3d-dev"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::qt6-quicktimeline-dev" "qt6-quicktimeline-dev"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::qt6-wayland-dev" "qt6-wayland-dev"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::qt6-webengine-dev" "qt6-webengine-dev"

    Test::Utils::is_installed         "Installer::install_c_cpp_devtools::installed::qt6-webview-dev" "qt6-webview-dev"
}

function Test::TestCase::install_cli_utils()
{
    Test::Utils::is_installed         "Installer::install_cli_utils::installed::bc" "bc"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::bc" "bc"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::curl" "curl"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::curl" "curl"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::wget" "wget"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::wget" "wget"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::tree" "tree"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::tree" "tree"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::tar" "tar"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::tar" "tar"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::gawk" "gawk"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::gawk" "gawk"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::sed" "sed"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::sed" "sed"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::grep" "grep"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::grep" "grep"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::apt-rdepends" "apt-rdepends"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::apt-rdepends" "apt-rdepends"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::plocate" "plocate"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::plocate" "plocate"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::htop" "htop"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::htop" "htop"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::btop" "btop"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::btop" "btop"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::neofetch" "neofetch"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::neofetch" "neofetch"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::fastfetch" "fastfetch"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::fastfetch" "fastfetch"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::unzip" "unzip"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::unzip" "unzip"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::zip" "zip"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::zip" "zip"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::gzip" "gzip"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::gzip" "gzip"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::bzip2" "bzip2"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::bzip2" "bzip2"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::xz-utils" "xz-utils"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::xz-utils" "xz"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::p7zip" "p7zip"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::p7zip" "p7zip"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::p7zip-full" "p7zip-full"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::rar" "rar"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::rar" "rar"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::unrar" "unrar"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::unrar" "unrar"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::lzma" "lzma"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::lzma" "lzma"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::zstd" "zstd"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::zstd" "zstd"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::arj" "arj"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::arj" "arj"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::net-tools" "net-tools"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::nmap" "nmap"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::nmap" "nmap"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::traceroute" "traceroute"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::traceroute" "traceroute"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::whois" "whois"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::whois" "whois"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::ipcalc" "ipcalc"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::ipcalc" "ipcalc"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::iputils-ping" "iputils-ping"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::ping" "ping"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::iputils-tracepath" "iputils-tracepath"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::tracepath" "tracepath"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::iputils-arping" "iputils-arping"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::arping" "arping"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::iproute2" "iproute2"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::ip" "ip"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::dnsutils" "dnsutils"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::dig" "dig"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::tcpdump" "tcpdump"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::tcpdump" "tcpdump"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::openssh-client" "openssh-client"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::ssh" "ssh"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::openssh-server" "openssh-server"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::sshd" "sshd"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::telnet" "telnet"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::telnet" "telnet"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::ftp" "ftp"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::ftp" "ftp"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::rsync" "rsync"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::rsync" "rsync"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::speedtest-cli" "speedtest-cli"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::speedtest-cli" "speedtest-cli"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::sshpass" "sshpass"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::sshpass" "sshpass"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::tmux" "tmux"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::tmux" "tmux"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::screen" "screen"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::screen" "screen"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::gnome-terminal" "gnome-terminal"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::gnome-terminal" "gnome-terminal"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::xfce4-terminal" "xfce4-terminal"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::xfce4-terminal" "xfce4-terminal"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::kitty" "kitty"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::kitty" "kitty"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::xterm" "xterm"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::xterm" "xterm"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::tilix" "tilix"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::tilix" "tilix"


    Test::Utils::is_installed         "Installer::install_cli_utils::installed::vim" "vim"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::vim" "vim"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::nano" "nano"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::nano" "nano"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::gedit" "gedit"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::gedit" "gedit"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::nvim" "neovim"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::nvim" "nvim"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::nala" "nala"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::nala" "nala"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::shellcheck" "shellcheck"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::shellcheck" "shellcheck"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::jq" "jq"
    Test::Utils::is_command_available "Installer::install_cli_utils::cmd_available::jq" "jq"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::software-properties-common" "software-properties-common"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::apt-transport-https" "apt-transport-https"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::ca-certificates" "ca-certificates"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::gnupg" "gnupg"

    Test::Utils::is_installed         "Installer::install_cli_utils::installed::gnupg-agent" "gnupg-agent"
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

    Test::Utils::is_installed         "Installer::install_docker::installed::docker" "docker-ce"
    Test::Utils::is_command_available "Installer::install_docker::cmd_available::docker" "docker"
}

function Test::TestCase::install_git()
{
    Test::Utils::is_installed         "Installer::install_git::installed::git" "git"
    Test::Utils::is_command_available "Installer::install_git::cmd_available::git" "git"

    Test::Utils::test "Installer::install_git::config::user" "git config --list | grep -q \"user.email=kukossw@gmail.com\""
    Test::Utils::test "Installer::install_git::config::editor" "git config --list | grep -q \"core.editor=nvim\""
    Test::Utils::test "Installer::install_git::config::alias" "git config --list | grep -q \"alias.ci=commit\""
}

function Test::TestCase::install_latex()
{
    Test::Utils::is_installed         "Installer::install_latex::installed::texlive-full" "texlive-full"
    Test::Utils::is_command_available "Installer::install_latex::cmd_available::tex" "tex"
    Test::Utils::is_command_available "Installer::install_latex::cmd_available::latex" "latex"
    Test::Utils::is_command_available "Installer::install_latex::cmd_available::pdflatex" "pdflatex"

    Test::Utils::is_installed         "Installer::install_latex::installed::texlive-latex-extra" "texlive-latex-extra"

    Test::Utils::is_installed         "Installer::install_latex::installed::texlive-latex-recommended" "texlive-latex-recommended"

    Test::Utils::is_installed         "Installer::install_latex::installed::texlive-fonts-extra" "texlive-fonts-extra"

    Test::Utils::is_installed         "Installer::install_latex::installed::texlive-fonts-recommended" "texlive-fonts-recommended"

    Test::Utils::is_installed         "Installer::install_latex::installed::texlive-lang-polish" "texlive-lang-polish"

    Test::Utils::is_installed         "Installer::install_latex::installed::texmaker" "texmaker"
    Test::Utils::is_command_available "Installer::install_latex::cmd_available::texmaker" "texmaker"

    Test::Utils::is_installed         "Installer::install_latex::installed::kile" "kile"
    Test::Utils::is_command_available "Installer::install_latex::cmd_available::kile" "kile"

    Test::Utils::is_installed         "Installer::install_latex::installed::texworks" "texworks"
    Test::Utils::is_command_available "Installer::install_latex::cmd_available::texworks" "texworks"

    Test::Utils::is_installed         "Installer::install_latex::installed::biber" "biber"
    Test::Utils::is_command_available "Installer::install_latex::cmd_available::biber" "biber"

    Test::Utils::is_installed         "Installer::install_latex::installed::texlive-bibtex-extra" "texlive-bibtex-extra"

    Test::Utils::is_installed         "Installer::install_latex::installed::imagemagick" "imagemagick"
    Test::Utils::is_command_available "Installer::install_latex::cmd_available::convert" "convert"

    Test::Utils::is_installed         "Installer::install_latex::installed::pdf2svg" "pdf2svg"
    Test::Utils::is_command_available "Installer::install_latex::cmd_available::pdf2svg" "pdf2svg"

    Test::Utils::is_installed         "Installer::install_latex::installed::ghostscript" "ghostscript"
    Test::Utils::is_command_available "Installer::install_latex::cmd_available::gs" "gs"

    Test::Utils::is_installed         "Installer::install_latex::installed::fontconfig" "fontconfig"
    Test::Utils::is_command_available "Installer::install_latex::cmd_available::fc-list" "fc-list"

    Test::Utils::is_installed         "Installer::install_latex::installed::gnuplot" "gnuplot"
    Test::Utils::is_command_available "Installer::install_latex::cmd_available::gnuplot" "gnuplot"

    Test::Utils::is_installed         "Installer::install_latex::installed::texlive-pictures" "texlive-pictures"

    Test::Utils::is_installed         "Installer::install_latex::installed::latexdiff" "latexdiff"
    Test::Utils::is_command_available "Installer::install_latex::cmd_available::latexdiff" "latexdiff"

    Test::Utils::is_installed         "Installer::install_latex::installed::aspell" "aspell"
    Test::Utils::is_command_available "Installer::install_latex::cmd_available::aspell" "aspell"

    Test::Utils::is_installed         "Installer::install_latex::installed::hunspell" "hunspell"
    Test::Utils::is_command_available "Installer::install_latex::cmd_available::hunspell" "hunspell"

    Test::Utils::is_installed         "Installer::install_latex::installed::pdftk" "pdftk-java"
    Test::Utils::is_command_available "Installer::install_latex::cmd_available::pdftk" "pdftk"

    Test::Utils::is_installed         "Installer::install_latex::installed::poppler-utils" "poppler-utils"
    Test::Utils::is_command_available "Installer::install_latex::cmd_available::pdfinfo" "pdfinfo"
}

function Test::TestCase::install_vagrant()
{
    Test::Utils::is_installed         "Installer::install_vagrant::installed::vagrant" "vagrant"
    Test::Utils::is_command_available "Installer::install_vagrant::cmd_available::vagrant" "vagrant"
}

function Test::TestCase::install_virtualbox()
{
    Test::Utils::is_installed         "Installer::install_virtualbox::installed::virtualbox" "virtualbox"
    Test::Utils::is_command_available "Installer::install_virtualbox::cmd_available::vboxmanage" "vboxmanage"
}