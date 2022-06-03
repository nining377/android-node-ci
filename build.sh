#!/bin/bash

set -ex

# Used in ./configure.
CMD=${1:-build_x86_64}
# 12.22.12-最新v12 LTS版本
# 14.2.0-第一个可以使用without-snapshot的版本
# 16.10.0-再往上不可编译，报undefined reference to `ProbeMemory'
TAG=${2:-14.19.3}

download_and_extract() {
  local FILENAME="v$TAG.tar.gz"

  curl -L https://github.com/nodejs/node/archive/refs/tags/${FILENAME} > $FILENAME
  tar zxvf "$FILENAME"
  cp android-configure node-$TAG/
}


build-android() {

  # make sure some functions are available in link stage
  sed -i "s/.src\/unix\/android-ifaddrs.c.,/'src\/unix\/android-ifaddrs.c','src\/unix\/epoll.c',/g" deps/uv/uv.gyp
  
  ./android-configure $ANDROID_NDK_HOME $ANDROID_ABI 23

  make -j4
}

# Run in subshell 
download_and_extract > /dev/null
(cd node-$TAG && $CMD)
