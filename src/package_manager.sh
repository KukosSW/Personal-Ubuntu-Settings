#!/usr/bin/env bash

set -Eu

# Turn off most of the interactive prompts in apt
export DEBIAN_FRONTEND=noninteractive

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

# @brief Function to check if a package is installed
#
# USAGE:
#   PersonalSettings::PackageManager::Apt::is_installed "package_name"
# OUTPUT:
#   None
#
# @param $1 - Package name to check
#
# @return 0 if package is installed, 1 otherwise
function PersonalSettings::PackageManager::Apt::is_installed()
{
    local package_name="${1}"
    (apt -qq list "${package_name}" --installed 2>/dev/null || true) | grep -q "${package_name}"

    return $?
}

# @brief Function to update apt package list by using sudo apt update command
# The function is silent and only prints the output if the update fails
#
# USAGE:
#   PersonalSettings::PackageManager::Apt::update
# OUTPUT:
#   None
#
# @return 0 if the update is successful, 1 otherwise
function PersonalSettings::PackageManager::Apt::update()
{
    # We dont want to spam the user with apt update logs
    # so we will redirect the output to a temp file
    # and only print the log file if the update fails
    local temp_log_file
    temp_log_file=$(mktemp)

    PersonalSettings::Utils::Message::info "Updating apt package list ... (sudo apt update)"

    # Shellcheck SC2024: redirection is not affected by sudo.
    # We can suppress it, because we where created the temp file with user permissions
    # So the user without sudo permissions can write to the file and read it
    # shellcheck disable=SC2024
    if sudo DEBIAN_FRONTEND=noninteractive apt update >"${temp_log_file}" 2>&1; then
        PersonalSettings::Utils::Message::success "Apt package list updated successfully"

        rm -f "${temp_log_file}"
        return 0
    else
        PersonalSettings::Utils::Message::error "Failed to update apt package list"

        cat "${temp_log_file}" >&2

        rm -f "${temp_log_file}"
        return 1
    fi
}

# @brief Function to upgrade apt packages by using sudo apt upgrade -y command
# The function is silent and only prints the output if the upgrade fails
#
# USAGE:
#   PersonalSettings::PackageManager::Apt::upgrade
# OUTPUT:
#   None
#
# @return 0 if the upgrade is successful, 1 otherwise
function PersonalSettings::PackageManager::Apt::upgrade()
{
    # We dont want to spam the user with apt update logs
    # so we will redirect the output to a temp file
    # and only print the log file if the update fails
    local temp_log_file
    temp_log_file=$(mktemp)

    PersonalSettings::Utils::Message::info "Upgrading apt packages ... (sudo apt upgrade -y)"

    # Shellcheck SC2024: redirection is not affected by sudo.
    # We can suppress it, because we where created the temp file with user permissions
    # So the user without sudo permissions can write to the file and read it
    # shellcheck disable=SC2024
    if sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y >"${temp_log_file}" 2>&1; then
        PersonalSettings::Utils::Message::success "Apt package list upgraded successfully"

        rm -f "${temp_log_file}"
        return 0
    else
        PersonalSettings::Utils::Message::error "Failed to upgrade apt package list"

        cat "${temp_log_file}" >&2

        rm -f "${temp_log_file}"
        return 1
    fi
}

