#!/bin/bash -ex

# shellcheck disable=SC1091
source "$(dirname "${0}")/_common.sh"

while IFS= read -r VERSION; do
    if ! buildAndPushCephWrapper "${VERSION}"; then
        echo "Error during buildAndPushCephWrapper, exiting 1"
        exit 1
    fi
done < <(grep -Po '^[^\W]+' "${SCRIPT_DIR}/../VERSIONS")
