#!/usr/bin/env sh

REPOSITORY="git://github.com/igloo-be/igloo-build-tools.git"
VERSION="v0.0.5"
TMPDIR="/tmp/igloo-build-tools"
INSTALL_DIR="/usr/local/bin"

install_deps () {
  if hash apk 2>/dev/null; then
    apk_install_deps
  else
    apt_install_deps
  fi
}

apt_install_deps () {
  apt-get update && apt-get install -y git awscli gettext
}

apk_install_deps () {
  apk add --no-cache git python py-pip gettext
  pip install awscli
}

install () {
  mkdir -p $TMPDIR
  git clone $REPOSITORY $TMPDIR
  cd $TMPDIR
  git checkout $VERSION
  cp $TMPDIR/bin/* /usr/local/bin
}

install_deps
install
