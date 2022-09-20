#/bin/bash

set -ex

CEPH_POINT_RELEASE=${CEPH_POINT_RELEASE:=v17.2.3}

# docker build \
#  --build-arg CEPH_POINT_RELEASE="17.2.3" \
#  . --file Dockerfile \
#  --tag koor/ceph-container-unofficial:$latest_ceph_image_tag
docker build --build-arg CEPH_POINT_RELEASE="${CEPH_POINT_RELEASE}" . --file Dockerfile --tag dexter816/temp-repo:v17

