#!/bin/bash

set -ex
script="$0"
basename="$(dirname $0)"

VERSION_REGEX="v17"
CEPH_POINT_RELEASE=$(curl -s -L \
                 https://quay.io/api/v1/repository/ceph/ceph/tag\?page_size\=100 \
	         | jq -r '."tags"[].name' \
		 | sort -r --version-sort \
		 | grep $VERSION_REGEX \
		 | head -n 1)

CEPH_POINT_RELEASE=$CEPH_POINT_RELEASE $basename/build-push-ceph-container-imgs-base.sh

