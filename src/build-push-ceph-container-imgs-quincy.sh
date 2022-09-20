#!/bin/bash

set -ex

VERSION_REGEX="v17"
CEPH_POINT_RELEASE=$(curl -s -L \
                 https://quay.io/api/v1/repository/ceph/ceph/tag\?page_size\=100 \
	         | jq '."tags"[].name' \
		 | sort -r --version-sort \
		 | grep $VERSION_REGEX \
		 | head -n 1)

CEPH_POINT_RELEASE=$CEPH_POINT_RELEASE ./build-push-ceph-container-imgs-base.sh

