#!/bin/bash

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_TOP_DIR="${SCRIPT_DIR}/.."

####################################### TEST UNIT #######################################

# Test Ubuntu Latest
DOCKER_BUILDKIT=1 docker build --file ${PROJECT_TOP_DIR}/test/docker/Dockerfile_ubuntu_latest --tag docker_ubuntu_latest ${PROJECT_TOP_DIR}
docker run --rm docker_ubuntu_latest || exit 1

# Test Ubuntu 24.04
DOCKER_BUILDKIT=1 docker build --file ${PROJECT_TOP_DIR}/test/docker/Dockerfile_ubuntu_2404 --tag docker_ubuntu_2404 ${PROJECT_TOP_DIR}
docker run --rm docker_ubuntu_2404 || exit 1

# Test Ubuntu 24.10
DOCKER_BUILDKIT=1 docker build --file ${PROJECT_TOP_DIR}/test/docker/Dockerfile_ubuntu_2410 --tag docker_ubuntu_2410 ${PROJECT_TOP_DIR}
docker run --rm docker_ubuntu_2410 || exit 1

####################################### TEST END-TO-END #######################################

# Test Ubuntu Latest
DOCKER_BUILDKIT=1 docker build --file ${PROJECT_TOP_DIR}/test/docker/Dockerfile_e2e_ubuntu_latest --tag docker_e2e_ubuntu_latest ${PROJECT_TOP_DIR}
docker run --rm docker_e2e_ubuntu_latest || exit 1

# Test Ubuntu 24.04
DOCKER_BUILDKIT=1 docker build --file ${PROJECT_TOP_DIR}/test/docker/Dockerfile_e2e_ubuntu_2404 --tag docker_e2e_ubuntu_2404 ${PROJECT_TOP_DIR}
docker run --rm docker_e2e_ubuntu_2404 || exit 1

# Test Ubuntu 24.10
DOCKER_BUILDKIT=1 docker build --file ${PROJECT_TOP_DIR}/test/docker/Dockerfile_ubuntu_2410 --tag docker_e2e_ubuntu_2410 ${PROJECT_TOP_DIR}
docker run --rm docker_e2e_ubuntu_2410 || exit 1