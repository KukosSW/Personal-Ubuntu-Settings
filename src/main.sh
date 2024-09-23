#!/bin/bash

set -Eu

# Turn off most of the interactive prompts in apt
export DEBIAN_FRONTEND=noninteractive

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

INSTALL_CLI_UTILS_PATH="${PROJECT_TOP_DIR}/src/install_cli_utils.sh"
if [[ -f "${INSTALL_CLI_UTILS_PATH}" ]]; then
    # shellcheck source=/dev/null
    source "${INSTALL_CLI_UTILS_PATH}"
else
    echo "Error: Could not find install_cli_utils.sh at ${INSTALL_CLI_UTILS_PATH}"
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

INSTALL_C_CPP_DEVTOOLS_PATH="${PROJECT_TOP_DIR}/src/install_c_cpp_devtools.sh"
if [[ -f "${INSTALL_C_CPP_DEVTOOLS_PATH}" ]]; then
    # shellcheck source=/dev/null
    source "${INSTALL_C_CPP_DEVTOOLS_PATH}"
else
    echo "Error: Could not find install_c_cpp_devtools.sh at ${INSTALL_C_CPP_DEVTOOLS_PATH}"
    exit 1
fi

INSTALL_LATEX_PATH="${PROJECT_TOP_DIR}/src/install_latex.sh"
if [[ -f "${INSTALL_LATEX_PATH}" ]]; then
    # shellcheck source=/dev/null
    source "${INSTALL_LATEX_PATH}"
else
    echo "Error: Could not find install_latex.sh at ${INSTALL_LATEX_PATH}"
    exit 1
fi

INSTALL_VIRTUALBOX_PATH="${PROJECT_TOP_DIR}/src/install_virtualbox.sh"
if [[ -f "${INSTALL_VIRTUALBOX_PATH}" ]]; then
    # shellcheck source=/dev/null
    source "${INSTALL_VIRTUALBOX_PATH}"
else
    echo "Error: Could not find install_virtualbox.sh at ${INSTALL_VIRTUALBOX_PATH}"
    exit 1
fi

INSTALL_DOCKER_PATH="${PROJECT_TOP_DIR}/src/install_docker.sh"
if [[ -f "${INSTALL_DOCKER_PATH}" ]]; then
    # shellcheck source=/dev/null
    source "${INSTALL_DOCKER_PATH}"
else
    echo "Error: Could not find install_docker.sh at ${INSTALL_DOCKER_PATH}"
    exit 1
fi

INSTALL_VAGRANT_PATH="${PROJECT_TOP_DIR}/src/install_vagrant.sh"
if [[ -f "${INSTALL_VAGRANT_PATH}" ]]; then
    # shellcheck source=/dev/null
    source "${INSTALL_VAGRANT_PATH}"
else
    echo "Error: Could not find install_vagrant.sh at ${INSTALL_VAGRANT_PATH}"
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

# @brief Main function for the personal settings
#
# USAGE:
#  PersonalSettings::main
#
# @return 0 on success, exit 1 on failure
function PersonalSettings::main()
{
    PersonalSettings::Utils::Message::info "STARTING PERSONAL SETTINGS"

    # Sudo has 15 minutes timeout by default, because of that, in "random" moments the script will ask for the password.
    # To avoid that, we need to do 2 things:
    # 1. Run the script with sudo and provide the password at the beginning. (sudo -v)
    # 2. Run in background a process that will keep the sudo session alive. (while true; do sudo -v; sleep 60; done &)
    sudo -v
    while true; do sudo -v; sleep 60; done &

    # Show OS information
    PersonalSettings::OSInfo::print_full_info

    PersonalSettings::PackageManager::Apt::update || exit 1
    PersonalSettings::PackageManager::Apt::upgrade || exit 1
    PersonalSettings::PackageManager::Apt::full_upgrade || exit 1
    PersonalSettings::PackageManager::Apt::fix_broken || exit 1
    PersonalSettings::PackageManager::Apt::autoremove || exit 1
    PersonalSettings::PackageManager::Apt::clean || exit 1
    PersonalSettings::PackageManager::Apt::autoclean || exit 1

    PersonalSettings::Installer::install_cli_utils || exit 1

    PersonalSettings::Installer::install_git || exit 1
    PersonalSettings::Installer::install_c_cpp_devtools || exit 1
    PersonalSettings::Installer::install_latex || exit 1
    PersonalSettings::Installer::install_virtualbox || exit 1
    PersonalSettings::Installer::install_docker || exit 1
    PersonalSettings::Installer::install_vagrant || exit 1

    PersonalSettings::PackageManager::Apt::update || exit 1
    PersonalSettings::PackageManager::Apt::upgrade || exit 1
    PersonalSettings::PackageManager::Apt::full_upgrade || exit 1
    PersonalSettings::PackageManager::Apt::fix_broken || exit 1
    PersonalSettings::PackageManager::Apt::autoremove || exit 1
    PersonalSettings::PackageManager::Apt::clean || exit 1
    PersonalSettings::PackageManager::Apt::autoclean || exit 1

    PersonalSettings::Utils::Message::success "FINISHED PERSONAL SETTINGS"

    return 0
}

PersonalSettings::main