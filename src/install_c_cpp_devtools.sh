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
# @return 0 on success, return 1 on failure
PersonalSettings::Installer::install_c_cpp_devtools()
{
    PersonalSettings::Utils::Message::info "Installing C/C++ development tools"

    # BUILD SYSTEMS
    PersonalSettings::Utils::Message::info "Installing build systems"

    PersonalSettings::PackageManager::Apt::install "build-essential" || return 1
    PersonalSettings::PackageManager::Apt::install "make" || return 1
    PersonalSettings::PackageManager::Apt::install "cmake" || return 1
    PersonalSettings::PackageManager::Apt::install "ninja-build" || return 1
    PersonalSettings::PackageManager::Apt::install "meson" || return 1
    PersonalSettings::PackageManager::Apt::install "autoconf" || return 1
    PersonalSettings::PackageManager::Apt::install "automake" || return 1
    PersonalSettings::PackageManager::Apt::install "pkg-config" || return 1
    PersonalSettings::PackageManager::Apt::install "ccache" || return 1

    PersonalSettings::Utils::Message::success "Build systems installed successfully"

    # COMPILERS
    PersonalSettings::Utils::Message::info "Installing compilers"

    PersonalSettings::PackageManager::Apt::install "gcc" || return 1
    PersonalSettings::PackageManager::Apt::install "g++" || return 1
    PersonalSettings::PackageManager::Apt::install "clang" || return 1

    PersonalSettings::Utils::Message::success "Compilers installed successfully"

    # DEBUGGERS
    PersonalSettings::Utils::Message::info "Installing debuggers"

    PersonalSettings::PackageManager::Apt::install "gdb" || return 1

    PersonalSettings::Utils::Message::success "Debuggers installed successfully"

    # STATIC ANALYSIS
    PersonalSettings::Utils::Message::info "Installing static analysis tools"

    PersonalSettings::PackageManager::Apt::install "valgrind" || return 1
    PersonalSettings::PackageManager::Apt::install "clang-format" || return 1
    PersonalSettings::PackageManager::Apt::install "clang-tidy" || return 1
    PersonalSettings::PackageManager::Apt::install "cppcheck" || return 1

    PersonalSettings::Utils::Message::success "Static analysis tools installed successfully"

    # DOCUMENTATION
    PersonalSettings::Utils::Message::info "Installing documentation tools"

    PersonalSettings::PackageManager::Apt::install "doxygen" || return 1
    PersonalSettings::PackageManager::Apt::install "graphviz" || return 1
    PersonalSettings::PackageManager::Apt::install "pandoc" || return 1
    PersonalSettings::PackageManager::Apt::install "groff" || return 1
    PersonalSettings::PackageManager::Apt::install "ghostscript" || return 1
    PersonalSettings::PackageManager::Apt::install "wkhtmltopdf" || return 1

    PersonalSettings::Utils::Message::success "Documentation tools installed successfully"


    # C/C++ Development utilities
    PersonalSettings::Utils::Message::info "Installing C/C++ development utilities"

    PersonalSettings::PackageManager::Apt::install "llvm" || return 1
    PersonalSettings::PackageManager::Apt::install "flex" || return 1
    PersonalSettings::PackageManager::Apt::install "bison" || return 1
    PersonalSettings::PackageManager::Apt::install "strace" || return 1
    PersonalSettings::PackageManager::Apt::install "ltrace" || return 1
    PersonalSettings::PackageManager::Apt::install "binutils" || return 1
    PersonalSettings::PackageManager::Apt::install "elfutils" || return 1

    PersonalSettings::Utils::Message::success "C/C++ development utilities installed successfully"

    # KERNEL DEVELOPMENT
    PersonalSettings::Utils::Message::info "Installing kernel development tools"

    #shellcheck disable=SC2312
    if uname -r | grep -q "azure"; then
        PersonalSettings::Utils::Message::warning "Azure kernel detected. Skipping kernel development tools installation"
    else
        #shellcheck disable=SC2312
        PersonalSettings::PackageManager::Apt::install "linux-headers-$(uname -r)" || return 1

        #shellcheck disable=SC2312
        PersonalSettings::PackageManager::Apt::install "linux-tools-$(uname -r)" || return 1
    fi

    PersonalSettings::PackageManager::Apt::install "libelf-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "libtool" || return 1
    PersonalSettings::PackageManager::Apt::install "libtool-bin" || return 1
    PersonalSettings::PackageManager::Apt::install "libtool-doc" || return 1

    PersonalSettings::Utils::Message::success "Kernel development tools installed successfully"


    # QEMU
    PersonalSettings::Utils::Message::info "Installing QEMU"

    PersonalSettings::PackageManager::Apt::add_repository "universe" || return 1

    PersonalSettings::PackageManager::Apt::install "qemu-system" || return 1
    PersonalSettings::PackageManager::Apt::install "qemu-system-x86" || return 1
    PersonalSettings::PackageManager::Apt::install "qemu-system-arm" || return 1
    PersonalSettings::PackageManager::Apt::install "qemu-system-mips" || return 1
    PersonalSettings::PackageManager::Apt::install "qemu-system-ppc" || return 1
    PersonalSettings::PackageManager::Apt::install "qemu-system-sparc" || return 1
    PersonalSettings::PackageManager::Apt::install "qemu-system-misc" || return 1
    PersonalSettings::PackageManager::Apt::install "qemu-system-gui" || return 1
    PersonalSettings::PackageManager::Apt::install "qemu-kvm" || return 1
    PersonalSettings::PackageManager::Apt::install "qemu-user-static" || return 1
    PersonalSettings::PackageManager::Apt::install "qemu-user-binfmt" || return 1
    PersonalSettings::PackageManager::Apt::install "qemu-efi-aarch64" || return 1
    PersonalSettings::PackageManager::Apt::install "qemu-efi-arm" || return 1
    PersonalSettings::PackageManager::Apt::install "ovmf" || return 1
    PersonalSettings::PackageManager::Apt::install "qemu-utils" || return 1
    PersonalSettings::PackageManager::Apt::install "virt-manager" || return 1
    PersonalSettings::PackageManager::Apt::install "libvirt-daemon-system" || return 1
    PersonalSettings::PackageManager::Apt::install "libvirt-clients" || return 1

    PersonalSettings::Utils::Message::success "QEMU installed successfully"

    # C/C++ Libraries
    PersonalSettings::Utils::Message::info "Installing C/C++ libraries"

    PersonalSettings::PackageManager::Apt::install "libssl-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "libcurl4-openssl-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "libreadline-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "libncurses5-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "libncursesw5-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "libsqlite3-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "libxml2-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "libxslt1-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "libyaml-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "libffi-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "libgdbm-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "libbz2-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "liblzma-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "libzstd-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "liblz4-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "libpcre2-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "libpcre3-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "libpcre-ocaml-dev" || return 1

    PersonalSettings::Utils::Message::success "C/C++ libraries installed successfully"

    # QT 5
    PersonalSettings::Utils::Message::info "Installing QT 5"

    PersonalSettings::PackageManager::Apt::install "qtbase5-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "qtchooser" || return 1
    PersonalSettings::PackageManager::Apt::install "qt5-qmake" || return 1
    PersonalSettings::PackageManager::Apt::install "qtbase5-dev-tools" || return 1
    PersonalSettings::PackageManager::Apt::install "qttools5-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "qttools5-dev-tools" || return 1
    PersonalSettings::PackageManager::Apt::install "qtcreator" || return 1
    PersonalSettings::PackageManager::Apt::install "libqt5widgets5" || return 1
    PersonalSettings::PackageManager::Apt::install "libqt5gui5" || return 1
    PersonalSettings::PackageManager::Apt::install "libqt5core5a" || return 1
    PersonalSettings::PackageManager::Apt::install "libqt5network5" || return 1
    PersonalSettings::PackageManager::Apt::install "libqt5multimedia5" || return 1
    PersonalSettings::PackageManager::Apt::install "libqt5multimedia5-plugins" || return 1
    PersonalSettings::PackageManager::Apt::install "qtmultimedia5-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "libqt5xml5" || return 1
    PersonalSettings::PackageManager::Apt::install "libqt5svg5-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "libqt5quick5" || return 1
    PersonalSettings::PackageManager::Apt::install "qtdeclarative5-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "libqt5sql5" || return 1
    PersonalSettings::PackageManager::Apt::install "libqt5sql5-sqlite" || return 1
    PersonalSettings::PackageManager::Apt::install "libqt5opengl5-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "qtquickcontrols2-5-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "qml-module-qtquick-controls2" || return 1
    PersonalSettings::PackageManager::Apt::install "qtwebengine5-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "qml-module-qtwebengine" || return 1

    PersonalSettings::Utils::Message::success "QT 5 installed successfully"

    # QT 6
    PersonalSettings::Utils::Message::info "Installing QT 6"

    PersonalSettings::PackageManager::Apt::install "qt6-base-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "qt6-base-dev-tools" || return 1
    PersonalSettings::PackageManager::Apt::install "qt6-tools-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "qt6-tools-dev-tools" || return 1
    PersonalSettings::PackageManager::Apt::install "qt6-l10n-tools" || return 1
    PersonalSettings::PackageManager::Apt::install "qt6-3d-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "qt6-svg-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "qt6-declarative-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "qt6-multimedia-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "qt6-networkauth-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "qt6-quick3d-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "qt6-quicktimeline-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "qt6-wayland-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "qt6-webengine-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "qt6-webview-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "qtcreator" || return 1

    PersonalSettings::Utils::Message::success "QT 6 installed successfully"

    PersonalSettings::Utils::Message::success "C/C++ development tools installed successfully"
}