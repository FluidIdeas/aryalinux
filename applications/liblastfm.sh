#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:fftw
#REQ:libsamplerate
#REQ:qt5


cd $SOURCE_DIR
mkdir -pv $NAME
pushd $NAME

wget -nc http://archive.ubuntu.com/ubuntu/pool/universe/libl/liblastfm/liblastfm_1.0.9.orig.tar.gz


NAME=liblastfm
VERSION=1.0.9
URL=http://archive.ubuntu.com/ubuntu/pool/universe/libl/liblastfm/liblastfm_1.0.9.orig.tar.gz
DESCRIPTION="liblastfm is a collection of C++/Qt4 libraries provided by Last.fm for use with their web services."

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

mkdir -pv build
cd build

cmake -DCMAKE_INSTALL_PREFIX=/usr ..
make -j$(nproc)

sudo make install


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd