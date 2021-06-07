FROM registry.access.redhat.com/ubi8/s2i-core

## ::: Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels
## ::: the LABEL directive is not affect the image size
LABEL name="s2ibinary" \
      org.opencontainers.image.authors="cprato79@gmail.com" \
      maintainer="claudio.prato@dedalus.eu" \
      vendor="" \
      summary="Utility image RedHat 8 based." \
      description="Utility Image aimed for create all it is needed by the s2i build process."

ENV CONTAINER=docker
# NSS_WRAPPER_FLAG=true

WORKDIR /workspace

## ::: utility and dependecies packages
RUN set -eux; \
    echo "===> Installing OS Utility"; \
    INSTALL_PKGS="git"; \
    yum -y install --setopt=tsflags=nodocs ${INSTALL_PKGS}; \
    rpm -q ${INSTALL_PKGS}; \
    yum -y clean all --enablerepo="*"; \
    rm -rf /var/cache/yum;

## ::: inject the s2i script inside image
## ::: sets io.openshift.s2i.scripts-url label that way, or update that label
COPY ./s2i/bin/ /usr/libexec/s2i

# Copy extra files to the image
# it needs of writing rights on path: ${APP_ROOT}/etc
COPY ./root/ / 

## ::: s2i setup
RUN set -eux; \
    echo "===> Getting the s2i binary"; \
    curl -Lks https://github.com/openshift/source-to-image/releases/download/v1.3.1/source-to-image-v1.3.1-a5a77147-linux-amd64.tar.gz | tar -xz  -C /usr/local/bin/; \
    chmod -R 755 /usr/local/bin/; \
    # chown -R 1001:0 {/workspace,${APP_ROOT},/usr/local/bin/s2i,/usr/local/bin/sti}; \
    chmod -R ug+rwX {/workspace,${APP_ROOT},/usr/local/bin/s2i,/usr/local/bin/sti}; \
    chmod g+w /etc/passwd;

# USER 1001

VOLUME ["/workspace"]

ENTRYPOINT ["/usr/libexec/s2i/run"]
