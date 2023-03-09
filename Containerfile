ARG VERSION=1.8.0
ARG OS=debian
FROM cloudposse/geodesic:$VERSION-$OS

# Add configuration options such as setting a custom BANNER,
# setting the initial AWS_PROFILE and AWS_DEFAULT_REGION, etc. here

ENV BANNER="Kube Toolbox"
ENV MOTD_URL=""

ENV KUBECONFIG=/localhost/.kube/config

# Pin kubectl minor version (must be within 1 minor version of cluster version)
# Note, however, that due to Docker layer caching and the structure of this
# particular Dockerfile, the patch version will not automatically update
# until you change the minor version or change the base Geodesic version.
# If you want, you can pin the patch level so you can update it when desired.
ARG KUBECTL_VERSION=1.23
RUN apt-get update && apt-get install kubectl-${KUBECTL_VERSION}

ENV KUBE_LINEAGE_VERSION="v0.5.0"
ARG KUBE_LINEAGE_SHA256="6b0d3cfea813fb6389a463d5ec556f04dcda0f74b6cecfe61e330aab730fee7f"
ARG KUBE_LINEAGE_FILENAME="kube-lineage_linux_amd64.tar.gz"
RUN set -x && \
    curl --retry 5 --retry-connrefused -LO "https://github.com/tohjustin/kube-lineage/releases/download/${KUBE_LINEAGE_VERSION}/${KUBE_LINEAGE_FILENAME}" && \
    echo "${KUBE_LINEAGE_SHA256}  ${KUBE_LINEAGE_FILENAME}" | sha256sum -c && \
    tar xvf "${KUBE_LINEAGE_FILENAME}" -C /usr/local/bin && \
    rm "${KUBE_LINEAGE_FILENAME}" && \
    kube-lineage --version | grep "${KUBE_LINEAGE_VERSION}"