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

# @brief Function to install JAVA development tools
#
# USAGE:
#   PersonalSettings::Installer::install_java_devtools
#
# @return 0 on success, return 1 on failure
PersonalSettings::Installer::install_java_devtools()
{
    PersonalSettings::Utils::Message::info "Installing JAVA Development Tools"

    # We can install default-jdk package to get the latest version of JAVA Development Kit
    # However, then we can't specify the version of JAVA Development Kit to install more libraries and debug symbols
    # So, we need to get the newest possible to install java version

    local java_newest_version
    # shellcheck disable=SC2312
    java_newest_version="$(apt-cache search openjdk 2>/dev/null | grep -Eo 'openjdk-[0-9]+-jdk' | sort -V | tail -n 1 | awk -F '-' '{print $2}')"
    if [[ -z "${java_newest_version}" ]]; then
        PersonalSettings::Utils::Message::error "Failed to get the newest JAVA Development Kit version"
        return 1
    fi

    PersonalSettings::Utils::Message::info "Installing JAVA Development Kit version: ${java_newest_version}"

    PersonalSettings::PackageManager::Apt::install "openjdk-${java_newest_version}-jdk" || return 1
    PersonalSettings::PackageManager::Apt::install "openjdk-${java_newest_version}-jre" || return 1
    PersonalSettings::PackageManager::Apt::install "openjdk-${java_newest_version}-dbg" || return 1
    PersonalSettings::PackageManager::Apt::install "openjdk-${java_newest_version}-doc" || return 1
    PersonalSettings::PackageManager::Apt::install "openjdk-${java_newest_version}-source" || return 1

    PersonalSettings::PackageManager::Apt::install "libasmtools-java" || return 1
    PersonalSettings::PackageManager::Apt::install "libeclipse-collections-java" || return 1
    PersonalSettings::PackageManager::Apt::install "libhsdis0-fcml" || return 1
    PersonalSettings::PackageManager::Apt::install "libjax-maven-plugin" || return 1
    PersonalSettings::PackageManager::Apt::install "java-package" || return 1

    PersonalSettings::PackageManager::Apt::install "maven" || return 1
    PersonalSettings::PackageManager::Apt::install "ant" || return 1
    PersonalSettings::PackageManager::Apt::install "gradle" || return 1

    PersonalSettings::PackageManager::Apt::install "visualvm" || return 1

    PersonalSettings::Utils::Message::success "Successfully installed JAVA Development Tools"

    return 0
}