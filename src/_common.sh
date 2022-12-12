#!/bin/bash

SCRIPT_DIR="$(dirname "${0}")"

REPO_QUAY_TAGS_PAGE_SIZE="${REPO_QUAY_TAGS_PAGE_SIZE:-50}"

# Usage: [VERSION_REGEX]
getCephPointRelease() {
    VERSION_REGEX="${1}"
    if [ -z "${VERSION_REGEX}" ]; then
        echo "No argument given to getCephPointRelease (needed: version regex) ..."
        return 1
    fi
    CEPH_POINT_RELEASE=$(curl -s -L \
        "https://quay.io/api/v1/repository/ceph/ceph/tag?page_size=${REPO_QUAY_TAGS_PAGE_SIZE}" | \
        jq -r '."tags"[].name' | \
        sort -r --version-sort | \
		grep "${VERSION_REGEX}" | \
		head -n 1)
    retVal=$?
    if [ $retVal -ne 0 ]; then
        echo "Failed to get the Ceph Point Release from quay.io API."
        return 1
    fi

    if [ -z "${CEPH_POINT_RELEASE}" ]; then
        echo "Empty Ceph point release found. quay.io/ceph/ceph repo doesn't seem to have a tag for version regex '${VERSION_REGEX}'"
        exit 2
    fi

    echo "${CEPH_POINT_RELEASE}"
}

# Usage: [CEPH_POINT_RELEASE]
checkIfAlreadyExists() {
    CEPH_POINT_RELEASE="${1}"
    if [ -z "${CEPH_POINT_RELEASE}" ]; then
        echo "No argument given to checkIfAlreadyExists (needed: ceph point release) ..."
        return 2
    fi

    if curl -s "https://registry.hub.docker.com/v2/repositories/koorinc/koor-ceph-container/tags/?page_size=${REPO_QUAY_TAGS_PAGE_SIZE}" | jq -r '.results[].name' | grep -q "$CEPH_POINT_RELEASE"; then
        return 0
    fi

    return 1
}

# Usage: [CEPH_POINT_RELEASE]
buildAndPushCephPointRelease() {
    CEPH_POINT_RELEASE="${1}"
    if [ -z "${CEPH_POINT_RELEASE}" ]; then
        echo "No argument given to buildAndPushCephPointRelease (needed: ceph point release) ..."
        return 1
    fi

    if checkIfAlreadyExists "${CEPH_POINT_RELEASE}"; then
        echo "Container for ${CEPH_POINT_RELEASE} already available at koorinc's Docker Hub, skipping build."
        return 0
    fi

    docker build \
        --build-arg CEPH_POINT_RELEASE="${CEPH_POINT_RELEASE}" \
        --file "${SCRIPT_DIR}/Dockerfile" \
        --tag "${CONTAINER_REGISTRY}/${CONTAINER_REPO}:${CEPH_POINT_RELEASE}" \
        .

    docker push "${CONTAINER_REGISTRY}/${CONTAINER_REPO}:${CEPH_POINT_RELEASE}"
}

# Usage: [VERSION_REGEX]
buildAndPushCephWrapper() {
    VERSION_REGEX="${1}"
    if [ -z "${VERSION_REGEX}" ]; then
        echo "No argument given to buildAndPushCephWrapper (needed: version regex) ..."
        return 1
    fi

    CEPH_POINT_RELEASE=$(getCephPointRelease "$VERSION_REGEX")
    retVal=$?
    if [ $retVal -ne 0 ]; then
        echo "Failed to get the Ceph Point Release"
        return 1
    fi

    buildAndPushCephPointRelease "${CEPH_POINT_RELEASE}"
}
