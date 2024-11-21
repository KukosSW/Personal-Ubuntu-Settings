#!/usr/bin/env bash

set -Eu

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_TOP_DIR="${SCRIPT_DIR}/.."

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

OSINFO_PATH="${PROJECT_TOP_DIR}/src/osinfo.sh"
if [[ -f "${OSINFO_PATH}" ]]; then
    # shellcheck source=/dev/null
    source "${OSINFO_PATH}"
else
    echo "Error: Could not find osinfo.sh at ${OSINFO_PATH}"
    exit 1
fi

# @brief Function to install docker
#
# USAGE:
#   PersonalSettings::Installer::install_docker
#
# @return 0 on success, return 1 on failure
PersonalSettings::Installer::install_docker()
{
    PersonalSettings::Utils::Message::info "Installing docker"

    if PersonalSettings::OSInfo::is_ci; then
        PersonalSettings::Utils::Message::warning "CI environment detected. Skipping docker installation"
        return 0
    fi

    if PersonalSettings::OSInfo::is_container; then
        PersonalSettings::Utils::Message::warning "Container environment detected. Skipping docker installation"
        return 0
    fi

    if command -v docker &> /dev/null; then
        PersonalSettings::Utils::Message::info "Docker is already installed"
        return 0
    fi

    PersonalSettings::PackageManager::Apt::install "ca-certificates" || return 1
    PersonalSettings::PackageManager::Apt::install "curl" || return 1

    # Add Docker's official GPG key
    PersonalSettings::Utils::Message::info "Adding Docker's official GPG key"

    sudo install -m 0755 -d /etc/apt/keyrings >/dev/null 2>&1 || return 1
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc >/dev/null 2>&1 || return 1
    sudo chmod a+r /etc/apt/keyrings/docker.asc >/dev/null 2>&1 || return 1

    # Add Docker's repository
    PersonalSettings::Utils::Message::info "Adding Docker's repository"

    # shellcheck disable=SC2312
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "${VERSION_CODENAME}") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Install Docker
    PersonalSettings::PackageManager::Apt::update || return 1
    PersonalSettings::PackageManager::Apt::install "docker-ce" || return 1
    PersonalSettings::PackageManager::Apt::install "docker-ce-cli" || return 1
    PersonalSettings::PackageManager::Apt::install "containerd.io" || return 1
    PersonalSettings::PackageManager::Apt::install "docker-buildx-plugin" || return 1
    PersonalSettings::PackageManager::Apt::install "docker-compose-plugin" || return 1

    # Add user to docker group
    PersonalSettings::Utils::Message::info "Adding user to docker group"
    sudo usermod -aG docker "${USER}" >/dev/null 2>&1 || return 1

    PersonalSettings::Utils::Message::success "Docker installed successfully"

    return 0
}






