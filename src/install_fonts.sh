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

# @brief Function to install all fancy (nerd) fonts
#
# USAGE:
#   PersonalSettings::Installer::install_fonts
#
# @return 0 on success, return 1 on failure
PersonalSettings::Installer::install_fonts()
{
    PersonalSettings::Utils::Message::info "Installing Fonts"

    local latest_release_url="https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest"

    local latest_release_json
    latest_release_json="$(curl -s "${latest_release_url}")"
    if [[ -z "${latest_release_json}" ]]; then
        PersonalSettings::Utils::Message::error "Failed to get the latest release info"
        return 1
    fi

    local latest_release_tag
    latest_release_tag="$(echo "${latest_release_json}" | jq -r '.tag_name')"
    if [[ -z "${latest_release_tag}" ]]; then
        PersonalSettings::Utils::Message::error "Failed to get the latest release tag"
        return 1
    fi

    PersonalSettings::Utils::Message::info "Latest release tag: ${latest_release_tag}"

    local font_download_url="https://github.com/ryanoasis/nerd-fonts/releases/download/${latest_release_tag}"
    local font_download_info
    font_download_info="$(curl -s "${latest_release_url}")"
    if [[ -z "${font_download_info}" ]]; then
        PersonalSettings::Utils::Message::error "Failed to get the font download info"
        return 1
    fi

    local font_download_list
    # shellcheck disable=SC2312
    font_download_list=$(echo "${font_download_info}" | jq -r '.assets.[].name' | grep -E '\.zip$' | sed 's/\.zip$//' | sort)
    if [[ -z "${font_download_list}" ]]; then
        PersonalSettings::Utils::Message::error "Failed to get the font download list"
        return 1
    fi

    local font_download_dir
    font_download_dir=$(mktemp -d)
    mkdir -p "${font_download_dir}"

    for font in ${font_download_list}; do
        local font_zip="${font}.zip"
        local font_zip_url="${font_download_url}/${font_zip}"
        local font_zip_path="${font_download_dir}/${font_zip}"

        local font_unzip_dir="${font_download_dir}/${font}"
        mkdir -p "${font_unzip_dir}"

        local font_install_path="${HOME}/.fonts/${font}"
        mkdir -p "${font_install_path}"

        PersonalSettings::Utils::Message::info "Downloading ${font_zip}"
        curl -s -L -o "${font_zip_path}" "${font_zip_url}" || return 1

        PersonalSettings::Utils::Message::info "Extracting ${font_zip}"
        unzip -q "${font_zip_path}" -d "${font_unzip_dir}" || return 1

        PersonalSettings::Utils::Message::info "Installing ${font}"
        cp -r "${font_unzip_dir}/" "${font_install_path}" || return 1

        # To reduce the disk usage, remove the downloaded zip and extracted directory
        rm -rf "${font_zip_path}" "${font_unzip_dir}"
    done

    rm -rf "${font_download_dir}"

    PersonalSettings::Utils::Message::info "Updating font cache"

    fc-cache -f > /dev/null 2>&1

    PersonalSettings::Utils::Message::info "Font cache updated successfully"

    PersonalSettings::Utils::Message::success "Fonts installed successfully"
}