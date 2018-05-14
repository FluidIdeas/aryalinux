#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="libfftw3"
DESCRIPTION="FFTW is a C subroutine library for computing the discrete Fourier transform (DFT) in one or more dimensions, of arbitrary input size, and of both real and complex data (as well as of even/odd data, i.e. the discrete cosine/sine transforms or DCT/DST)"
VERSION="3.3.5"

URL=http://www.fftw.org/fftw-3.3.5.tar.gz

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

CFLAGS="$CFLAGS -fPIC" ./configure --prefix=/usr --enable-double --enable-shared --enable-openmp --enable-threads
make "-j`nproc`"
sudo make install
make clean
CFLAGS="$CFLAGS -fPIC" ./configure --prefix=/usr --enable-float --enable-shared --enable-openmp --enable-threads
make "-j`nproc`"
sudo make install
make clean
CFLAGS="$CFLAGS -fPIC" ./configure --prefix=/usr --enable-long-double --enable-shared --enable-openmp --enable-threads
make "-j`nproc`"
sudo make install
make clean

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
