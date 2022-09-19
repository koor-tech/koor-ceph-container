#/bin/bash

set -ex

CEPH_IMAGE_TAG=${CEPH_IMAGE_TAG:=v17.2.3}

# docker build \
#  --build-arg CEPH_IMAGE_TAG="17.2.3" \
#  . --file Dockerfile \
#  --tag koor/ceph-container-unofficial:$latest_ceph_image_tag
docker build --build-arg CEPH_IMAGE_TAG="${CEPH_IMAGE_TAG}" . --file Dockerfile --tag dexter816/temp-repo:v17

