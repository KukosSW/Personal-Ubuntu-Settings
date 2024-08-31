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

function Test::TestSuite::run()
{
    Test::Utils::pass "Test::Utils::pass"
}

Test::TestSuite::run