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

function PersonalSettings::Installer::install_xfce()
{
    PersonalSettings::Utils::Message::info "Installing XFCE"

    # XFCE can be easly combined with gdm3 or lightdm
    # Most users like to use lightdm
    # BUT I PREFER GDM3

    PersonalSettings::PackageManager::Apt::install "gdm3" || return 1

    # During installation, it will ask for the default display manager
    # We can set it to gdm3 withuot any prompt
    echo "lightdm shared/default-x-display-manager select gdm3" | sudo debconf-set-selections

    PersonalSettings::PackageManager::Apt::install "xfce4" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-goodies" || return 1

    # XFCE4 core package should install most of the necessary stuff, but to be sure we can install some more
    PersonalSettings::PackageManager::Apt::install "gir1.2-libxfce4panel-2.0" || return 1
    PersonalSettings::PackageManager::Apt::install "gir1.2-libxfce4ui-2.0" || return 1
    PersonalSettings::PackageManager::Apt::install "gir1.2-libxfce4util-1.0" || return 1
    PersonalSettings::PackageManager::Apt::install "gir1.2-libxfce4windowing-0.0" || return 1
    PersonalSettings::PackageManager::Apt::install "gir1.2-libxfce4windowingui-0.0" || return 1
    PersonalSettings::PackageManager::Apt::install "jgmenu-xfce4-panel-applet" || return 1
    PersonalSettings::PackageManager::Apt::install "libxfce4panel-2.0-4" || return 1
    PersonalSettings::PackageManager::Apt::install "libxfce4panel-2.0-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "libxfce4ui-2-0" || return 1
    PersonalSettings::PackageManager::Apt::install "libxfce4ui-2-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "libxfce4ui-common" || return 1
    PersonalSettings::PackageManager::Apt::install "libxfce4ui-glade" || return 1
    PersonalSettings::PackageManager::Apt::install "libxfce4ui-utils" || return 1
    PersonalSettings::PackageManager::Apt::install "libxfce4util-bin" || return 1
    PersonalSettings::PackageManager::Apt::install "libxfce4util-common" || return 1
    PersonalSettings::PackageManager::Apt::install "libxfce4util-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "libxfce4util7" || return 1
    PersonalSettings::PackageManager::Apt::install "libxfce4windowing-0-0" || return 1
    PersonalSettings::PackageManager::Apt::install "libxfce4windowing-0-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "libxfce4windowing-common" || return 1
    PersonalSettings::PackageManager::Apt::install "libxfconf-0-3" || return 1
    PersonalSettings::PackageManager::Apt::install "libxfconf-0-dev" || return 1
    PersonalSettings::PackageManager::Apt::install "lxtask" || return 1
    PersonalSettings::PackageManager::Apt::install "orage" || return 1
    PersonalSettings::PackageManager::Apt::install "orage-data" || return 1
    PersonalSettings::PackageManager::Apt::install "shiki-colors-xfwm-theme" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-appfinder" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-clipman" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-dev-tools" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-helpers" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-notes" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-notifyd" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-panel" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-panel-profiles" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-power-manager" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-power-manager-data" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-screensaver" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-screenshooter" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-session" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-settings" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-taskmanager" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-terminal" || return 1
    PersonalSettings::PackageManager::Apt::install "xfwm4" || return 1
    PersonalSettings::PackageManager::Apt::install "xfwm4-theme-breeze" || return 1

    # Goodies should install most of the fancy stuff, but to be sure we can install some more
    PersonalSettings::PackageManager::Apt::install "budgie-sntray-plugin" || return 1
    PersonalSettings::PackageManager::Apt::install "mate-sntray-plugin" || return 1
    PersonalSettings::PackageManager::Apt::install "vala-sntray-plugin" || return 1
    PersonalSettings::PackageManager::Apt::install "workrave-xfce4" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-appmenu-plugin" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-battery-plugin" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-clipman-plugin" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-cpufreq-plugin" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-cpugraph-plugin" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-datetime-plugin" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-dict" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-diskperf-plugin" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-eyes-plugin" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-fsguard-plugin" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-genmon-plugin" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-indicator-plugin" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-mailwatch-plugin" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-mount-plugin" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-mpc-plugin" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-netload-plugin" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-notes-plugin" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-places-plugin" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-power-manager-plugins" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-pulseaudio-plugin" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-sensors-plugin" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-smartbookmark-plugin" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-sntray-plugin" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-sntray-plugin-common" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-systemload-plugin" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-time-out-plugin" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-timer-plugin" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-verve-plugin" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-wavelan-plugin" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-weather-plugin" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-whiskermenu-plugin" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-windowck-plugin" || return 1
    PersonalSettings::PackageManager::Apt::install "xfce4-xkb-plugin" || return 1

    PersonalSettings::Utils::Message::success "XFCE installed successfully"

    return 0
}