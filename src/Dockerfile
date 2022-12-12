ARG CEPH_POINT_RELEASE
FROM quay.io/ceph/ceph:$CEPH_POINT_RELEASE

# Install the extra features packages(for more details please refer README) and then clean container,
# starting with record of current size (strip / from end)
RUN dnf install -y python3-pip xmlsec1 xmlsec1-nss xmlsec1-openssl && \
    dnf install -y cephfs-top && \
    pip3 install python3-saml && \
    INITIAL_SIZE="$(bash -c 'sz="$(du -sm --exclude=/proc /)" ; echo "${sz%*/}"')" && \
    # Clean common files like /tmp, /var/lib, \
    yum clean all && rm -rf \
        /etc/{selinux,systemd,udev} \
        /lib/{lsb,udev} \
        /tmp/* \
        /usr/lib{,64}/{locale,systemd,udev,dracut} \
        /usr/share/{doc,info,locale,man} \
        /usr/share/{bash-completion,pkgconfig/bash-completion.pc} \
        /var/log/* \
        /var/tmp/* && \
    find  / -xdev -name "*.pyc" -o -name "*.pyo" -exec rm -f {} \; && \
    # ceph-dencoder is only used for debugging, compressing it saves 10MB
    # If needed it will be decompressed
    # TODO: Is ceph-dencoder safe to remove as rook was trying to do?
    # rm -f /usr/bin/ceph-dencoder &&
    if [ -f /usr/bin/ceph-dencoder ]; then gzip -9 /usr/bin/ceph-dencoder; fi && \
    rm -f /usr/lib/ceph/mgr/dashboard/static/AdminLTE-*/plugins/datatables/extensions/TableTools/images/psd/* && \
    # Some logfiles are not empty, there is no need to keep them
    find /var/log/ -type f -exec truncate -s 0 {} \; && \
    # Report size savings (strip / from end)
    FINAL_SIZE="$(bash -c 'sz="$(du -sm --exclude=/proc /)" ; echo "${sz%*/}"')" && \
    REMOVED_SIZE=$((INITIAL_SIZE - FINAL_SIZE)) && \
    echo "Cleaning process removed ${REMOVED_SIZE}MB" && \
    echo "Dropped container size from ${INITIAL_SIZE}MB to ${FINAL_SIZE}MB";
