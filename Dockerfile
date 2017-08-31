FROM docker:1.13.1

RUN apk add --no-cache \
      curl \
      ca-certificates \
      git \
      python \
      py-pip \
      gettext \
      ncurses \
    && \
    echo "\nInstall awscli..." && \
    pip install awscli && \
    echo "\nInstall kubectl..." && \
    mkdir -p /usr/local/bin && \
    curl -L https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
      -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl

COPY bin/* /usr/local/bin/
