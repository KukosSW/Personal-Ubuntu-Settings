#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_TOP_DIR="${SCRIPT_DIR}/.."

function Test::Utils::fail()
{
    printf "%b[TEST] FAILED: ${1}%b\n" "\033[0;31m" "\033[0m"
    exit 1
}

function Test::Utils::pass()
{
    printf "%b[TEST] PASSED: ${1}%b\n" "\033[0;32m" "\033[0m"
}

function Test::Utils::shellcheck_check()
{
    local script="${1}"
    if shellcheck --shell=bash --enable=all --external-sources "${script}"; then
        Test::Utils::pass "Shellcheck: ${script}"
    else
        Test::Utils::fail "Shellcheck: ${script}"
    fi
}

function Test::TestCase::shellcheck()
{
    Test::Utils::shellcheck_check "${PROJECT_TOP_DIR}/src/message.sh"
}

function Test::TestSuite::run()
{

    Test::TestCase::shellcheck
}

Test::TestSuite::run