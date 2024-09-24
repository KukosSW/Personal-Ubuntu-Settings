#!/bin/bash

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

# @brief Function to install git
#
# USAGE:
#   PersonalSettings::Installer::install_git
#
# @return 0 on success, return 1 on failure
PersonalSettings::Installer::install_git()
{
    PersonalSettings::Utils::Message::info "Installing and configuring git"

    PersonalSettings::PackageManager::Apt::install "git" || return 1

    git config --global user.name "Michal Kukowski"
    git config --global user.email "kukossw@gmail.com"

    git config --global sendemail.smtpuser "kukossw@gmail.com"
    git config --global sendemail.smtpserver "smtp.gmail.com"
    git config --global sendemail.smtpserverport "587"
    git config --global sendemail.smtpencryption "tls"

    git config --global core.editor "nvim"
    git config --global core.pager.branch "cat"
    git config --global core.pager.log "less -FRSX"

    git config --global pull.rebase true

    git config --global alias.ci 'commit'
    git config --global alias.cim 'commit -m'
    git config --global alias.ca 'commit --amend'
    git config --global alias.caa 'commit --amend --no-edit'
    git config --global alias.pu 'push'
    git config --global alias.puf 'push --force'
    git config --global alias.st 'status'
    git config --global alias.sts 'status --short --branch'
    git config --global alias.res 'reset HEAD --'
    git config --global alias.co 'checkout'
    git config --global alias.cob 'checkout -b'
    git config --global alias.cp 'cherry-pick'
    git config --global alias.cpn 'cherry-pick -n'
    git config --global alias.br 'branch'
    git config --global alias.df 'diff'
    git config --global alias.dc 'diff --cached'
    git config --global alias.un 'reset --hard HEAD'
    git config --global alias.resh 'reset --hard ^HEAD'
    git config --global alias.lg 'log --oneline --decorate --all --graph'
    git config --global alias.ll 'log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --numstat'
    git config --global alias.ld 'log --pretty=format:"%C(yellow)%h\\ %C(green)%ad%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --date=short --graph'
    git config --global alias.ls 'log --pretty=format:"%C(green)%h\\ %C(yellow)[%ad]%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --date=relative'
    git config --global alias.show 'show --pretty="format:" --name-only'
    git config --global alias.cfglog 'config --list --show-origin --show-scope'
    git config --global alias.cfgalias 'config --get-regexp alias'

    PersonalSettings::Utils::Message::success "Git installed and configured"

    PersonalSettings::Utils::Message::info "Installing additional git tools"

    PersonalSettings::PackageManager::Apt::install "git-extras" || return 1
    PersonalSettings::PackageManager::Apt::install "gitg" || return 1
    PersonalSettings::PackageManager::Apt::install "gitk" || return 1
    PersonalSettings::PackageManager::Apt::install "gh" || return 1

    PersonalSettings::Utils::Message::success "Additional git tools installed"

    if ! command -v lazygit >/dev/null 2>&1; then
        PersonalSettings::Utils::Message::info "Installing lazygit"

        local lazygit_version

        # shellcheck disable=SC2312
        lazygit_version=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        curl -Lqo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${lazygit_version}_Linux_x86_64.tar.gz" 2>/dev/null
        tar xf lazygit.tar.gz lazygit
        sudo install lazygit /usr/local/bin

        rm -f lazygit.tar.gz lazygit

        PersonalSettings::Utils::Message::success "Lazygit installed"
    fi

    return 0
}