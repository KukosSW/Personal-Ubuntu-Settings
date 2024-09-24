#!/bin/bash
# shellcheck disable=SC2312
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

# @brief Check if the OS is Linux
#
# USAGE:
#   PersonalSettings::OSInfo::is_linux
# OUTPUT:
# none
#
# @return 0 if OS is Linux, 1 otherwise
function PersonalSettings::OSInfo::is_linux()
{
    # shellcheck disable=SC2312
    if [[ "$(uname -s)" == "Linux" ]] ||  grep -qi "linux" /proc/version 2>/dev/null ||  [[ "$(cat /proc/sys/kernel/ostype 2>/dev/null)" == "Linux" ]] || [[ -d /sys/module ]]; then
        return 0
    fi

    return 1
}

# @brief Get the OS information like name, version, id, id_like, version_id, pretty_name, and codename
#
# USAGE:
#   PersonalSettings::OSInfo::os_info
# OUTPUT:
# OS Name: Ubuntu
# OS Version: 24.04.1 LTS (Noble Numbat)
# OS ID: ubuntu
# OS ID Like: debian
# OS Version ID: 24.04
# OS Pretty Name: Ubuntu 24.04.1 LTS
# OS Codename: noble
#
# @return 0 on success, 1 on failure
function PersonalSettings::OSInfo::os_info()
{
    local os_name
    local os_version
    local os_id
    local os_id_like
    local os_version_id
    local os_pretty_name
    local os_codename

    if [[ -f /etc/os-release ]]; then
        os_name=$(grep -E '^NAME=' /etc/os-release | cut -d'=' -f2 | tr -d '"')
        os_version=$(grep -E '^VERSION=' /etc/os-release | cut -d'=' -f2 | tr -d '"')
        os_id=$(grep -E '^ID=' /etc/os-release | cut -d'=' -f2 | tr -d '"')
        os_id_like=$(grep -E '^ID_LIKE=' /etc/os-release | cut -d'=' -f2 | tr -d '"')
        os_version_id=$(grep -E '^VERSION_ID=' /etc/os-release | cut -d'=' -f2 | tr -d '"')
        os_pretty_name=$(grep -E '^PRETTY_NAME=' /etc/os-release | cut -d'=' -f2 | tr -d '"')
        os_codename=$(grep -E '^VERSION_CODENAME=' /etc/os-release | cut -d'=' -f2 | tr -d '"')
    elif [[ -f /etc/lsb-release ]]; then
        os_name=$(grep -E '^DISTRIB_ID=' /etc/lsb-release | cut -d'=' -f2 | tr -d '"')
        os_version=$(grep -E '^DISTRIB_RELEASE=' /etc/lsb-release | cut -d'=' -f2 | tr -d '"')
        os_id=$(grep -E '^DISTRIB_ID=' /etc/lsb-release | cut -d'=' -f2 | tr -d '"')
        os_id_like=$(grep -E '^DISTRIB_ID=' /etc/lsb-release | cut -d'=' -f2 | tr -d '"')
        os_version_id=$(grep -E '^DISTRIB_RELEASE=' /etc/lsb-release | cut -d'=' -f2 | tr -d '"')
        os_pretty_name=$(grep -E '^DISTRIB_DESCRIPTION=' /etc/lsb-release | cut -d'=' -f2 | tr -d '"')
        os_codename=$(grep -E '^DISTRIB_CODENAME=' /etc/lsb-release | cut -d'=' -f2 | tr -d '"')
    else
        PersonalSettings::Utils::Message::error "Could not find os-release or lsb-release"
        return 1
    fi

    local host_name
    if command -v hostname >/dev/null 2>&1; then
        host_name=$(hostname)
    else
        host_name="${HOSTNAME:-Unknown}"
    fi

    printf "OS Name: %s\n" "${os_name}"
    printf "OS Version: %s\n" "${os_version}"
    printf "OS ID: %s\n" "${os_id}"
    printf "OS ID Like: %s\n" "${os_id_like}"
    printf "OS Version ID: %s\n" "${os_version_id}"
    printf "OS Pretty Name: %s\n" "${os_pretty_name}"
    printf "OS Codename: %s\n" "${os_codename}"
    printf "OS Hostname: %s\n" "${host_name}"
    return 0
}

