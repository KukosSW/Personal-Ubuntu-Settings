#!/bin/bash

set -Eu

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_TOP_DIR="${SCRIPT_DIR}/.."

# Prevent double sourcing
if [[ -n "${PERSONAL_SETTINGS_INSTALLER_LATEX_SOURCED:-}" ]]; then
    return 0
fi

export PERSONAL_SETTINGS_INSTALLER_LATEX_SOURCED=1

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

# @brief Function to install LaTeX
#
# USAGE:
#   PersonalSettings::Installer::install_latex
#
# @return 0 on success, return 1 on failure
PersonalSettings::Installer::install_latex()
{
    PersonalSettings::Utils::Message::info "Installing LaTeX"

    # LaTeX environment
    PersonalSettings::Utils::Message::info "Installing LaTeX environment"

    PersonalSettings::Utils::Message::info "Installing texlive-full, this may take a while"
    PersonalSettings::PackageManager::Apt::install "texlive-full" || return 1
    PersonalSettings::PackageManager::Apt::install "texlive-latex-extra" || return 1
    PersonalSettings::PackageManager::Apt::install "texlive-fonts-extra" || return 1
    PersonalSettings::PackageManager::Apt::install "texlive-lang-polish" || return 1

    PersonalSettings::Utils::Message::success "LaTeX environment installed successfully"

    # LaTeX editors
    PersonalSettings::Utils::Message::info "Installing LaTeX editors"

    PersonalSettings::PackageManager::Apt::install "texmaker" || return 1
    PersonalSettings::PackageManager::Apt::install "kile" || return 1
    PersonalSettings::PackageManager::Apt::install "texworks" || return 1

    PersonalSettings::Utils::Message::success "LaTeX editors installed successfully"

    # LaTeX packages and tools
    PersonalSettings::Utils::Message::info "Installing LaTeX packages and tools"

    PersonalSettings::PackageManager::Apt::install "biber" || return 1
    PersonalSettings::PackageManager::Apt::install "texlive-bibtex-extra" || return 1
    PersonalSettings::PackageManager::Apt::install "imagemagick" || return 1
    PersonalSettings::PackageManager::Apt::install "pdf2svg" || return 1
    PersonalSettings::PackageManager::Apt::install "ghostscript" || return 1
    PersonalSettings::PackageManager::Apt::install "texlive-science" || return 1
    PersonalSettings::PackageManager::Apt::install "texlive-fonts-extra" || return 1
    PersonalSettings::PackageManager::Apt::install "fontconfig" || return 1
    PersonalSettings::PackageManager::Apt::install "texlive-latex-extra" || return 1
    PersonalSettings::PackageManager::Apt::install "texlive-latex-recommended" || return 1
    PersonalSettings::PackageManager::Apt::install "texlive-fonts-recommended" || return 1
    PersonalSettings::PackageManager::Apt::install "gnuplot" || return 1
    PersonalSettings::PackageManager::Apt::install "texlive-pictures" || return 1
    PersonalSettings::PackageManager::Apt::install "latexdiff" || return 1
    PersonalSettings::PackageManager::Apt::install "aspell" || return 1
    PersonalSettings::PackageManager::Apt::install "hunspell" || return 1
    PersonalSettings::PackageManager::Apt::install "pdftk" || return 1
    PersonalSettings::PackageManager::Apt::install "poppler-utils" || return 1

    PersonalSettings::Utils::Message::success "LaTeX packages and tools installed successfully"

    PersonalSettings::Utils::Message::success "LaTeX installed successfully"

    return 0
}