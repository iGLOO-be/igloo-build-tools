FROM docker:23.0.5-alpine3.17

ENV KUBECTL_VERSION=v1.25.9
ENV CLOUD_SDK_VERSION=429.0.0
ENV HELM_VERSION="v3.11.3"
ENV HELM2_VERSION="v2.16.7"

ENV PATH /google-cloud-sdk/bin:$PATH

RUN apk add --update --no-cache \
      bash \
      curl \
      ca-certificates \
      git \
      python3 \
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
    gcloud components install gke-gcloud-auth-plugin && \
    echo "Install helm..." && \
    wget -q https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm \
    && chmod +x /usr/local/bin/helm && \
    wget -q https://get.helm.sh/helm-${HELM2_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm2 \
    && chmod +x /usr/local/bin/helm2

COPY bin/* /usr/local/bin/