# @brief Function to install a package by using sudo apt install -y command
# The function is silent and only prints the output if the installation fails
#
# USAGE:
#   PersonalSettings::PackageManager::Apt::install "package_name"
# OUTPUT:
#   None
#
# @param $1 - Package name to install
# @param [optional] $2 - Additional options to pass to the apt install command (e.g. -o Dpkg::Options::="--force-confdef")
#
# @return 0 if the installation is successful, 1 otherwise
function PersonalSettings::PackageManager::Apt::install()
{
    # We dont want to spam the user with apt update logs
    # so we will redirect the output to a temp file
    # and only print the log file if the update fails
    local temp_log_file
    temp_log_file=$(mktemp)

    local package_name="${1}"

    if PersonalSettings::PackageManager::Apt::is_installed "${package_name}"; then
        PersonalSettings::Utils::Message::info "Package: ${package_name} is already installed"
        return 0
    fi

    # To make it simple, let split this function into 2 cases
    # 1. If there is no additional options
    # 2. If there are additional options
    # Case 1
    if [[ "$#" -lt 2 ]]; then
        PersonalSettings::Utils::Message::info "Installing package: ${package_name} ... (sudo apt install -y ${package_name})"

        # Shellcheck SC2024: redirection is not affected by sudo.
        # We can suppress it, because we where created the temp file with user permissions
        # So the user without sudo permissions can write to the file and read it
        # shellcheck disable=SC2024
        if sudo DEBIAN_FRONTEND=noninteractive apt install -y "${package_name}" >"${temp_log_file}" 2>&1; then
            PersonalSettings::Utils::Message::success "Package: ${package_name} installed successfully"

            rm -f "${temp_log_file}"
            return 0
        else
            PersonalSettings::Utils::Message::error "Failed to install package: ${package_name}"

            cat "${temp_log_file}" >&2

            rm -f "${temp_log_file}"
            return 1
        fi
    # Case 2
    else
        # From 2nd argument to the end of the arguments are additional options
        # Shift 1 to get them all easily to the array
        shift 1
        local additional_options=("$@")
        PersonalSettings::Utils::Message::info "Installing package: ${package_name} ... (sudo apt install -y ${additional_options[*]} ${package_name})"

        # Shellcheck SC2024: redirection is not affected by sudo.
        # We can suppress it, because we where created the temp file with user permissions
        # So the user without sudo permissions can write to the file and read it
        # shellcheck disable=SC2024
        if sudo DEBIAN_FRONTEND=noninteractive apt install -y "${additional_options[@]}" "${package_name}" >"${temp_log_file}" 2>&1; then
            PersonalSettings::Utils::Message::success "Package: ${package_name} installed successfully"

            rm -f "${temp_log_file}"
            return 0
        else
            PersonalSettings::Utils::Message::error "Failed to install package: ${package_name}"

            cat "${temp_log_file}" >&2

            rm -f "${temp_log_file}"
            return 1
        fi
    fi
}

# @brief Function to remove a package by using sudo apt remove -y command
# The function is silent and only prints the output if the removal fails
#
# USAGE:
#   PersonalSettings::PackageManager::Apt::remove "package_name"
# OUTPUT:
#   None
#
# @param $1 - Package name to remove
#
# @return 0 if the removal is successful, 1 otherwise
function PersonalSettings::PackageManager::Apt::remove()
{
    # We dont want to spam the user with apt update logs
    # so we will redirect the output to a temp file
    # and only print the log file if the update fails
    local temp_log_file
    temp_log_file=$(mktemp)

    local package_name="${1}"
    PersonalSettings::Utils::Message::info "Removing package: ${package_name} ... (sudo apt remove -y ${package_name})"

    if ! PersonalSettings::PackageManager::Apt::is_installed "${package_name}"; then
        PersonalSettings::Utils::Message::info "Package: ${package_name} is not installed"
        return 0
    fi

    # Shellcheck SC2024: redirection is not affected by sudo.
    # We can suppress it, because we where created the temp file with user permissions
    # So the user without sudo permissions can write to the file and read it
    # shellcheck disable=SC2024
    if sudo DEBIAN_FRONTEND=noninteractive apt remove -y --purge "${package_name}" >"${temp_log_file}" 2>&1; then
        PersonalSettings::Utils::Message::success "Package: ${package_name} removed successfully"

        rm -f "${temp_log_file}"
        return 0
    else
        PersonalSettings::Utils::Message::error "Failed to remove package: ${package_name}"

        cat "${temp_log_file}" >&2

        rm -f "${temp_log_file}"
        return 1
    fi
}

