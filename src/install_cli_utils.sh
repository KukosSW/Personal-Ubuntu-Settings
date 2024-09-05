#!/bin/bash

set -Eu

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_TOP_DIR="${SCRIPT_DIR}/.."

# Prevent double sourcing
if [[ -n "${PERSONAL_SETTINGS_INSTALLER_CLI_UTILS_SOURCED:-}" ]]; then
    return 0
fi

export PERSONAL_SETTINGS_INSTALLER_CLI_UTILS_SOURCED=1

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

# @brief Function to install CLI utilities
#
# USAGE:
#   PersonalSettings::Installer::install_cli_utils
#
# @return 0 on success, return 1 on failure
PersonalSettings::Installer::install_cli_utils()
{
    PersonalSettings::Utils::Message::info "Installing CLI utilities"

    # FUNDAMENTAL UTILITIES
    PersonalSettings::PackageManager::Apt::install "bc" || return 1
    PersonalSettings::PackageManager::Apt::install "curl" || return 1
    PersonalSettings::PackageManager::Apt::install "wget" || return 1
    PersonalSettings::PackageManager::Apt::install "tree" || return 1
    PersonalSettings::PackageManager::Apt::install "tar" || return 1
    PersonalSettings::PackageManager::Apt::install "gawk" || return 1
    PersonalSettings::PackageManager::Apt::install "sed" || return 1
    PersonalSettings::PackageManager::Apt::install "grep" || return 1

    # MONITORING UTILITIES
    PersonalSettings::PackageManager::Apt::install "htop" || return 1
    PersonalSettings::PackageManager::Apt::install "btop" || return 1
    PersonalSettings::PackageManager::Apt::install "neofetch" || return 1

    # COMPRESSION UTILITIES
    PersonalSettings::PackageManager::Apt::install "unzip" || return 1
    PersonalSettings::PackageManager::Apt::install "zip" || return 1
    PersonalSettings::PackageManager::Apt::install "gzip" || return 1
    PersonalSettings::PackageManager::Apt::install "bzip2" || return 1
    PersonalSettings::PackageManager::Apt::install "xz-utils" || return 1
    PersonalSettings::PackageManager::Apt::install "p7zip" || return 1
    PersonalSettings::PackageManager::Apt::install "p7zip-full" || return 1
    PersonalSettings::PackageManager::Apt::install "rar" || return 1
    PersonalSettings::PackageManager::Apt::install "unrar" || return 1
    PersonalSettings::PackageManager::Apt::install "lzma" || return 1
    PersonalSettings::PackageManager::Apt::install "zstd" || return 1
    PersonalSettings::PackageManager::Apt::install "arj" || return 1

    # NETWORK UTILITIES
    PersonalSettings::PackageManager::Apt::install "net-tools" || return 1
    PersonalSettings::PackageManager::Apt::install "nmap" || return 1
    PersonalSettings::PackageManager::Apt::install "traceroute" || return 1
    PersonalSettings::PackageManager::Apt::install "whois" || return 1
    PersonalSettings::PackageManager::Apt::install "ipcalc" || return 1
    PersonalSettings::PackageManager::Apt::install "iputils-ping" || return 1
    PersonalSettings::PackageManager::Apt::install "iputils-tracepath" || return 1
    PersonalSettings::PackageManager::Apt::install "iputils-arping" || return 1
    PersonalSettings::PackageManager::Apt::install "iproute2" || return 1
    PersonalSettings::PackageManager::Apt::install "dnsutils" || return 1
    PersonalSettings::PackageManager::Apt::install "tcpdump" || return 1
    PersonalSettings::PackageManager::Apt::install "openssh-client" || return 1
    PersonalSettings::PackageManager::Apt::install "openssh-server" || return 1
    PersonalSettings::PackageManager::Apt::install "telnet" || return 1
    PersonalSettings::PackageManager::Apt::install "ftp" || return 1
    PersonalSettings::PackageManager::Apt::install "rsync" || return 1
    PersonalSettings::PackageManager::Apt::install "speedtest-cli" || return 1

    # TERMINAL UTILITIES
    PersonalSettings::PackageManager::Apt::install "tmux" || return 1
    PersonalSettings::PackageManager::Apt::install "screen" || return 1
    PersonalSettings::PackageManager::Apt::install "gnome-terminal" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-terminal" || return 1
    PersonalSettings::PackageManager::Apt::install "kitty" || return 1
    PersonalSettings::PackageManager::Apt::install "xterm" || return 1
    PersonalSettings::PackageManager::Apt::install "tilix" || return 1

    # OTHER UTILITIES
    PersonalSettings::PackageManager::Apt::install "nala" || return 1
    PersonalSettings::PackageManager::Apt::install "shellcheck" || return 1
    PersonalSettings::PackageManager::Apt::install "software-properties-common" || return 1

    PersonalSettings::Utils::Message::success "CLI utilities installed"

    return 0
}