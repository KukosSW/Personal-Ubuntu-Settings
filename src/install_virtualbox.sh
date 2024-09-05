#!/bin/bash

set -Eu

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_TOP_DIR="${SCRIPT_DIR}/.."

# Prevent double sourcing
if [[ -n "${PERSONAL_SETTINGS_INSTALLER_VIRTUALBOX_SOURCED:-}" ]]; then
    return 0
fi

export PERSONAL_SETTINGS_INSTALLER_VIRTUALBOX_SOURCED=1

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

# @brief Function to install VirtualBox
#
# USAGE:
#   PersonalSettings::Installer::install_virtualbox
#
# @return 0 on success, return 1 on failure
PersonalSettings::Installer::install_virtualbox()
{
    PersonalSettings::Utils::Message::info "Installing VirtualBox"

    PersonalSettings::PackageManager::Apt::install "virtualbox" || return 1

    # Accept the license without user interaction
    echo virtualbox-ext-pack virtualbox-ext-pack/license select true | sudo debconf-set-selections
    PersonalSettings::PackageManager::Apt::install "virtualbox-ext-pack" || return 1

    PersonalSettings::PackageManager::Apt::install "virtualbox-guest-additions-iso" || return 1
    PersonalSettings::PackageManager::Apt::install "virtualbox-dkms" || return 1
    PersonalSettings::PackageManager::Apt::install "virtualbox-qt" || return 1
    PersonalSettings::PackageManager::Apt::install "virtualbox-guest-utils" || return 1
    PersonalSettings::PackageManager::Apt::install "virtualbox-guest-x11" || return 1

    PersonalSettings::Utils::Message::success "VirtualBox installed successfully"

    #shellcheck disable=SC2312
    if uname -r | grep -q "azure"; then
        PersonalSettings::Utils::Message::warning "Azure kernel detected. Skipping Linux ISOs download"
    elif [[ -f "/.dockerenv" ]]; then
        PersonalSettings::Utils::Message::warning "Docker container detected. Skipping Linux ISOs download"
    else
        PersonalSettings::Utils::Message::info "Downloading Linux ISOs to /home/${USER}/virtualbox/images"
        mkdir -p "/home/${USER}/virtualbox/images"

        # Ubuntu 24.04.1 LTS
        if [[ ! -f "/home/${USER}/virtualbox/images/ubuntu-24.04.1-desktop-amd64.iso" ]]; then
            PersonalSettings::Utils::Message::info "Downloading Ubuntu 24.04.1 LTS"
            wget -O "/home/${USER}/virtualbox/images/ubuntu-24.04.1-desktop-amd64.iso" "https://releases.ubuntu.com/24.04.1/ubuntu-24.04.1-desktop-amd64.iso" >/dev/null 2>&1
            PersonalSettings::Utils::Message::success "Ubuntu 24.04.1 LTS downloaded successfully"
        fi

        # Debian 12.7.0
        if [[ ! -f "/home/${USER}/virtualbox/images/debian-12.7.0-amd64-netinst.iso" ]]; then
            PersonalSettings::Utils::Message::info "Downloading Debian 12.7.0"
            wget -O "/home/${USER}/virtualbox/images/debian-12.7.0-amd64-netinst.iso" "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.7.0-amd64-netinst.iso" >/dev/null 2>&1
            PersonalSettings::Utils::Message::success "Debian 12.7.0 downloaded successfully"
        fi

        # Fedora 40 Workstation
        if [[ ! -f "/home/${USER}/virtualbox/images/Fedora-Workstation-Live-x86_64-40-1.14.iso" ]]; then
            PersonalSettings::Utils::Message::info "Downloading Fedora 40 Workstation"
            wget -O "/home/${USER}/virtualbox/images/Fedora-Workstation-Live-x86_64-40-1.14.iso" "https://download.fedoraproject.org/pub/fedora/linux/releases/40/Workstation/x86_64/iso/Fedora-Workstation-Live-x86_64-40-1.14.iso" >/dev/null 2>&1
            PersonalSettings::Utils::Message::success "Fedora 40 Workstation downloaded successfully"
        fi

        # Arch 2024.09.01
        if [[ ! -f "/home/${USER}/virtualbox/images/archlinux-2024.09.01-x86_64.iso" ]]; then
            PersonalSettings::Utils::Message::info "Downloading Arch 2024.09.01"
            wget -O "/home/${USER}/virtualbox/images/archlinux-2024.09.01-x86_64.iso" "https://mirror.rackspace.com/archlinux/iso/2024.09.01/archlinux-2024.09.01-x86_64.iso" >/dev/null 2>&1
            PersonalSettings::Utils::Message::success "Arch 2024.09.01 downloaded successfully"
        fi
    fi

    return 0
}