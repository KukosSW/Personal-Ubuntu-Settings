#!/bin/bash

set -Eu

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_TOP_DIR="${SCRIPT_DIR}/.."

# Prevent double sourcing
if [[ -n "${PERSONAL_SETTINGS_INSTALLER_CCPP_DEVTOOLS_SOURCED:-}" ]]; then
    return 0
fi

export PERSONAL_SETTINGS_INSTALLER_CCPP_DEVTOOLS_SOURCED=1

# source libraries
MESSAGE_PATH="${PROJECT_TOP_DIR}/src/message.sh"
if [[ -f "${MESSAGE_PATH}" ]]; then
    # shellcheck source=/dev/null
    source "${MESSAGE_PATH}"
else
    echo "Error: Could not find message.sh at ${MESSAGE_PATH}"
    exit 1
fi

PACKAGE_MANAGER_PATH="${PROJECT_TOP_DIR}/src/package_manager.sh"
if [[ -f "${PACKAGE_MANAGER_PATH}" ]]; then
    # shellcheck source=/dev/null
    source "${PACKAGE_MANAGER_PATH}"
else
    echo "Error: Could not find package_manager.sh at ${PACKAGE_MANAGER_PATH}"
    exit 1
fi

# @brief Function to install C/C++ development tools
#
# USAGE:
#   PersonalSettings::Installer::install_c_cpp_devtools
#
# @return 0 on success, exit 1 on failure
PersonalSettings::Installer::install_c_cpp_devtools()
{
    PersonalSettings::Utils::Message::info "Installing C/C++ development tools"

    # BUILD SYSTEMS
    PersonalSettings::Utils::Message::info "Installing build systems"

    PersonalSettings::PackageManager::Apt::install "build-essential" || exit 1
    PersonalSettings::PackageManager::Apt::install "make" || exit 1
    PersonalSettings::PackageManager::Apt::install "cmake" || exit 1
    PersonalSettings::PackageManager::Apt::install "ninja-build" || exit 1
    PersonalSettings::PackageManager::Apt::install "meson" || exit 1
    PersonalSettings::PackageManager::Apt::install "autoconf" || exit 1
    PersonalSettings::PackageManager::Apt::install "automake" || exit 1
    PersonalSettings::PackageManager::Apt::install "pkg-config" || exit 1
    PersonalSettings::PackageManager::Apt::install "ccache" || exit 1

    PersonalSettings::Utils::Message::success "Build systems installed successfully"

    # COMPILERS
    PersonalSettings::Utils::Message::info "Installing compilers"

    PersonalSettings::PackageManager::Apt::install "gcc" || exit 1
    PersonalSettings::PackageManager::Apt::install "g++" || exit 1
    PersonalSettings::PackageManager::Apt::install "clang" || exit 1

    PersonalSettings::Utils::Message::success "Compilers installed successfully"

    # DEBUGGERS
    PersonalSettings::Utils::Message::info "Installing debuggers"

    PersonalSettings::PackageManager::Apt::install "gdb" || exit 1

    PersonalSettings::Utils::Message::success "Debuggers installed successfully"

    # STATIC ANALYSIS
    PersonalSettings::Utils::Message::info "Installing static analysis tools"

    PersonalSettings::PackageManager::Apt::install "valgrind" || exit 1
    PersonalSettings::PackageManager::Apt::install "clang-format" || exit 1
    PersonalSettings::PackageManager::Apt::install "clang-tidy" || exit 1
    PersonalSettings::PackageManager::Apt::install "cppcheck" || exit 1

    PersonalSettings::Utils::Message::success "Static analysis tools installed successfully"

    # DOCUMENTATION
    PersonalSettings::Utils::Message::info "Installing documentation tools"

    PersonalSettings::PackageManager::Apt::install "doxygen" || exit 1
    PersonalSettings::PackageManager::Apt::install "graphviz" || exit 1
    PersonalSettings::PackageManager::Apt::install "pandoc" || exit 1
    PersonalSettings::PackageManager::Apt::install "groff" || exit 1
    PersonalSettings::PackageManager::Apt::install "ghostscript" || exit 1
    PersonalSettings::PackageManager::Apt::install "wkhtmltopdf" || exit 1

    PersonalSettings::Utils::Message::success "Documentation tools installed successfully"


    # C/C++ Development utilities
    PersonalSettings::Utils::Message::info "Installing C/C++ development utilities"

    PersonalSettings::PackageManager::Apt::install "llvm" || exit 1
    PersonalSettings::PackageManager::Apt::install "flex" || exit 1
    PersonalSettings::PackageManager::Apt::install "bison" || exit 1
    PersonalSettings::PackageManager::Apt::install "strace" || exit 1
    PersonalSettings::PackageManager::Apt::install "ltrace" || exit 1
    PersonalSettings::PackageManager::Apt::install "binutils" || exit 1
    PersonalSettings::PackageManager::Apt::install "elfutils" || exit 1

    PersonalSettings::Utils::Message::success "C/C++ development utilities installed successfully"

    # KERNEL DEVELOPMENT
    PersonalSettings::Utils::Message::info "Installing kernel development tools"

    if uname -r | grep -q "azure"; then
        PersonalSettings::Utils::Message::warning "Azure kernel detected. Skipping kernel development tools installation"
    else
        #shellcheck disable=SC2312
        PersonalSettings::PackageManager::Apt::install "linux-headers-$(uname -r)" || exit 1

        #shellcheck disable=SC2312
        PersonalSettings::PackageManager::Apt::install "linux-tools-$(uname -r)" || exit 1
    fi

    PersonalSettings::PackageManager::Apt::install "libelf-dev" || exit 1
    PersonalSettings::PackageManager::Apt::install "libtool" || exit 1
    PersonalSettings::PackageManager::Apt::install "libtool-bin" || exit 1
    PersonalSettings::PackageManager::Apt::install "libtool-doc" || exit 1

    PersonalSettings::Utils::Message::success "Kernel development tools installed successfully"


    # QEMU
    PersonalSettings::Utils::Message::info "Installing QEMU"

    PersonalSettings::PackageManager::Apt::add_repository "universe" || exit 1

    PersonalSettings::PackageManager::Apt::install "qemu-system" || exit 1
    PersonalSettings::PackageManager::Apt::install "qemu-system-x86" || exit 1
    PersonalSettings::PackageManager::Apt::install "qemu-system-arm" || exit 1
    PersonalSettings::PackageManager::Apt::install "qemu-system-mips" || exit 1
    PersonalSettings::PackageManager::Apt::install "qemu-system-ppc" || exit 1
    PersonalSettings::PackageManager::Apt::install "qemu-system-sparc" || exit 1
    PersonalSettings::PackageManager::Apt::install "qemu-system-misc" || exit 1
    PersonalSettings::PackageManager::Apt::install "qemu-system-gui" || exit 1
    PersonalSettings::PackageManager::Apt::install "qemu-kvm" || exit 1
    PersonalSettings::PackageManager::Apt::install "qemu-user-static" || exit 1
    PersonalSettings::PackageManager::Apt::install "qemu-user-binfmt" || exit 1
    PersonalSettings::PackageManager::Apt::install "qemu-efi-aarch64" || exit 1
    PersonalSettings::PackageManager::Apt::install "qemu-efi-arm" || exit 1
    PersonalSettings::PackageManager::Apt::install "ovmf" || exit 1
    PersonalSettings::PackageManager::Apt::install "qemu-utils" || exit 1
    PersonalSettings::PackageManager::Apt::install "virt-manager" || exit 1
    PersonalSettings::PackageManager::Apt::install "libvirt-daemon-system" || exit 1
    PersonalSettings::PackageManager::Apt::install "libvirt-clients" || exit 1

    PersonalSettings::Utils::Message::success "QEMU installed successfully"

    # C/C++ Libraries
    PersonalSettings::Utils::Message::info "Installing C/C++ libraries"

    PersonalSettings::PackageManager::Apt::install "libssl-dev" || exit 1
    PersonalSettings::PackageManager::Apt::install "libcurl4-openssl-dev" || exit 1
    PersonalSettings::PackageManager::Apt::install "libreadline-dev" || exit 1
    PersonalSettings::PackageManager::Apt::install "libncurses5-dev" || exit 1
    PersonalSettings::PackageManager::Apt::install "libncursesw5-dev" || exit 1
    PersonalSettings::PackageManager::Apt::install "libsqlite3-dev" || exit 1
    PersonalSettings::PackageManager::Apt::install "libxml2-dev" || exit 1
    PersonalSettings::PackageManager::Apt::install "libxslt1-dev" || exit 1
    PersonalSettings::PackageManager::Apt::install "libyaml-dev" || exit 1
    PersonalSettings::PackageManager::Apt::install "libffi-dev" || exit 1
    PersonalSettings::PackageManager::Apt::install "libgdbm-dev" || exit 1
    PersonalSettings::PackageManager::Apt::install "libbz2-dev" || exit 1
    PersonalSettings::PackageManager::Apt::install "liblzma-dev" || exit 1
    PersonalSettings::PackageManager::Apt::install "libzstd-dev" || exit 1
    PersonalSettings::PackageManager::Apt::install "liblz4-dev" || exit 1
    PersonalSettings::PackageManager::Apt::install "libpcre2-dev" || exit 1
    PersonalSettings::PackageManager::Apt::install "libpcre3-dev" || exit 1
    PersonalSettings::PackageManager::Apt::install "libpcre-ocaml-dev" || exit 1

    PersonalSettings::Utils::Message::success "C/C++ libraries installed successfully"

    # QT 5
    PersonalSettings::Utils::Message::info "Installing QT 5"

    PersonalSettings::PackageManager::Apt::install "qtbase5-dev" || exit 1
    PersonalSettings::PackageManager::Apt::install "qtchooser" || exit 1
    PersonalSettings::PackageManager::Apt::install "qt5-qmake" || exit 1
    PersonalSettings::PackageManager::Apt::install "qtbase5-dev-tools" || exit 1
    PersonalSettings::PackageManager::Apt::install "qttools5-dev" || exit 1
    PersonalSettings::PackageManager::Apt::install "qttools5-dev-tools" || exit 1
    PersonalSettings::PackageManager::Apt::install "qtcreator" || exit 1
    PersonalSettings::PackageManager::Apt::install "libqt5widgets5" || exit 1
    PersonalSettings::PackageManager::Apt::install "libqt5gui5" || exit 1
    PersonalSettings::PackageManager::Apt::install "libqt5core5a" || exit 1
    PersonalSettings::PackageManager::Apt::install "libqt5network5" || exit 1
    PersonalSettings::PackageManager::Apt::install "libqt5multimedia5" || exit 1
    PersonalSettings::PackageManager::Apt::install "libqt5multimedia5-plugins" || exit 1
    PersonalSettings::PackageManager::Apt::install "qtmultimedia5-dev" || exit 1
    PersonalSettings::PackageManager::Apt::install "libqt5xml5" || exit 1
    PersonalSettings::PackageManager::Apt::install "libqt5svg5-dev" || exit 1
    PersonalSettings::PackageManager::Apt::install "libqt5quick5" || exit 1
    PersonalSettings::PackageManager::Apt::install "qtdeclarative5-dev" || exit 1
    PersonalSettings::PackageManager::Apt::install "libqt5sql5" || exit 1
    PersonalSettings::PackageManager::Apt::install "libqt5sql5-sqlite" || exit 1
    PersonalSettings::PackageManager::Apt::install "libqt5opengl5-dev" || exit 1
    PersonalSettings::PackageManager::Apt::install "qtquickcontrols2-5-dev" || exit 1
    PersonalSettings::PackageManager::Apt::install "qml-module-qtquick-controls2" || exit 1
    PersonalSettings::PackageManager::Apt::install "qtwebengine5-dev" || exit 1
    PersonalSettings::PackageManager::Apt::install "qml-module-qtwebengine" || exit 1

    PersonalSettings::Utils::Message::success "QT 5 installed successfully"

    # QT 6
    PersonalSettings::Utils::Message::info "Installing QT 6"

    PersonalSettings::PackageManager::Apt::install "qt6-base-dev" || exit 1
    PersonalSettings::PackageManager::Apt::install "qt6-base-dev-tools" || exit 1
    PersonalSettings::PackageManager::Apt::install "qt6-tools-dev" || exit 1
    PersonalSettings::PackageManager::Apt::install "qt6-tools-dev-tools" || exit 1
    PersonalSettings::PackageManager::Apt::install "qt6-l10n-tools" || exit 1
    PersonalSettings::PackageManager::Apt::install "qt6-3d-dev" || exit 1
    PersonalSettings::PackageManager::Apt::install "qt6-svg-dev" || exit 1
    PersonalSettings::PackageManager::Apt::install "qt6-declarative-dev" || exit 1
    PersonalSettings::PackageManager::Apt::install "qt6-multimedia-dev" || exit 1
    PersonalSettings::PackageManager::Apt::install "qt6-networkauth-dev" || exit 1
    PersonalSettings::PackageManager::Apt::install "qt6-quick3d-dev" || exit 1
    PersonalSettings::PackageManager::Apt::install "qt6-quicktimeline-dev" || exit 1
    PersonalSettings::PackageManager::Apt::install "qt6-wayland-dev" || exit 1
    PersonalSettings::PackageManager::Apt::install "qt6-webengine-dev" || exit 1
    PersonalSettings::PackageManager::Apt::install "qt6-webview-dev" || exit 1
    PersonalSettings::PackageManager::Apt::install "qtcreator" || exit 1

    PersonalSettings::Utils::Message::success "QT 6 installed successfully"

    PersonalSettings::Utils::Message::success "C/C++ development tools installed successfully"
}