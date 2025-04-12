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
sed -i 's/^# CONFIG_MINIPS is not set/CONFIG_MINIPS=y/' .config
sed -i 's/^# CONFIG_NUKE is not set/CONFIG_NUKE=y/' .config
sed -i 's/^# CONFIG_FEATURE_VI_REGEX_SEARCH is not set/CONFIG_FEATURE_VI_REGEX_SEARCH=y/' .config
sed -i 's/^# CONFIG_TUNE2FS is not set/CONFIG_TUNE2FS=y/' .config
sed -i 's/^# CONFIG_FEATURE_MOUNT_HELPERS is not set/CONFIG_FEATURE_MOUNT_HELPERS=y/' .config
sed -i 's/^# CONFIG_FEATURE_MOUNT_NFS is not set/CONFIG_FEATURE_MOUNT_NFS=y/' .config
sed -i 's/^# CONFIG_INOTIFYD is not set/CONFIG_INOTIFYD=y/' .config
sed -i 's/^# CONFIG_RFKILL is not set/CONFIG_RFKILL=y/' .config
sed -i 's/^# CONFIG_SETENFORCE is not set/CONFIG_SETENFORCE=y/' .config
sed -i 's/^# CONFIG_GETENFORCE is not set/CONFIG_GETENFORCE=y/' .config
sed -i 's/^# CONFIG_TUNE2FS is not set/CONFIG_TUNE2FS=y/' .config
sed -i 's/^# CONFIG_FDISK_SUPPORT_LARGE_DISKS is not set/CONFIG_FDISK_SUPPORT_LARGE_DISKS=y/' .config

yes "" | make oldconfig
make -j$(nproc)

INSTALL_DIR="$WORKDIR/busybox-install"
make CONFIG_PREFIX="$INSTALL_DIR" install

echo "copy busybox to $WORKDIR"
cp "$INSTALL_DIR"/bin/busybox "$WORKDIR/$TARGET_BINARY"