# @brief Get the Architecture (x86_64, arm64, etc.)
#
# USAGE:
#   PersonalSettings::OSInfo::arch
# OUTPUT:
#   Arch: x86_64
#
# @return 0 on success, 1 on failure
function PersonalSettings::OSInfo::arch()
{
    local _arch
    if [[ -n "$(command -v arch)" ]]; then
        _arch=$(arch)
    elif [[ -f /etc/os-release ]]; then
        _arch=$(grep -E '^ARCH=' /etc/os-release | cut -d'=' -f2 | tr -d '"')
    elif [[ -f /etc/lsb-release ]]; then
        _arch=$(grep -E '^DISTRIB_ARCH=' /etc/lsb-release | cut -d'=' -f2 | tr -d '"')
    else
        PersonalSettings::Utils::Message::error "Could not find arch command or /etc/os-release or /etc/lsb-release"
        return 1
    fi

    printf "Arch: %s\n" "${_arch}"
    return 0
}


# @brief Get the Kernel version
#
# USAGE:
#   PersonalSettings::OSInfo::kernel
# OUTPUT:
# Kernel: 6.8.0-41-generic
#
# @return 0 on success, 1 on failure
function PersonalSettings::OSInfo::kernel()
{
    local kernel
    if [[ -n "$(command -v uname)" ]]; then
        kernel=$(uname -r)
    elif [[ -f /etc/os-release ]]; then
        kernel=$(grep -E '^KERNEL=' /etc/os-release | cut -d'=' -f2 | tr -d '"')
    elif [[ -f /etc/lsb-release ]]; then
        kernel=$(grep -E '^DISTRIB_KERNEL=' /etc/lsb-release | cut -d'=' -f2 | tr -d '"')
    else
        PersonalSettings::Utils::Message::error "Could not find uname command or /etc/os-release or /etc/lsb-release"
        return 1
    fi

    printf "Kernel: %s\n" "${kernel}"
    return 0
}

# @brief Get the Container name (Docker, Podman, Kubernetes, ...)
#
# USAGE:
#   PersonalSettings::OSInfo::container
# OUTPUT:
# Container: Docker
#
# @return 0 on success, 1 on failure
function PersonalSettings::OSInfo::container()
{
    local container_name=""
    if [[ -f /.dockerenv ]]; then
        container_name="Docker"
    elif grep -q 'libpod' /proc/1/cgroup 2>/dev/null; then
        container_name="Podman"
    elif grep -q '/kubepods' /proc/1/cgroup 2>/dev/null; then
        container_name="Kubernetes"
    elif grep -q 'lxc' /proc/1/cgroup 2>/dev/null; then
        container_name="LXC"
    elif grep -q 'VxID' /proc/self/status 2>/dev/null; then
        container_name="OpenVZ"
    elif grep -q 'docker\|containerd\|lxc' /proc/1/cgroup 2>/dev/null; then
        container_name="Generic Container"
    fi

    if [[ -n "${container_name}" ]]; then
        printf "Container: %s\n" "${container_name}"
    fi

    return 0
}

# @brief Check if the OS is running in a docker container
#
# USAGE:
#   PersonalSettings::OSInfo::is_docker
# OUTPUT:
# none
#
# @return 0 if OS is running in a docker container, 1 otherwise
function PersonalSettings::OSInfo::is_docker()
{
    if PersonalSettings::OSInfo::container | grep -q "Docker"; then
        return 0
    fi

    return 1
}

# @brief Check if the OS is running in a podman container
#
# USAGE:
#   PersonalSettings::OSInfo::is_podman
# OUTPUT:
# none
#
# @return 0 if OS is running in a podman container, 1 otherwise
function PersonalSettings::OSInfo::is_podman()
{
    if PersonalSettings::OSInfo::container | grep -q "Podman"; then
        return 0
    fi

    return 1
}

# @brief Check if the OS is running in a kubernetes container
#
# USAGE:
#   PersonalSettings::OSInfo::is_kubernetes
# OUTPUT:
# none
#
# @return 0 if OS is running in a kubernetes container, 1 otherwise
function PersonalSettings::OSInfo::is_kubernetes()
{
    if PersonalSettings::OSInfo::container | grep -q "Kubernetes"; then
        return 0
    fi

    return 1
}

