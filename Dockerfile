FROM docker:19.03.4

# curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt
ENV KUBECTL_VERSION=v1.16.2
# https://cloud.google.com/sdk/docs/downloads-versioned-archives?hl=fr
ENV CLOUD_SDK_VERSION=245.0.0
# https://github.com/helm/helm/releases
ENV HELM_VERSION="v2.15.2"

ENV PATH /google-cloud-sdk/bin:$PATH

RUN apk add --no-cache \
      bash \
      curl \
      ca-certificates \
      git \
      python \
      py-crcmod \
      py-pip \
      gettext \
      ncurses \
      libc6-compat \
      openssh-client \
      jq \
    && \
    echo "Install awscli..." && \
    pip install awscli && \
    echo "Install kubectl..." && \
    mkdir -p /usr/local/bin && \
    curl -L https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl \
      -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl && \
    echo "Install gcloud..." && \
    curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    mkdir -p /google-cloud-sdk && \
    tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    ln -s /lib /lib64 && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud config set metrics/environment github_docker_image && \
    gcloud --version && \
    echo "Install helm..." && \
    wget -q http://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm \
    && chmod +x /usr/local/bin/helm

COPY bin/* /usr/local/bin/
