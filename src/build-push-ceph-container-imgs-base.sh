#/bin/bash

set -ex
script="$0"
basename="$(dirname $0)"

CEPH_POINT_RELEASE=${CEPH_POINT_RELEASE:=v17.2.3}

# docker build \
#  --build-arg CEPH_POINT_RELEASE="17.2.3" \
#  . --file Dockerfile \
#  --tag koor/ceph-container-unofficial:$latest_ceph_image_tag
docker build --build-arg CEPH_POINT_RELEASE=${CEPH_POINT_RELEASE} . --file $basename/Dockerfile --tag ${CONTAINER_REGISTRY}/${CONTAINER_REPO}:${CEPH_POINT_RELEASE}
docker push ${CONTAINER_REGISTRY}/${CONTAINER_REPO}:${CEPH_POINT_RELEASE}


