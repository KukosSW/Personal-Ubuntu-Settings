#!/bin/bash

set -Eu

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_TOP_DIR="${SCRIPT_DIR}/.."

# Prevent double sourcing
if [[ -n "${PERSONAL_SETTINGS_INSTALLER_VAGRANT_SOURCED:-}" ]]; then
    return 0
fi

export PERSONAL_SETTINGS_INSTALLER_VAGRANT_SOURCED=1

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

# @brief Function to install vagrant
#
# USAGE:
#   PersonalSettings::Installer::install_vagrant
#
# @return 0 on success, return 1 on failure
PersonalSettings::Installer::install_vagrant()
{
    PersonalSettings::Utils::Message::info "Installing vagrant"

    if command -v vagrant &> /dev/null; then
        PersonalSettings::Utils::Message::info "Vagrant is already installed"
        return 0
    fi

    local ubuntu_version
    ubuntu_version=$(lsb_release -cs)

    # --spider option in wget checks if the file exists without downloading it
    if wget -q --spider "https://apt.releases.hashicorp.com/dists/${ubuntu_version}/Release"; then
        PersonalSettings::Utils::Message::info "Hashicorp repository found for Ubuntu ${ubuntu_version}"

         # shellcheck disable=SC2312
        wget -qO- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg >/dev/null 2>&1 || return 1

        # shellcheck disable=SC2312
        echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
            | sudo tee /etc/apt/sources.list.d/hashicorp.list >/dev/null 2>&1 || return 1

        PersonalSettings::PackageManager::Apt::update || return 1

        PersonalSettings::PackageManager::Apt::install "vagrant" || return 1

        PersonalSettings::Utils::Message::success "Vagrant installed successfully"
    else
        PersonalSettings::Utils::Message::warning "Hashicorp repository not found for Ubuntu ${ubuntu_version}, installing vagrant from .deb file"

        PersonalSettings::PackageManager::Apt::install "curl" || return 1
        PersonalSettings::PackageManager::Apt::install "jq" || return 1

        local vagrant_version
        # shellcheck disable=SC2312
        vagrant_version=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/vagrant | jq -r '.current_version')
        wget -q "https://releases.hashicorp.com/vagrant/${vagrant_version}/vagrant_${vagrant_version}-1_amd64.deb"

        sudo dpkg -i "vagrant_${vagrant_version}-1_amd64.deb" >/dev/null 2>&1 || return 1
        rm -rf "vagrant_${vagrant_version}-1_amd64.deb"

        PersonalSettings::PackageManager::Apt::fix_broken || return 1

        PersonalSettings::Utils::Message::success "Vagrant installed successfully"
    fi

    # PLUGINS
    PersonalSettings::Utils::Message::info "Installing vagrant plugins"

    vagrant plugin install vagrant-scp >/dev/null 2>&1 || return 1
    vagrant plugin install vagrant-disksize >/dev/null 2>&1 || return 1
    vagrant plugin install vagrant-vbguest >/dev/null 2>&1 || return 1
    vagrant plugin install vagrant-timezone >/dev/null 2>&1 || return 1
    vagrant plugin install vbinfo >/dev/null 2>&1 || return 1

    PersonalSettings::Utils::Message::success "Vagrant plugins installed successfully"

    return 0
}