# @brief Check if the OS is running in a lxc container
#
# USAGE:
#   PersonalSettings::OSInfo::is_lxc
# OUTPUT:
# none
#
# @return 0 if OS is running in a lxc container, 1 otherwise
function PersonalSettings::OSInfo::is_lxc()
{
    if PersonalSettings::OSInfo::container | grep -q "LXC"; then
        return 0
    fi

    return 1
}

# @brief Check if the OS is running in a openvz container
#
# USAGE:
#   PersonalSettings::OSInfo::is_openvz
# OUTPUT:
# none
#
# @return 0 if OS is running in a openvz container, 1 otherwise
function PersonalSettings::OSInfo::is_openvz()
{
    if PersonalSettings::OSInfo::container | grep -q "OpenVZ"; then
        return 0
    fi
}

# @brief Check if the OS is running in any container
#
# USAGE:
#   PersonalSettings::OSInfo::is_container
# OUTPUT:
# none
#
# @return 0 if OS is running in a container, 1 otherwise
function PersonalSettings::OSInfo::is_container()
{
    if [[ -n "$(PersonalSettings::OSInfo::container)" ]]; then
        return 0
    fi

    return 1
}

# @brief Get the CPU full name
#
# USAGE:
#   PersonalSettings::OSInfo::cpu_name
# OUTPUT:
# CPU: AMD Ryzen 7 8845HS w/ Radeon 780M Graphics
#
# @return 0 on success, 1 on failure
function PersonalSettings::OSInfo::cpu_name()
{
    local cpu_name
    if [[ -f /proc/cpuinfo ]]; then
        cpu_name=$(grep "model name" /proc/cpuinfo | head -n 1 | awk -F': ' '{print $2}')
    elif [[ -n "$(command -v lscpu)" ]]; then
        cpu_name=$(lscpu | grep "Model name:" | awk -F': ' '{print $2}')
    else
        PersonalSettings::Utils::Message::error "Could not find /proc/cpuinfo or lscpu command"
        return 1
    fi

    printf "CPU: %s\n" "${cpu_name}"
    return 0
}

# @brief Get the GPU full name
#
# USAGE:
#   PersonalSettings::OSInfo::gpu_name
# OUTPUT:
# GPU: Advanced Micro Devices, Inc. [AMD/ATI] Phoenix3 (rev c5)
#
# @return 0 on success, 1 on failure
function PersonalSettings::OSInfo::gpu_name()
{
    local gpu_name
    if [[ -n "$(command -v lspci)" ]]; then
        gpu_name=$(lspci | grep -E "VGA compatible controller|3D controller" | awk -F': ' '{print $2}')
    elif [[ -f /proc/driver/nvidia/gpus/0/information ]]; then
        gpu_name=$(grep "Model:" /proc/driver/nvidia/gpus/0/information | awk -F': ' '{print $2}')
    else
        PersonalSettings::Utils::Message::error "Could not find lspci command or Nvidia driver information"
        return 1
    fi

    printf "GPU: %s\n" "${gpu_name}"
    return 0
}

# @brief Get the Total RAM and RAM details
#
# USAGE:
#   PersonalSettings::OSInfo::ram_info
# OUTPUT:
# Total RAM: 16G
# RAM Details: 1600 MHz
#
# @return 0 on success, 1 on failure
function PersonalSettings::OSInfo::ram_info()
{
    local total_ram
    local ram_speed

    if [[ -f /proc/meminfo ]]; then
        total_ram=$(awk '/MemTotal/ {printf "%.2f GB", $2/1024/1024}' /proc/meminfo)
    elif [[ -n "$(command -v free)" ]]; then
        total_ram=$(free -h | awk '/^Mem:/ {print $2}')
    else
        PersonalSettings::Utils::Message::error "Could not find free command or /proc/meminfo"
        return 1
    fi

    if [[ -n "$(command -v dmidecode)" ]]; then
            ram_speed=$(sudo dmidecode --type memory | awk '/^\s*Speed: [0-9]/ {print $2 " " $3; exit}')
    else
        PersonalSettings::Utils::Message::error "dmidecode command not found"
        return 1
    fi

    printf "Total RAM: %s (%s)\n" "${total_ram}" "${ram_speed}"

    return 0
}

# @brief Get the Shell name and version
#
# USAGE:
#   PersonalSettings::OSInfo::shell
# OUTPUT:
# Shell: bash 5.2.21(1)-release
#
# @return 0 on success, 1 on failure
function PersonalSettings::OSInfo::shell()
{
    local shell_name
    local shell_version

    if [[ -n "${BASH_VERSION:-}" ]]; then
        shell_name="bash"
        shell_version="${BASH_VERSION}"
    elif [[ -n "${ZSH_VERSION:-}" ]]; then
        shell_name="zsh"
        shell_version="${ZSH_VERSION}"
    elif [[ -n "${KSH_VERSION:-}" ]]; then
        shell_name="ksh"
        shell_version="${KSH_VERSION}"
    elif [[ -n "${FISH_VERSION:-}" ]]; then
        shell_name="fish"
        shell_version="${FISH_VERSION}"
    else
        shell_name=$(ps -p $$ -o comm=)
        shell_version="Unknown"
    fi

    printf "Shell: %s %s\n" "${shell_name}" "${shell_version}"
    return 0
}

# @brief Get the Desktop Environment name
#
# USAGE:
#   PersonalSettings::OSInfo::desktop_environment
# OUTPUT:
# Desktop Environment: XFCE
#
# @return 0 on success, 1 on failure
function PersonalSettings::OSInfo::desktop_environment()
{
    local desktop_env=""
    local process_list
    process_list=$(ps -e -o comm=)

    if [[ -n "${XDG_CURRENT_DESKTOP:-}" ]]; then
        desktop_env="${XDG_CURRENT_DESKTOP}"
    elif [[ -n "${DESKTOP_SESSION:-}" ]]; then
        desktop_env="${DESKTOP_SESSION}"
    elif [[ -n "${GNOME_DESKTOP_SESSION_ID:-}" ]]; then
        desktop_env="GNOME"
    elif [[ -n "${MATE_DESKTOP_SESSION_ID:-}" ]]; then
        desktop_env="MATE"
    elif [[ -n "${KDE_FULL_SESSION:-}" ]]; then
        desktop_env="KDE"
    elif [[ -n "${GDMSESSION:-}" ]]; then
        desktop_env="${GDMSESSION}"
    elif [[ -n "${SESSION_MANAGER:-}" ]]; then
        case "${SESSION_MANAGER}" in
            *gnome*) desktop_env="GNOME" ;;
            *kde*) desktop_env="KDE" ;;
            *xfce*) desktop_env="XFCE" ;;
            *) desktop_env="" ;;
        esac
    fi

    # Additional checks for XFCE and other DEs by inspecting running processes
    if [[ -z "${desktop_env}" ]]; then
        if echo "${process_list}" | grep -q 'xfce4-session'; then
            desktop_env="XFCE"
        elif echo "${process_list}" | grep -q 'gnome-shell'; then
            desktop_env="GNOME"
        elif echo "${process_list}" | grep -q 'kwin'; then
            desktop_env="KDE"
        elif echo "${process_list}" | grep -q 'lxsession'; then
            desktop_env="LXDE"
        elif echo "${process_list}" | grep -q 'mate-session'; then
            desktop_env="MATE"
        elif echo "${process_list}" | grep -q 'cinnamon'; then
            desktop_env="Cinnamon"
        elif echo "${process_list}" | grep -q 'enlightenment'; then
            desktop_env="Enlightenment"
        elif echo "${process_list}" | grep -q 'openbox'; then
            desktop_env="Openbox"
        fi
    fi

    if [[ -z "${desktop_env}" ]]; then
        desktop_env="Unknown"
    fi

    printf "Desktop Environment: %s\n" "${desktop_env}"
    return 0
}

function PersonalSettings::OSInfo::terminal()
{
    local terminal_name

    local parent_pid=$$
    while true; do
        # Ensure parent_pid is valid
        if [[ -z "${parent_pid}" || "${parent_pid}" -le 1 ]]; then
            break
        fi

        local parent_comm
        parent_comm=$(ps -o comm= -p "${parent_pid}" 2>/dev/null)
        if [[ -z "${parent_comm}" ]]; then
            break
        fi

        case "${parent_comm}" in
            gnome-terminal-*|gnome-terminal)
                terminal_name="gnome-terminal"
                break
                ;;
            konsole|xfce4-terminal|xterm|mate-terminal|terminator| \
            lxterminal|rxvt|urxvt|alacritty|kitty|tilix|guake|tilda| \
            eterm|st|sakura|qterminal|hyper|cool-retro-term|wezterm|tmux|screen)
                terminal_name="${parent_comm}"
                break
                ;;
            *bash|*zsh|*fish|*ksh|*sh)
                # Continue up the process tree
                parent_pid=$(ps -o ppid= -p "${parent_pid}" 2>/dev/null | tr -d ' ')
                ;;
            *)
                # Continue up the process tree
                parent_pid=$(ps -o ppid= -p "${parent_pid}" 2>/dev/null | tr -d ' ')
                ;;
        esac
    done

    if [[ -n "${terminal_name:-}" ]]; then
        printf "Terminal: %s\n" "${terminal_name}"
    else
        printf "Terminal: Unknown\n"
        return 1
    fi

    return 0
}

# @brief Get the Package Manager name
#
# USAGE:
#   PersonalSettings::OSInfo::package_manager
# OUTPUT:
# Package Manager: apt
#
# @return 0 on success, 1 on failure
function PersonalSettings::OSInfo::package_manager()
{
    local package_manager

    if [[ -n "$(command -v apt)" ]]; then
        package_manager="apt"
    elif [[ -n "$(command -v dnf)" ]]; then
        package_manager="dnf"
    elif [[ -n "$(command -v yum)" ]]; then
        package_manager="yum"
    elif [[ -n "$(command -v zypper)" ]]; then
        package_manager="zypper"
    elif [[ -n "$(command -v pacman)" ]]; then
        package_manager="pacman"
    elif [[ -n "$(command -v emerge)" ]]; then
        package_manager="emerge"
    elif [[ -n "$(command -v apk)" ]]; then
        package_manager="apk"
    elif [[ -n "$(command -v pkg)" ]]; then
        package_manager="pkg"
    elif [[ -n "$(command -v rpm)" ]]; then
        package_manager="rpm"
    else
        package_manager="Unknown"
    fi

    printf "Package Manager: %s\n" "${package_manager}"
    return 0
}

# @brief Get the full OS information
#
# USAGE:
#   PersonalSettings::OSInfo::full_info
# OUTPUT:
# OS Name: Ubuntu
# OS Version: 24.04.1 LTS (Noble Numbat)
# OS ID: ubuntu
# OS ID Like: debian
# OS Version ID: 24.04
# OS Pretty Name: Ubuntu 24.04.1 LTS
# OS Codename: noble
# OS Hostname: SER8-server
# Package Manager: apt
# Arch: x86_64
# Kernel: 6.8.0-41-generic
# CPU: AMD Ryzen 7 8845HS w/ Radeon 780M Graphics
# GPU: Advanced Micro Devices, Inc. [AMD/ATI] Phoenix3 (rev c5)
# Total RAM: 27.19 GB (5600 MT/s)
# Shell: bash 5.2.21(1)-release
# Desktop Environment: XFCE
# Terminal: gnome-terminal
#
# return 0 on success, 1 on failure
function PersonalSettings::OSInfo::full_info()
{
    PersonalSettings::OSInfo::os_info || return 1
    PersonalSettings::OSInfo::package_manager || return 1
    PersonalSettings::OSInfo::arch || return 1
    PersonalSettings::OSInfo::kernel || return 1
    PersonalSettings::OSInfo::container || return 1
    PersonalSettings::OSInfo::cpu_name || return 1
    PersonalSettings::OSInfo::gpu_name || return 1
    PersonalSettings::OSInfo::ram_info || return 1
    PersonalSettings::OSInfo::shell || return 1
    PersonalSettings::OSInfo::desktop_environment || return 1
    PersonalSettings::OSInfo::terminal || return 1

    return 0
}

