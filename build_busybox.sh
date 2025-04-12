#!/bin/bash

set -xe

VERSION="${1:-1.36.1}"
TARGET_BINARY="${2:-busybox}"
WORKDIR=$(pwd)
SRC_DIR="busybox-$VERSION"
TARBALL="busybox-$VERSION.tar.bz2"
URL="https://busybox.net/downloads/$TARBALL"

if [ ! -f "$TARBALL" ]; then
    curl -LO "$URL"
fi

if [ ! -d "$SRC_DIR" ]; then
    tar -xf "$TARBALL"
fi

cd "$SRC_DIR"

make distclean
make defconfig
sed -i 's/^# CONFIG_STATIC is not set/CONFIG_STATIC=y/' .config
yes "" | make oldconfig
make -j$(nproc)

INSTALL_DIR="$WORKDIR/busybox-install"
make CONFIG_PREFIX="$INSTALL_DIR" install

echo "copy busybox to $WORKDIR"
cp "$INSTALL_DIR"/bin/busybox "$WORKDIR/$TARGET_BINARY"
