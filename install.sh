#!/usr/bin/env sh

REPOSITORY="git://github.com/igloo-be/igloo-build-tools.git"
TMPDIR="/tmp/igloo-build-tools"
INSTALL_DIR="/usr/local/bin"

function install_deps {
  if hash git 2>/dev/null; then
    return 0
  fi

  if hash apk 2>/dev/null; then
    apk_install_deps
  else
    apt_install_deps
  fi
}

function apt_install_deps {
  apt-get update && apt-get install -y git
}

function apk_install_deps {
  apk add --no-cache git
}

function install {
  mkdir -p $TMPDIR
  git clone $REPOSITORY $TMPDIR
  cp $TMPDIR/bin/* /usr/local/bin
}

install_deps
install
