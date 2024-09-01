#!/bin/bash

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_TOP_DIR="${SCRIPT_DIR}/.."

# @brief Function to run a docker test
#
# USAGE:
#   Test::Docker::run_test "Dockerfile path" "Docker tag" "Docker run command"
# OUTPUT:
#   Docker build output
#   Docker run output
#
# @param $1 - Dockerfile path
# @param $2 - Docker tag
#
# @return 0 on success, return 1 on failure
function Test::Docker::run_test()
{
    local dockerfile_path="${1}"
    local docker_tag="${2}"

    DOCKER_BUILDKIT=1 docker build --no-cache --file "${dockerfile_path}" --tag "${docker_tag}" "${PROJECT_TOP_DIR}" || return 1
    docker run --rm "${docker_tag}" || return 1
}

# @brief Function to run all docker tests in parallel
#
# USAGE:
#   Test::Docker::run_all_parallel
# OUTPUT:
#   Docker build output
#   Docker run output
#
# @return 0 on success, return 1 on failure
function Test::Docker::run_all_parallel()
{
    (
        ####################################### TEST UNIT #######################################
        # Test Ubuntu Latest
        Test::Docker::run_test "${PROJECT_TOP_DIR}/test/docker/Dockerfile_ubuntu_latest" "docker_ubuntu_latest" &
        docker_pid_1=$!

        # Test Ubuntu 24.04
        Test::Docker::run_test "${PROJECT_TOP_DIR}/test/docker/Dockerfile_ubuntu_2404" "docker_ubuntu_2404" &
        docker_pid_2=$!

        # Test Ubuntu 24.10
        Test::Docker::run_test "${PROJECT_TOP_DIR}/test/docker/Dockerfile_ubuntu_2410" "docker_ubuntu_2410" &
        docker_pid_3=$!

        ####################################### TEST END-TO-END #######################################

        # Test Ubuntu Latest
        Test::Docker::run_test "${PROJECT_TOP_DIR}/test/docker/Dockerfile_e2e_ubuntu_latest" "docker_e2e_ubuntu_latest" &
        docker_pid_4=$!

        # Test Ubuntu 24.04
        Test::Docker::run_test "${PROJECT_TOP_DIR}/test/docker/Dockerfile_e2e_ubuntu_2404" "docker_e2e_ubuntu_2404" &
        docker_pid_5=$!

        # Test Ubuntu 24.10
        Test::Docker::run_test "${PROJECT_TOP_DIR}/test/docker/Dockerfile_e2e_ubuntu_2410" "docker_e2e_ubuntu_2410" &
        docker_pid_6=$!

        wait $docker_pid_1 $docker_pid_2 $docker_pid_3 $docker_pid_4 $docker_pid_5 $docker_pid_6
    )

    if [ $? -ne 0 ]; then
        return 1
    fi
}

function Test::Docker::run_all()
{
    ####################################### TEST UNIT #######################################
    Test::Docker::run_test "${PROJECT_TOP_DIR}/test/docker/Dockerfile_ubuntu_latest" "docker_ubuntu_latest" || return 1
    Test::Docker::run_test "${PROJECT_TOP_DIR}/test/docker/Dockerfile_ubuntu_2404" "docker_ubuntu_2404" || return 1
    Test::Docker::run_test "${PROJECT_TOP_DIR}/test/docker/Dockerfile_ubuntu_2410" "docker_ubuntu_2410" || return 1

    ####################################### TEST END-TO-END #######################################
    Test::Docker::run_test "${PROJECT_TOP_DIR}/test/docker/Dockerfile_e2e_ubuntu_latest" "docker_e2e_ubuntu_latest" || return 1
    Test::Docker::run_test "${PROJECT_TOP_DIR}/test/docker/Dockerfile_e2e_ubuntu_2404" "docker_e2e_ubuntu_2404" || return 1
    Test::Docker::run_test "${PROJECT_TOP_DIR}/test/docker/Dockerfile_e2e_ubuntu_2410" "docker_e2e_ubuntu_2410" || return 1
}

# If user specifies the test to run in parallel by using -p flag then run the tests in parallel
if [[ "${1:-}" == "-p" ]]; then
    # Run the tests in parallel
    Test::Docker::run_all_parallel || exit 1
else
    # Run the tests sequentially
    Test::Docker::run_all || exit 1
fi
