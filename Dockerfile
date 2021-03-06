FROM alpine
LABEL maintainer="matthew.slowe@jisc.ac.uk"
LABEL Description="Alpine Linux based container with rad_eap_test available"
ARG UPSTREAM_VERSION
ENV UPSTREAM_VERSION ${UPSTREAM_VERSION:-0.26}

COPY rad_eap_test-*.patch /

RUN set -x && \
    apk update && apk add wpa_supplicant bind-tools && \
    wget https://www.eduroam.cz/rad_eap_test/rad_eap_test-${UPSTREAM_VERSION}.tar.bz2 && \
    tar xf rad_eap_test-${UPSTREAM_VERSION}.tar.bz2 && \
    patch -p0 -i rad_eap_test-busybox-grep.patch rad_eap_test-${UPSTREAM_VERSION}/rad_eap_test && \
    patch -p0 -i rad_eap_test-ssid.patch rad_eap_test-${UPSTREAM_VERSION}/rad_eap_test && \
    ln -s /rad_eap_test-${UPSTREAM_VERSION}/rad_eap_test /usr/local/bin/rad_eap_test && \
    ln -s /sbin/eapol_test /bin

ENTRYPOINT ["/usr/local/bin/rad_eap_test"]
