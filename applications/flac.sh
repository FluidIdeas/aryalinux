#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

wget -nc https://downloads.xiph.org/releases/flac/flac-1.3.3.tar.xz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/4.0/flac-1.3.3-security_fixes-1.patch


NAME=flac
VERSION=1.3.3
URL=https://downloads.xiph.org/releases/flac/flac-1.3.3.tar.xz
SECTION="Multimedia Libraries and Drivers"
DESCRIPTION="FLAC is an audio CODEC similar to MP3, but lossless, meaning that audio is compressed without losing any information."

mkdir -pv $NAME
pushd $NAME

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

echo $USER > /tmp/currentuser


patch -Np1 -i ../flac-1.3.3-security_fixes-1.patch      &&
./configure --prefix=/usr                                \
            --disable-thorough-tests                     \
            --docdir=/usr/share/doc/flac-1.3.3          &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd