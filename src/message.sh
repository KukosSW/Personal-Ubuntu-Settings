#!/usr/bin/env bash

set -Eu

# Get the directory of this script
# SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# PROJECT_TOP_DIR="${SCRIPT_DIR}/.."


# @brief Private function to print messages to the stderr
#
# USAGE:
#   PersonalSettings::Utils::Message::__message "INFO" "\033[0;34m" "This is an info message"
# OUTPUT:
#   [18:32:50] [INFO   ] [message.sh:72] This is an info message
#
# @param $1 - Message level string (e.g. INFO, WARNING, ERROR)
# @param $2 - Color code for the message level string (e.g. "\033[0;34m" for blue)
# @param $3 - Message to print
#
# @return 0
function PersonalSettings::Utils::Message::__message()
{
    local message_level_string="${1}"
    local color="${2}"
    local message="${3}"
    local timestamp
    local caller
    local file_name
    local line_number
    local color_reset="\033[0m"

    timestamp=$(date +"%H:%M:%S")
    caller=$(caller 1)
    file_name=${caller##*/}
    line_number=${caller%% *}

    local aligned_log_level
    local aligned_timestamp

    aligned_log_level=$(printf "%-7s" "${message_level_string}")
    aligned_timestamp=$(printf "%-7s" "${timestamp}")

    printf "%b[%s] [%s] [%s:%s] %s%b\n" \
           "${color}" \
           "${aligned_timestamp}" \
           "${aligned_log_level}" \
           "${file_name}" \
           "${line_number}" \
           "${message}" \
           "${color_reset}" \
        >&2

    return 0
}

# @brief Function to print INFO message
#
# USAGE:
#   PersonalSettings::Utils::Message::info "This is an info message"
# OUTPUT:
#   [18:32:50] [INFO   ] [message.sh:72] This is an info message
#
# @param $1 - Message to print
#
# @return 0
function PersonalSettings::Utils::Message::info()
{
    PersonalSettings::Utils::Message::__message "INFO" "\033[0;34m" "${1}"

    return 0
}

# @brief Function to print WARNING message
#
# USAGE:
#   PersonalSettings::Utils::Message::warning "This is a warning message"
# OUTPUT:
#   [18:32:50] [WARNING] [message.sh:72] This is a warning message
#
# @param $1 - Message to print
#
# @return 0
function PersonalSettings::Utils::Message::warning()
{
    PersonalSettings::Utils::Message::__message "WARNING" "\033[0;33m" "${1}"

    return 0
}

# @brief Function to print ERROR message
#
# USAGE:
#   PersonalSettings::Utils::Message::error "This is an error message"
# OUTPUT:
#   [18:32:50] [ERROR  ] [message.sh:72] This is an error message
#
# @param $1 - Message to print
#
# @return 0
function PersonalSettings::Utils::Message::error()
{
    PersonalSettings::Utils::Message::__message "ERROR" "\033[0;31m" "${1}"

    return 0
}

# @brief Function to print SUCCESS message
#
# USAGE:
#   PersonalSettings::Utils::Message::success "This is a success message"
# OUTPUT:
#   [18:32:50] [DEBUG  ] [message.sh:72] This is a success message
#
# @param $1 - Message to print
#
# @return 0
function PersonalSettings::Utils::Message::success()
{
    PersonalSettings::Utils::Message::__message "SUCCESS" "\033[0;32m" "${1}"

    return 0
}

# MANUAL TESTING
# PersonalSettings::Utils::Message::info "This is an info message"
# PersonalSettings::Utils::Message::warning "This is a warning message"
# PersonalSettings::Utils::Message::error "This is an error message"
# PersonalSettings::Utils::Message::success "This is a success message"