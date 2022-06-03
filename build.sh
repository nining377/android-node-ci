#!/bin/bash

set -ex

# Used in ./configure.
CMD=${1:-build_x86_64}
# 12.22.12
# 14.19.3
# 16.15.1
TAG=${2:-14.19.3}

download_and_extract() {
  local FILENAME="v$TAG.tar.gz"

  curl -L https://github.com/nodejs/node/archive/refs/tags/${FILENAME} > $FILENAME
  tar zxvf "$FILENAME"
  cp android-configure node-$TAG/
}


build-android() {

  # make sure some functions are available in link stage
  ver=$(echo $TAG | awk -F . '{print $1}')
  if [ $ver -eq 14 ]; then
    sed -i "s/.src\/unix\/android-ifaddrs.c.,/'src\/unix\/android-ifaddrs.c','src\/unix\/epoll.c',/g" deps/uv/uv.gyp
  fi
  
  ./android-configure $ANDROID_NDK_HOME $ANDROID_ABI 23 $TAG

  make -j4
}

# Run in subshell 
download_and_extract > /dev/null
(cd node-$TAG && $CMD)
