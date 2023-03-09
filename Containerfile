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

ENV KUBECTL_TREE_VERSION="v0.4.3"
ARG KUBECTL_TREE_SHA256="3f92e0025297c687fe219679a69bfdc126c7b706be6eb96b90a24d9905471b2d"
ARG KUBECTL_TREE_FILENAME="kubectl-tree_${KUBECTL_TREE_VERSION}_linux_amd64.tar.gz"
RUN set -x && \
    curl --retry 5 --retry-connrefused -LO "https://github.com/ahmetb/kubectl-tree/releases/download/${KUBECTL_TREE_VERSION}/${KUBECTL_TREE_FILENAME}" && \
    echo "${KUBECTL_TREE_SHA256}  ${KUBECTL_TREE_FILENAME}" | sha256sum -c && \
    tar xvf "${KUBECTL_TREE_FILENAME}" -C /usr/local/bin && \
    rm "${KUBECTL_TREE_FILENAME}" && \
    kubectl tree --version | grep "${KUBECTL_TREE_VERSION}"