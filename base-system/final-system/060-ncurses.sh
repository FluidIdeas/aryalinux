#!/bin/bash

set -e
set +h

. /sources/build-properties

if [ "x$MULTICORE" == "xy" ] || [ "x$MULTICORE" == "xY" ]
then
	export MAKEFLAGS="-j 1"
fi

SOURCE_DIR="/sources"
LOGFILE="/sources/build-log"
STEPNAME="060-ncurses.sh"
TARBALL="ncurses-6.1.tar.gz"

echo "$LOGLENGTH" > /sources/lines2track

if ! grep "$STEPNAME" $LOGFILE &> /dev/null
then

cd $SOURCE_DIR

if [ "$TARBALL" != "" ]
then
	DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`
	tar xf $TARBALL
	cd $DIRECTORY
fi

if [ "$BUILD_ARCH" != "none" ]; then
	export CFLAGS="$CFLAGS -march=$BUILD_ARCH"
	export CXXFLAGS="$CXXFLAGS -march=$BUILD_ARCH"
	export CPPFLAGS="$CPPFLAGS -march=$BUILD_ARCH"
fi
if [ "$BUILD_TUNE" != "none" ]; then
	export CFLAGS="$CFLAGS -mtune=$BUILD_TUNE"
	export CXXFLAGS="$CXXFLAGS -mtune=$BUILD_TUNE"
	export CPPFLAGS="$CPPFLAGS -mtune=$BUILD_TUNE"
fi
if [ "$BUILD_OPT_LEVEL" != "none" ]; then
	export CFLAGS="$CFLAGS -O$BUILD_OPT_LEVEL"
	export CXXFLAGS="$CXXFLAGS -O$BUILD_OPT_LEVEL"
	export CPPFLAGS="$CPPFLAGS -O$BUILD_OPT_LEVEL"
fi

sed -i '/LIBTOOL_INSTALL/d' c++/Makefile.in
./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            --with-shared           \
            --without-debug         \
            --without-normal        \
            --enable-pc-files       \
            --enable-widec
make
make install
mv -v /usr/lib/libncursesw.so.6* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libncursesw.so) /usr/lib/libncursesw.so
for lib in ncurses form panel menu ; do
    rm -vf                    /usr/lib/lib${lib}.so
    echo "INPUT(-l${lib}w)" > /usr/lib/lib${lib}.so
    ln -sfv ${lib}w.pc        /usr/lib/pkgconfig/${lib}.pc
done
rm -vf                     /usr/lib/libcursesw.so
echo "INPUT(-lncursesw)" > /usr/lib/libcursesw.so
ln -sfv libncurses.so      /usr/lib/libcurses.so
mkdir -v       /usr/share/doc/ncurses-6.1
cp -v -R doc/* /usr/share/doc/ncurses-6.1
make distclean
./configure --prefix=/usr    \
            --with-shared    \
            --without-normal \
            --without-debug  \
            --without-cxx-binding \
            --with-abi-version=5 
make sources libs
cp -av lib/lib*.so.5* /usr/lib


cd $SOURCE_DIR
if [ "$TARBALL" != "" ]
then
	rm -rf $DIRECTORY
	rm -rf {gcc,glibc,binutils}-build
fi

echo "$STEPNAME" | tee -a $LOGFILE

fi