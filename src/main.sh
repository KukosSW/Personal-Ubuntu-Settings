#!/bin/bash

set -Eu

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_TOP_DIR="${SCRIPT_DIR}/.."

# Prevent double sourcing
if [[ -n "${PERSONAL_SETTINGS_MAIN_SOURCED:-}" ]]; then
    return 0
fi

export PERSONAL_SETTINGS_MAIN_SOURCED=1

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

INSTALL_GIT_PATH="${PROJECT_TOP_DIR}/src/install_git.sh"
if [[ -f "${INSTALL_GIT_PATH}" ]]; then
    # shellcheck source=/dev/null
    source "${INSTALL_GIT_PATH}"
else
    echo "Error: Could not find install_git.sh at ${INSTALL_GIT_PATH}"
    exit 1
fi

function PersonalSettings::main()
{
    PersonalSettings::Utils::Message::info "STARTING PERSONAL SETTINGS"

    PersonalSettings::PackageManager::Apt::update
    PersonalSettings::PackageManager::Apt::upgrade
    PersonalSettings::PackageManager::Apt::full_upgrade
    PersonalSettings::PackageManager::Apt::fix_broken
    PersonalSettings::PackageManager::Apt::autoremove
    PersonalSettings::PackageManager::Apt::clean
    PersonalSettings::PackageManager::Apt::autoclean

    PersonalSettings::Installer::install_git

    PersonalSettings::Utils::Message::success "FINISHED PERSONAL SETTINGS"
}

PersonalSettings::main