# @brief Print the full OS information
#
# USAGE:
#   PersonalSettings::OSInfo::print_full_info
# OUTPUT:
# [18:58:38] [INFO   ] [osinfo.sh:607] OS Information:
# [18:58:38] [INFO   ] [osinfo.sh:608] OS Hostname: SER8-server
# [18:58:38] [INFO   ] [osinfo.sh:609] OS Name: Ubuntu
# [18:58:38] [INFO   ] [osinfo.sh:610] OS Version: 24.04.1 LTS (Noble Numbat)
# [18:58:38] [INFO   ] [osinfo.sh:611] OS ID: ubuntu
# [18:58:38] [INFO   ] [osinfo.sh:612] OS ID Like: debian
# [18:58:38] [INFO   ] [osinfo.sh:613] OS Version ID: 24.04
# [18:58:38] [INFO   ] [osinfo.sh:614] OS Pretty Name: Ubuntu 24.04.1 LTS
# [18:58:38] [INFO   ] [osinfo.sh:615] OS Codename: noble
# [18:58:38] [INFO   ] [osinfo.sh:619] Kernel: 6.8.0-41-generic
# [18:58:38] [INFO   ] [osinfo.sh:620] Arch: x86_64
# [18:58:38] [INFO   ] [osinfo.sh:621] CPU: AMD Ryzen 7 8845HS w/ Radeon 780M Graphics
# [18:58:38] [INFO   ] [osinfo.sh:622] GPU: Advanced Micro Devices, Inc. [AMD/ATI] Phoenix3 (rev c5)
# [18:58:38] [INFO   ] [osinfo.sh:623] Total RAM: 27.19 GB (5600 MT/s)
# [18:58:38] [INFO   ] [osinfo.sh:624] Shell: bash 5.2.21(1)-release
# [18:58:38] [INFO   ] [osinfo.sh:625] Desktop Environment: XFCE
# [18:58:39] [INFO   ] [osinfo.sh:626] Terminal: gnome-terminal
# [18:58:39] [INFO   ] [osinfo.sh:627] Package Manager: apt
#
# @return alwasys 0
function PersonalSettings::OSInfo::print_full_info()
{
    PersonalSettings::Utils::Message::info "OS Information:"
    PersonalSettings::Utils::Message::info "$(PersonalSettings::OSInfo::os_info | grep -w 'OS Hostname' | head -n 1)"
    PersonalSettings::Utils::Message::info "$(PersonalSettings::OSInfo::os_info | grep -w 'OS Name' | head -n 1)"
    PersonalSettings::Utils::Message::info "$(PersonalSettings::OSInfo::os_info | grep -w 'OS Version' | head -n 1)"
    PersonalSettings::Utils::Message::info "$(PersonalSettings::OSInfo::os_info | grep -w 'OS ID' | head -n 1)"
    PersonalSettings::Utils::Message::info "$(PersonalSettings::OSInfo::os_info | grep -w 'OS ID Like' | head -n 1)"
    PersonalSettings::Utils::Message::info "$(PersonalSettings::OSInfo::os_info | grep -w 'OS Version ID' | head -n 1)"
    PersonalSettings::Utils::Message::info "$(PersonalSettings::OSInfo::os_info | grep -w 'OS Pretty Name' | head -n 1)"
    PersonalSettings::Utils::Message::info "$(PersonalSettings::OSInfo::os_info | grep -w 'OS Codename' | head -n 1)"
    if PersonalSettings::OSInfo::is_container; then
        PersonalSettings::Utils::Message::info "$(PersonalSettings::OSInfo::container)"
    fi
    PersonalSettings::Utils::Message::info "$(PersonalSettings::OSInfo::kernel)"
    PersonalSettings::Utils::Message::info "$(PersonalSettings::OSInfo::arch)"
    PersonalSettings::Utils::Message::info "$(PersonalSettings::OSInfo::cpu_name)"
    PersonalSettings::Utils::Message::info "$(PersonalSettings::OSInfo::gpu_name)"
    PersonalSettings::Utils::Message::info "$(PersonalSettings::OSInfo::ram_info)"
    PersonalSettings::Utils::Message::info "$(PersonalSettings::OSInfo::shell)"
    PersonalSettings::Utils::Message::info "$(PersonalSettings::OSInfo::desktop_environment)"
    PersonalSettings::Utils::Message::info "$(PersonalSettings::OSInfo::terminal)"
    PersonalSettings::Utils::Message::info "$(PersonalSettings::OSInfo::package_manager)"
}