# @brief Function to remove unused packages by using sudo apt autoremove -y command
# The function is silent and only prints the output if the removal fails
#
# USAGE:
#   PersonalSettings::PackageManager::Apt::autoremove
# OUTPUT:
#   None
#
# @return 0 if the removal is successful, 1 otherwise
function PersonalSettings::PackageManager::Apt::autoremove()
{
    # We dont want to spam the user with apt update logs
    # so we will redirect the output to a temp file
    # and only print the log file if the update fails
    local temp_log_file
    temp_log_file=$(mktemp)

    PersonalSettings::Utils::Message::info "Removing unused packages ... (sudo apt autoremove -y)"

    # Shellcheck SC2024: redirection is not affected by sudo.
    # We can suppress it, because we where created the temp file with user permissions
    # So the user without sudo permissions can write to the file and read it
    # shellcheck disable=SC2024
    if sudo DEBIAN_FRONTEND=noninteractive apt autoremove -y >"${temp_log_file}" 2>&1; then
        PersonalSettings::Utils::Message::success "Unused packages removed successfully"

        rm -f "${temp_log_file}"
        return 0
    else
        PersonalSettings::Utils::Message::error "Failed to remove unused packages"

        cat "${temp_log_file}" >&2

        rm -f "${temp_log_file}"
        return 1
    fi
}

# @brief Function to clean apt cache by using sudo apt clean command
# The function is silent and only prints the output if the cleaning fails
#
# USAGE:
#   PersonalSettings::PackageManager::Apt::clean
# OUTPUT:
#   None
#
# @return 0 if the cleaning is successful, 1 otherwise
function PersonalSettings::PackageManager::Apt::clean()
{
    # We dont want to spam the user with apt update logs
    # so we will redirect the output to a temp file
    # and only print the log file if the update fails
    local temp_log_file
    temp_log_file=$(mktemp)

    PersonalSettings::Utils::Message::info "Cleaning apt cache ... (sudo apt clean)"

    # Shellcheck SC2024: redirection is not affected by sudo.
    # We can suppress it, because we where created the temp file with user permissions
    # So the user without sudo permissions can write to the file and read it
    # shellcheck disable=SC2024
    if sudo DEBIAN_FRONTEND=noninteractive apt clean >"${temp_log_file}" 2>&1; then
        PersonalSettings::Utils::Message::success "Apt cache cleaned successfully"

        rm -f "${temp_log_file}"
        return 0
    else
        PersonalSettings::Utils::Message::error "Failed to clean apt cache"

        cat "${temp_log_file}" >&2

        rm -f "${temp_log_file}"
        return 1
    fi
}

# @brief Function to clean apt cache by using sudo apt autoclean command
# The function is silent and only prints the output if the cleaning fails
#
# USAGE:
#   PersonalSettings::PackageManager::Apt::autoclean
# OUTPUT:
#   None
#
# @return 0 if the cleaning is successful, 1 otherwise
function PersonalSettings::PackageManager::Apt::autoclean()
{
    # We dont want to spam the user with apt update logs
    # so we will redirect the output to a temp file
    # and only print the log file if the update fails
    local temp_log_file
    temp_log_file=$(mktemp)

    PersonalSettings::Utils::Message::info "Cleaning apt cache ... (sudo apt autoclean)"

    # Shellcheck SC2024: redirection is not affected by sudo.
    # We can suppress it, because we where created the temp file with user permissions
    # So the user without sudo permissions can write to the file and read it
    # shellcheck disable=SC2024
    if sudo DEBIAN_FRONTEND=noninteractive apt autoclean >"${temp_log_file}" 2>&1; then
        PersonalSettings::Utils::Message::success "Apt cache cleaned successfully"

        rm -f "${temp_log_file}"
        return 0
    else
        PersonalSettings::Utils::Message::error "Failed to clean apt cache"

        cat "${temp_log_file}" >&2

        rm -f "${temp_log_file}"
        return 1
    fi
}

# @brief Function to perform full upgrade by using sudo apt full-upgrade -y command
# The function is silent and only prints the output if the upgrade fails
#
# USAGE:
#   PersonalSettings::PackageManager::Apt::full_upgrade
# OUTPUT:
#   None
#
# @return 0 if the upgrade is successful, 1 otherwise
function PersonalSettings::PackageManager::Apt::full_upgrade()
{
    # We dont want to spam the user with apt update logs
    # so we will redirect the output to a temp file
    # and only print the log file if the update fails
    local temp_log_file
    temp_log_file=$(mktemp)

    PersonalSettings::Utils::Message::info "Performing full upgrade ... (sudo apt full-upgrade -y)"

    # Shellcheck SC2024: redirection is not affected by sudo.
    # We can suppress it, because we where created the temp file with user permissions
    # So the user without sudo permissions can write to the file and read it
    # shellcheck disable=SC2024
    if sudo DEBIAN_FRONTEND=noninteractive apt full-upgrade -y >"${temp_log_file}" 2>&1; then
        PersonalSettings::Utils::Message::success "Full upgrade completed successfully"

        rm -f "${temp_log_file}"
        return 0
    else
        PersonalSettings::Utils::Message::error "Failed to perform full upgrade"

        cat "${temp_log_file}" >&2

        rm -f "${temp_log_file}"
        return 1
    fi
}

