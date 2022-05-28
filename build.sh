#!/bin/bash

set -ex

# Used in ./configure.
CMD=${1:-build_x86_64}
# 12.22.12-最新v12 LTS版本
# 14.2.0-第一个可以使用without-snapshot的版本
TAG=${2:-12.13.1}

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