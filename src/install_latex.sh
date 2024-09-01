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
# @return 0 on success, exit 1 on failure
PersonalSettings::Installer::install_latex()
{
    PersonalSettings::Utils::Message::info "Installing LaTeX"

    # LaTeX environment
    PersonalSettings::Utils::Message::info "Installing LaTeX environment"

    PersonalSettings::PackageManager::Apt::install "texlive-full" || exit 1
    PersonalSettings::PackageManager::Apt::install "texlive-latex-extra" || exit 1
    PersonalSettings::PackageManager::Apt::install "texlive-fonts-extra" || exit 1
    PersonalSettings::PackageManager::Apt::install "texlive-lang-polish" || exit 1

    PersonalSettings::Utils::Message::success "LaTeX environment installed successfully"

    # LaTeX editors
    PersonalSettings::Utils::Message::info "Installing LaTeX editors"

    PersonalSettings::PackageManager::Apt::install "texmaker" || exit 1
    PersonalSettings::PackageManager::Apt::install "kile" || exit 1
    PersonalSettings::PackageManager::Apt::install "texworks" || exit 1

    PersonalSettings::Utils::Message::success "LaTeX editors installed successfully"

    # LaTeX packages and tools
    PersonalSettings::Utils::Message::info "Installing LaTeX packages and tools"

    PersonalSettings::PackageManager::Apt::install "biber" || exit 1
    PersonalSettings::PackageManager::Apt::install "texlive-bibtex-extra" || exit 1
    PersonalSettings::PackageManager::Apt::install "imagemagick" || exit 1
    PersonalSettings::PackageManager::Apt::install "pdf2svg" || exit 1
    PersonalSettings::PackageManager::Apt::install "ghostscript" || exit 1
    PersonalSettings::PackageManager::Apt::install "texlive-science" || exit 1
    PersonalSettings::PackageManager::Apt::install "texlive-fonts-extra" || exit 1
    PersonalSettings::PackageManager::Apt::install "fontconfig" || exit 1
    PersonalSettings::PackageManager::Apt::install "texlive-latex-extra" || exit 1
    PersonalSettings::PackageManager::Apt::install "texlive-latex-recommended" || exit 1
    PersonalSettings::PackageManager::Apt::install "texlive-fonts-recommended" || exit 1
    PersonalSettings::PackageManager::Apt::install "gnuplot" || exit 1
    PersonalSettings::PackageManager::Apt::install "texlive-pictures" || exit 1
    PersonalSettings::PackageManager::Apt::install "latexdiff" || exit 1
    PersonalSettings::PackageManager::Apt::install "aspell" || exit 1
    PersonalSettings::PackageManager::Apt::install "hunspell" || exit 1
    PersonalSettings::PackageManager::Apt::install "pdftk" || exit 1
    PersonalSettings::PackageManager::Apt::install "poppler-utils" || exit 1

    PersonalSettings::Utils::Message::success "LaTeX packages and tools installed successfully"

    PersonalSettings::Utils::Message::success "LaTeX installed successfully"
}