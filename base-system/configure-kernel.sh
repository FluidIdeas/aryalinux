#!/bin/bash

set -e
set +h

echo "This helper starts from the checked-in generic amd64 config (see"
echo "kernel-configs/), applies LFS and AryaLinux requirements, then opens"
echo "menuconfig for manual tweaks."
echo ""
echo "Press Enter to continue or Ctrl+C to abort..."
read -r _

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/kernel-config.sh"

LINUX_TARBALL=$(grep kernel.org | grep linux | rev | cut -d/ -f1 | rev)
pushd ~/sources
LINUX_DIR=$(tar -tf $LINUX_TARBALL | cut -d/ -f1 | uniq)
tar xf $LINUX_TARBALL
cd $LINUX_DIR

make mrproper
kernel_configure_aryalinux

make menuconfig

cp -v .config "$SCRIPT_DIR/saved-kernel.config"

cd ~/sources
rm -rf $LINUX_DIR
popd

echo "Saved tuned configuration to base-system/saved-kernel.config"
