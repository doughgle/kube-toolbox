ARG VERSION=1.8.0
ARG OS=debian
FROM cloudposse/geodesic:$VERSION-$OS

# Add configuration options such as setting a custom BANNER,
# setting the initial AWS_PROFILE and AWS_DEFAULT_REGION, etc. here

ENV BANNER="Kube Toolbox"

ENV KUBECONFIG=/localhost/.kube/config

# Pin kubectl minor version (must be within 1 minor version of cluster version)
# Note, however, that due to Docker layer caching and the structure of this
# particular Dockerfile, the patch version will not automatically update
# until you change the minor version or change the base Geodesic version.
# If you want, you can pin the patch level so you can update it when desired.
ARG KUBECTL_VERSION=1.23
RUN apt-get update && apt-get install kubectl-${KUBECTL_VERSION}

# Move AWS CLI v1 to aws1 and set up alternatives
RUN mv /usr/local/bin/aws /usr/local/bin/aws1 && \
  update-alternatives --install /usr/local/bin/aws aws /usr/local/bin/aws1 1

# Install AWS CLI 2
# Get version from https://github.com/aws/aws-cli/blob/v2/CHANGELOG.rst
ARG AWS_CLI_VERSION=2.2.14
RUN AWSTMPDIR=$(mktemp -d -t aws-inst-XXXXXXXXXX) && \
  curl -sSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip" -o "$AWSTMPDIR/awscliv2.zip" && \
  cd $AWSTMPDIR && \
  unzip -qq awscliv2.zip && \
  ./aws/install -i /usr/share/aws/v2 -b /usr/share/aws/v2/bin && \
  update-alternatives --install /usr/local/bin/aws aws /usr/share/aws/v2/bin/aws 2 && \
  rm -rf $AWSTMPDIR
