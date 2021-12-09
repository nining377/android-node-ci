#!/bin/bash

set -ex

# Used in ./configure.
CMD=${1:-build_x86_64}
TAG=${2:-12.22.7}

export CONFIGURE_OPTIONS="--without-npm --with-intl=small-icu --shared"

download_and_extract() {
  local FILENAME="v$TAG.tar.gz"

  curl -L https://github.com/nodejs/node/archive/refs/tags/${FILENAME} > $FILENAME
  tar zxvf "$FILENAME"
  cp android-configure node-$TAG/
}


build-android() {
  ./android-configure $ANDROID_NDK_HOME $ANDROID_ABI 23
   make -j4
}

# Run in subshell 
download_and_extract > /dev/null
(cd node-$TAG && $CMD)