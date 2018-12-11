#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="libcrypto++"
DESCRIPTION="Crypto++ Library is a free C++ class library of cryptographic schemes."
VERSION="5.6.3"

URL=http://archive.ubuntu.com/ubuntu/pool/universe/libc/libcrypto++/libcrypto++_5.6.3.orig.tar.xz

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

sed -i "s@/usr/local@/usr@g" GNUmakefile
make "-j`nproc`"
make libcryptopp.so

sudo make install

sudo tee /usr/lib/pkgconfig/cryptopp.pc <<"EOF"
prefix= /usr
exec_prefix=${prefix}
libdir=${exec_prefix}/,lib,
includedir=${prefix}/include

Name: libcrypto++
Description: General purpose cryptographic shared library
URL: http://www.cryptopp.com
Version: %version
Requires:
Libs: -lcryptopp
Cflags:
EOF

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
