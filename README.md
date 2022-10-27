# koor-ceph-container

Additional dependencies packaging for making enhanced features available in
[Ceph Container Image](https://github.com/ceph/ceph-container).

Added library support for:

**Ceph Dashboard SSO**: The dashboard supports authentication via an external identity provider using the SAML 2.0 protocol.

**Ceph FS Top Utility**: Used to provide extra CephFS metrics for monitoring in
realtime. For more details, please refer:
https://docs.ceph.com/en/quincy/cephfs/cephfs-top/

## Find koor-ceph-container image:

The koor-ceph-container is hosted on [Koor's Docker Hub registry](https://hub.docker.com/repository/docker/koorinc/) and can be pulled using::
```bash
docker pull koorinc/koor-ceph-container:$versiontag
```

Version tags can be found on [Koor's Docker Hub registry](https://hub.docker.com/repository/docker/koorinc/koor-ceph-container/tags?page=1&ordering=last_updated)

Alternatively, tags could be found from command line using the following command (assuming you have `jq` installed):
```bash
$ curl -s https://registry.hub.docker.com/v2/repositories/koorinc/koor-ceph-container/tags/\?page_size\=100 | jq '."results"[] .name'
```
## Core Component Structure:

The builds are initiated by [`docker-image-rebuild.yaml` workflow](https://github.com/koor-tech/koor-ceph-container/actions/workflows/docker-image-rebuild.yml),
which sources environment variables from `.env` and shell scripts
`build-push-container-imgs* ` present at `src/` dir.
These scripts then pick up the latest stable release [Ceph container image from
quay registry](https://quay.io/repository/ceph/ceph?tab=tags) and minimally
rebuilds them with dependencies and configurations needed for additional feature
support using `src/Dockerfile` tagged as:

```
koorinc/koor-ceph-container:${RELEASE_VERSION}
```

The packaged images are based of CentOS. The rebuild image is then pushed to
Koor's Docker Hub registry and are made available for pulling them.
