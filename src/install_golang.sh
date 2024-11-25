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

function PersonalSettings::Installer::Golang::install()
{
    local temp_log_file
    temp_log_file=$(mktemp)

    local golang_package_url="${1}"

    # Golang can update the package version over existing version
    # So we dont want to check if the package is already installed

    PersonalSettings::Utils::Message::info "Installing Golang tool from ${golang_package_url}"

    go install "${golang_package_url}" >"${temp_log_file}" 2>&1
    if ! go install "${golang_package_url}" >"${temp_log_file}" 2>&1; then
        PersonalSettings::Utils::Message::error "Failed to install Golang tool from ${golang_package_url}"

        cat "${temp_log_file}" >&2

        rm -f "${temp_log_file}"
        return 1
    fi

    PersonalSettings::Utils::Message::info "Successfully installed Golang tool from ${golang_package_url}"

    rm -f "${temp_log_file}"
    return 0
}

function PersonalSettings::Installer::install_golang_devtools()
{
    PersonalSettings::Utils::Message::info "Installing Golang Development Tools"

    # GOLANG (apt will install it under go under /usr/bin/go + the go workspace under ~/go)
    PersonalSettings::PackageManager::Apt::install "golang" || return 1

    # Install some usefull binaries (under ~/go/bin)
    PersonalSettings::Installer::Golang::install "github.com/golangci/golangci-lint/cmd/golangci-lint@latest" || return 1
    PersonalSettings::Installer::Golang::install "github.com/mgechev/revive@latest" || return 1
    PersonalSettings::Installer::Golang::install "github.com/securego/gosec/v2/cmd/gosec@latest" || return 1
    PersonalSettings::Installer::Golang::install "github.com/kisielk/errcheck@latest" || return 1
    PersonalSettings::Installer::Golang::install "github.com/onsi/ginkgo/v2/ginkgo@latest" || return 1
    PersonalSettings::Installer::Golang::install "github.com/golang/mock/mockgen@latest" || return 1
    PersonalSettings::Installer::Golang::install "github.com/go-delve/delve/cmd/dlv@latest" || return 1
    PersonalSettings::Installer::Golang::install "golang.org/x/tools/cmd/goimports@latest" || return 1
    PersonalSettings::Installer::Golang::install "honnef.co/go/tools/cmd/staticcheck@latest" || return 1
    PersonalSettings::Installer::Golang::install "golang.org/x/tools/cmd/stringer@latest" || return 1
    PersonalSettings::Installer::Golang::install "google.golang.org/protobuf/cmd/protoc-gen-go@latest" || return 1
    PersonalSettings::Installer::Golang::install "github.com/go-swagger/go-swagger/cmd/swagger@latest" || return 1
    PersonalSettings::Installer::Golang::install "github.com/air-verse/air@latest" || return 1
    PersonalSettings::Installer::Golang::install "github.com/swaggo/swag/cmd/swag@latest" || return 1
    PersonalSettings::Installer::Golang::install "github.com/magefile/mage@latest" || return 1
    PersonalSettings::Installer::Golang::install "github.com/hairyhenderson/gomplate/v3/cmd/gomplate@latest" || return 1
    PersonalSettings::Installer::Golang::install "github.com/gobuffalo/packr/v2/packr2@latest" || return 1
    PersonalSettings::Installer::Golang::install "github.com/jwilder/dockerize@latest" || return 1
    PersonalSettings::Installer::Golang::install "golang.org/x/tools/gopls@latest" || return 1
    PersonalSettings::Installer::Golang::install "github.com/sqlc-dev/sqlc/cmd/sqlc@latest" || return 1

    PersonalSettings::Utils::Message::info "Successfully installed Golang Development Tools"

    return 0
}