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

function PersonalSettings::Installer::Pipx::install()
{
    local temp_log_file
    temp_log_file=$(mktemp)

    local pipx_app="$1"

    PersonalSettings::Utils::Message::info "Installing pipx app: ${pipx_app}"

    if ! pipx install "${pipx_app}" > "${temp_log_file}" 2>&1 ; then
        PersonalSettings::Utils::Message::error "Failed to install pipx app: ${pipx_app}"

        cat "${temp_log_file}" >&2

        rm -f "${temp_log_file}"

        return 1
    fi

    PersonalSettings::Utils::Message::success "Successfully installed pipx app: ${pipx_app}"

    rm -f "${temp_log_file}"
    return 0
}

function PersonalSettings::Installer::install_pipx_apps()
{
    PersonalSettings::Utils::Message::info "Installing pipx apps"

    # Maybe in the future, someone will want to install pipx apps without full python3 installation
    # To cover this case, we will install python3 and pipx here
    PersonalSettings::PackageManager::Apt::install "python3" || return 1
    PersonalSettings::PackageManager::Apt::install "python3-pip" || return 1
    PersonalSettings::PackageManager::Apt::install "python3-venv" || return 1
    PersonalSettings::PackageManager::Apt::install "python3-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "pipx" || return 1

    # Install pipx apps
    PersonalSettings::Installer::Pipx::install "httpie" || return 1
    PersonalSettings::Installer::Pipx::install "yt-dlp" || return 1
    PersonalSettings::Installer::Pipx::install "black" || return 1
    PersonalSettings::Installer::Pipx::install "mypy" || return 1
    PersonalSettings::Installer::Pipx::install "pylint" || return 1
    PersonalSettings::Installer::Pipx::install "flake8" || return 1
    PersonalSettings::Installer::Pipx::install "tox" || return 1
    PersonalSettings::Installer::Pipx::install "safety" || return 1
    PersonalSettings::Installer::Pipx::install "invoke" || return 1
    PersonalSettings::Installer::Pipx::install "cookiecutter" || return 1
    PersonalSettings::Installer::Pipx::install "pre-commit" || return 1
    PersonalSettings::Installer::Pipx::install "bandit" || return 1
    PersonalSettings::Installer::Pipx::install "bpython" || return 1
    PersonalSettings::Installer::Pipx::install "mkdocs" || return 1
    PersonalSettings::Installer::Pipx::install "glances" || return 1
    PersonalSettings::Installer::Pipx::install "termgraph" || return 1
    PersonalSettings::Installer::Pipx::install "howdoi" || return 1
    PersonalSettings::Installer::Pipx::install "py-spy" || return 1
    PersonalSettings::Installer::Pipx::install "pgcli" || return 1

    # Ensure pipx path is in PATH
    pipx ensurepath >/dev/null 2>&1 || return 1

    # We need to source the PATH again, but we need to know the shell first
    # Checking shell, sourcing the correct file, it's a bit tricky
    # Instead, we can just export the PATH variable
    export PATH="${HOME}/.local/bin:${PATH}"

    PersonalSettings::Utils::Message::success "Successfully installed pipx apps"

    return 0
}