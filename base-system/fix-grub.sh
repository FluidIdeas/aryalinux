#!/bin/bash

set -e
set +h

. /sources/build-properties

export MAKEFLAGS="-j `nproc`"
SOURCE_DIR="/sources"
LOGFILE="/sources/build-log"
STEPNAME="091-grub.sh"
TARBALL="grub-2.02.tar.xz"

cd $SOURCE_DIR

rm -rf grub-2.02
tar xf $TARBALL
cd grub-2.02

patch -Np1 -i ../grub-2.02-gcc.patch
patch -Np1 -i ../grub-2.02-relocation.patch
sed -i "s@GNU GRUB  version %s@$OS_NAME $OS_VERSION $OS_CODENAME \- GNU GRUB@g" grub-core/normal/main.c

if [ `uname -m` == "x86_64" ]
then

export CFLAGS=
export CXXFLAGS=
export CPPFLAGS=

./configure --prefix=/usr      \
	--sbindir=/sbin        \
	--localstatedir=/var   \
	--sysconfdir=/etc      \
	--enable-grub-mkfont   \
	--program-prefix=""    \
	--with-bootdir="/boot" \
	--with-grubdir="grub"  \
	--disable-werror       \
	--with-platform=efi --target=x86_64 &&
make "-j`nproc`"
make install
make clean

fi

export CFLAGS=
export CXXFLAGS=
export CPPFLAGS=

./configure --prefix=/usr      \
	--sbindir=/sbin        \
	--localstatedir=/var   \
	--sysconfdir=/etc      \
	--enable-grub-mkfont   \
	--program-prefix=""    \
	--with-bootdir="/boot" \
	--with-grubdir="grub"  \
	--disable-werror &&
make
make install

mkdir -pv /usr/share/fonts/unifont
gunzip -c ../unifont-7.0.05.pcf.gz > /usr/share/fonts/unifont/unifont.pcf
grub-mkfont -o /usr/share/grub/unicode.pf2 /usr/share/fonts/unifont/unifont.pcf

cd $SOURCE_DIR
if [ "$TARBALL" != "" ]
then
	rm -rf grub-2.02
	rm -rf {gcc,glibc,binutils}-build
fi

rm -rf grub-2.02
