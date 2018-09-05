#!/bin/bash

set -e
set +h

. /sources/build-properties

export MAKEFLAGS="-j `nproc`"
SOURCE_DIR="/sources"
LOGFILE="/sources/build-log"
STEPNAME="024-cmake.sh"
TARBALL="cmake-3.9.1.tar.gz"

if ! grep "$STEPNAME" $LOGFILE &> /dev/null
then

cd $SOURCE_DIR

if [ "$TARBALL" != "" ]
then
	DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`
	tar xf $TARBALL
	cd $DIRECTORY
fi

sed -i '/CMAKE_USE_LIBUV 1/s/1/0/' CMakeLists.txt     &&
sed -i '/"lib64"/s/64//' Modules/GNUInstallDirs.cmake &&

export CFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CXXFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CPPFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"

./bootstrap --prefix=/usr        \
            --system-libs        \
            --mandir=/share/man  \
            --no-system-jsoncpp  \
            --no-system-librhash \
            --no-system-curl     \
            --no-system-libarchive \
            --docdir=/share/doc/cmake-3.9.1 &&
make
make install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "$STEPNAME" | tee -a $LOGFILE

fi
