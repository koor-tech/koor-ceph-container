#!/bin/bash

set -ex
script="$0"
basename="$(dirname $0)"

if [ -z "$CEPH_POINT_RELEASE" ]; then
  echo "no CEPH_POINT_RELEASE provided... "
  exit 1
fi

if curl -s https://registry.hub.docker.com/v2/repositories/koorinc/koor-ceph-container/tags/\?page_size\=100 | jq '."results"[] .name' | grep -q $CEPH_POINT_RELEASE; then
  echo "Container for $CEPH_POINT_RELEASE already available at DockerHub koorinc skipping build."
  exit 0
fi

docker build --build-arg CEPH_POINT_RELEASE=${CEPH_POINT_RELEASE} . --file $basename/Dockerfile --tag ${CONTAINER_REGISTRY}/${CONTAINER_REPO}:${CEPH_POINT_RELEASE}
docker push ${CONTAINER_REGISTRY}/${CONTAINER_REPO}:${CEPH_POINT_RELEASE}