# @brief Function to fix broken packages by using sudo apt --fix-broken install -y command
# The function is silent and only prints the output if the fix fails
#
# USAGE:
#   PersonalSettings::PackageManager::Apt::fix_broken
# OUTPUT:
#   None
#
# @return 0 if the fix is successful, 1 otherwise
function PersonalSettings::PackageManager::Apt::fix_broken()
{
    # We dont want to spam the user with apt update logs
    # so we will redirect the output to a temp file
    # and only print the log file if the update fails
    local temp_log_file
    temp_log_file=$(mktemp)

    PersonalSettings::Utils::Message::info "Fixing broken packages ... (sudo apt --fix-broken install -y)"

    # Shellcheck SC2024: redirection is not affected by sudo.
    # We can suppress it, because we where created the temp file with user permissions
    # So the user without sudo permissions can write to the file and read it
    # shellcheck disable=SC2024
    if sudo DEBIAN_FRONTEND=noninteractive apt --fix-broken install -y >"${temp_log_file}" 2>&1; then
        PersonalSettings::Utils::Message::success "Broken packages fixed successfully"

        rm -f "${temp_log_file}"
        return 0
    else
        PersonalSettings::Utils::Message::error "Failed to fix broken packages"

        cat "${temp_log_file}" >&2

        rm -f "${temp_log_file}"
        return 1
    fi
}

# @brief Function to add a repository by using sudo add-apt-repository -y command
# The function is silent and only prints the output if the addition fails
#
# USAGE:
#   PersonalSettings::PackageManager::Apt::add_repository "repository_url"
# OUTPUT:
#   None
#
# @param $1 - Repository URL to add
#
# @return 0 if the addition is successful, 1 otherwise
function PersonalSettings::PackageManager::Apt::add_repository()
{
    # We dont want to spam the user with apt update logs
    # so we will redirect the output to a temp file
    # and only print the log file if the update fails
    local temp_log_file
    temp_log_file=$(mktemp)

    local repository_url="${1}"

    PersonalSettings::Utils::Message::info "Adding repository: ${repository_url}"

    # Shellcheck SC2024: redirection is not affected by sudo.
    # We can suppress it, because we where created the temp file with user permissions
    # So the user without sudo permissions can write to the file and read it
    # shellcheck disable=SC2024
    if ! sudo DEBIAN_FRONTEND=noninteractive add-apt-repository -y "${repository_url}" >"${temp_log_file}" 2>&1; then
        PersonalSettings::Utils::Message::error "Failed to add repository: ${repository_url}"

        cat "${temp_log_file}" >&2

        rm -f "${temp_log_file}"
        return 1
    fi

    PersonalSettings::PackageManager::Apt::update

    PersonalSettings::Utils::Message::success "Repository: ${repository_url} added successfully"

    rm -f "${temp_log_file}"
    return 0
}

# TEST MANUALLY
# PersonalSettings::PackageManager::Apt::update
# PersonalSettings::PackageManager::Apt::upgrade
# PersonalSettings::PackageManager::Apt::install "htop"
# PersonalSettings::PackageManager::Apt::is_installed "htop" && echo "htop is installed" || echo "htop is not installed"
# PersonalSettings::PackageManager::Apt::remove "htop"
# PersonalSettings::PackageManager::Apt::is_installed "htop" && echo "htop is installed" || echo "htop is not installed"
# PersonalSettings::PackageManager::Apt::autoremove
# PersonalSettings::PackageManager::Apt::clean
# PersonalSettings::PackageManager::Apt::autoclean
# PersonalSettings::PackageManager::Apt::full_upgrade
# PersonalSettings::PackageManager::Apt::fix_broken
# PersonalSettings::PackageManager::Apt::add_repository "ppa:git-core/ppa"
