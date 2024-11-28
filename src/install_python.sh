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

# @brief Install Python libraries using pip
#
# USAGE:
#   PersonalSettings::Installer::Python::install "package1" "package2" ...
#
# @param ${@} List of Python packages to install
# @return 0 on success, return 1 on failure
function PersonalSettings::Installer::Python::install()
{
    local temp_log_file
    temp_log_file=$(mktemp)

    # We need to install packages in batches to avoid dependency error
    local python_packages=("${@}")

    for package in "${python_packages[@]}"; do
        PersonalSettings::Utils::Message::info "Installing Python package: ${package}"
    done

    if ! pip install "${python_packages[@]}" --no-cache-dir > "${temp_log_file}" 2>&1 ; then
        PersonalSettings::Utils::Message::error "Failed to install Python packages: ${python_packages[*]}"

        cat "${temp_log_file}" >&2

        rm -f "${temp_log_file}"

        return 1
    fi

    for package in "${python_packages[@]}"; do
        PersonalSettings::Utils::Message::success "Successfully installed Python package: ${package}"
    done

    rm -f "${temp_log_file}"
    return 0
}


function PersonalSettings::Installer::install_python_devtools()
{
    PersonalSettings::Utils::Message::info "Installing Python Development Tools"

    PersonalSettings::PackageManager::Apt::install "python3" || return 1
    PersonalSettings::PackageManager::Apt::install "python3-pip" || return 1
    PersonalSettings::PackageManager::Apt::install "python3-venv" || return 1
    PersonalSettings::PackageManager::Apt::install "python3-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "pipx" || return 1

    PersonalSettings::Utils::Message::info "Creating Python Virtual Environment"

    python3 -m venv "${HOME}/.python/venv/default" >/dev/null 2>&1 || return 1

    PersonalSettings::Utils::Message::info "Python Virtual Environment created at ~/.python/venv/default"
    PersonalSettings::Utils::Message::info "You can activate the virtual environment by running 'source ~/.python/venv/default/bin/activate'"

    PersonalSettings::Utils::Message::info "Installing python packages in the virtual environment"

    # Install C/C++ packages required for Python packages
    PersonalSettings::PackageManager::Apt::install "portaudio19-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "libpython3-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "libgomp1" || return 1
    PersonalSettings::PackageManager::Apt::install "gfortran" || return 1
    PersonalSettings::PackageManager::Apt::install "libopenblas-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "liblapack-dev" || return 1

    # shellcheck source=/dev/null
    source "${HOME}/.python/venv/default/bin/activate" || return 1

    # Most probably, during development I will install packages in another virtual environment
    # But to test those packages and have them to prototype, I will install them in the default virtual environment

    # Install "core" Python packages
    PersonalSettings::Installer::Python::install "setuptools" \
                                                 "wheel" \
                                                 "python-dotenv" \
                                                 "pathlib" \
                                                 "tqdm" \
                                                 "sqlmodel" \
                                                 "httpx" \
                                                 "requests" \
                                                 "scrapy" \
                                                 "selenium" \
                                                 "pyppeteer" \
                                                 "pytest" \
                                                 "coverage" \
                                                 "tox" \
                                                 "hypothesis" \
                                                 "pdbpp" \
                                                 "python-dateutil" \
                                                 "pytz" \
                                                 "arrow" \
                                                 "regex" \
                                                 "rich" \
                                                 "tabulate" \
                                                 "pyinstaller" \
                                                 "boto3" \
                                                 "pyngrok" \
                                                 "protobuf" \
                                                 "Cython" \
                                                 "psutil" || (deactivate && return 1)

    # Install more "fancy"  Python packages
    PersonalSettings::Installer::Python::install "numpy" \
                                                 "pandas" \
                                                 "matplotlib" \
                                                 "tensorflow" \
                                                 "keras" \
                                                 "flask" \
                                                 "django" \
                                                 "fastapi" \
                                                 "bottle" \
                                                 "pyramid" \
                                                 "sqlalchemy" \
                                                 "beautifulsoup4" \
                                                 "lxml" \
                                                 "watchdog" \
                                                 "pyyaml" \
                                                 "json5" \
                                                 "csvkit" \
                                                 "pillow" \
                                                 "imageio" \
                                                 "pytesseract" \
                                                 "pydub" \
                                                 "soundfile" \
                                                 "pyaudio" \
                                                 "speechrecognition" \
                                                 "cryptography" \
                                                 "pyjwt" \
                                                 "passlib" \
                                                 "bcrypt" \
                                                 "paramiko" \
                                                 "fabric" \
                                                 "asyncio" \
                                                 "aiohttp" \
                                                 "colorama" \
                                                 "faker" || (deactivate && return 1)

    deactivate

    PersonalSettings::Utils::Message::success "Python packages installed successfully"

    PersonalSettings::Utils::Message::info "Successfully installed Python Development Tools"
}