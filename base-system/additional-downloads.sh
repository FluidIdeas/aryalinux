#!/bin/bash

set -e
set +h

VERSION=1.0

CURRENT_DIR=$(pwd)
pushd ~/sources

wget -nc https://github.com/dosfstools/dosfstools/releases/download/v4.1/dosfstools-4.1.tar.xz
wget -nc http://ftp.gnu.org/gnu/which/which-2.21.tar.gz
wget -nc http://mirrors.ocf.berkeley.edu/tanglu/pool/main/o/os-prober/os-prober_1.71.tar.xz
wget -nc https://github.com/rhboot/efivar/releases/download/31/efivar-31.tar.bz2
wget -nc https://github.com/rhboot/efibootmgr/releases/download/14/efibootmgr-14.tar.bz2
wget -nc https://downloads.sourceforge.net/freetype/freetype-2.9.tar.bz2
wget -nc http://unifoundry.com/pub/unifont-7.0.05/font-builds/unifont-7.0.05.pcf.gz
wget -nc https://www.kernel.org/pub/software/utils/pciutils/pciutils-3.5.5.tar.xz
wget -nc http://rpm5.org/files/popt/popt-1.16.tar.gz
wget -nc https://sourceforge.net/projects/aryalinux-bin/files/artifacts/linux-firmware.tar.xz
wget -nc https://ftp.gnu.org/gnu/cpio/cpio-2.12.tar.bz2
wget -nc https://ftp.osuosl.org/pub/blfs/conglomeration/lsb-release/lsb-release-1.4.tar.gz
wget -nc https://busybox.net/downloads/fixes-1.20.2/busybox-1.20.2-sys-resource.patch
wget -nc https://busybox.net/downloads/busybox-1.20.2.tar.bz2
wget -nc https://ftp.gnu.org/gnu/nettle/nettle-3.3.tar.gz
wget -nc https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.12.tar.gz
wget -nc https://github.com/p11-glue/p11-kit/releases/download/0.23.8/p11-kit-0.23.8.tar.gz
wget -nc https://www.gnupg.org/ftp/gcrypt/gnutls/v3.5/gnutls-3.5.14.tar.xz
wget -nc https://ftp.gnu.org/gnu/wget/wget-1.19.1.tar.xz
wget -nc http://www.sudo.ws/dist/sudo-1.8.20p2.tar.gz
wget -nc https://www.python.org/ftp/python/2.7.13/Python-2.7.13.tar.xz
wget -nc https://github.com/djlucas/make-ca/archive/v0.7/make-ca-0.7.tar.gz
wget -nc http://www.cacert.org/certs/root.crt
wget -nc http://www.cacert.org/certs/class3.crt
wget -nc https://hg.mozilla.org/projects/nss/raw-file/tip/lib/ckfw/builtins/certdata.txt
wget -nc http://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-4.06.tar.xz
wget -nc http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.9.1.tar.gz

wget -nc https://github.com/dracutdevs/dracut/archive/master.zip
unzip master.zip
tar -cJvf dracut-master.tar.xz dracut-master
rm -r dracut-master
rm -r master.zip

wget -nc https://sourceware.org/ftp/lvm2/releases/LVM2.2.02.171.tgz
wget -nc https://github.com/FluidIdeas/patches/raw/$VERSION/aufs-4.16.tar.gz
wget -nc https://raw.githubusercontent.com/FluidIdeas/patches/$VERSION/aufs4-base.patch
wget -nc https://raw.githubusercontent.com/FluidIdeas/patches/$VERSION/aufs4-kbuild.patch
wget -nc https://raw.githubusercontent.com/FluidIdeas/patches/$VERSION/aufs4-loopback.patch
wget -nc https://raw.githubusercontent.com/FluidIdeas/patches/$VERSION/aufs4-mmap.patch
wget -nc https://raw.githubusercontent.com/FluidIdeas/patches/$VERSION/aufs4-standalone.patch
wget -nc https://sourceware.org/ftp/elfutils/0.170/elfutils-0.170.tar.bz2
wget -nc https://raw.githubusercontent.com/FluidIdeas/patches/$VERSION/0.21-nvme_ioctl.h.patch

pushd $CURRENT_DIR/../applications
git checkout $VERSION
git pull
tar -czf alps-scripts-$VERSION.tar.gz *.sh
popd

mv -f $CURRENT_DIR/../applications/alps-scripts-$VERSION.tar.gz .

wget -nc https://sourceforge.net/projects/cdrtools/files/cdrtools-3.01.tar.bz2
wget -nc https://launchpad.net/ubuntu/+archive/primary/+files/cdrkit_1.1.11.orig.tar.gz
wget -nc https://cmake.org/files/v3.9/cmake-3.9.1.tar.gz
wget -nc https://sourceforge.net/projects/squashfs/files/squashfs/squashfs4.3/squashfs4.3.tar.gz
wget -nc http://downloads.sourceforge.net/infozip/unzip60.tar.gz

set +e

wget https://raw.githubusercontent.com/FluidIdeas/alps/master/var/lib/alps/functions -O functions
wget https://raw.githubusercontent.com/FluidIdeas/alps/master/usr/bin/alps -O alps
wget https://raw.githubusercontent.com/FluidIdeas/alps/master/etc/alps/alps.conf -O alps.conf
wget https://raw.githubusercontent.com/FluidIdeas/package-builder/master/makepkg.sh -O makepkg.sh

set -e

popd
