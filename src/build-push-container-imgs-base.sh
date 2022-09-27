#/bin/bash

set -ex
script="$0"
basename="$(dirname $0)"

if [ -z "$CEPH_POINT_RELEASE" ]; then
  echo "no CEPH_POINT_RELEASE provided... "
  exit 1
fi

docker build --build-arg CEPH_POINT_RELEASE=${CEPH_POINT_RELEASE} . --file $basename/Dockerfile --tag ${CONTAINER_REGISTRY}/${CONTAINER_REPO}:${CEPH_POINT_RELEASE}
docker push ${CONTAINER_REGISTRY}/${CONTAINER_REPO}:${CEPH_POINT_RELEASE}


