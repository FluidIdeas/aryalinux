#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:libvorbis


cd $SOURCE_DIR

wget -nc https://downloads.xiph.org/releases/vorbis/vorbis-tools-1.4.0.tar.gz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/2.4/vorbis-tools-1.4.0-security_fix-1.patch


NAME=vorbistools
VERSION=1.4.0
URL=https://downloads.xiph.org/releases/vorbis/vorbis-tools-1.4.0.tar.gz
SECTION="Audio Utilities"
DESCRIPTION="The Vorbis Tools package contains command-line tools useful for encoding, playing or editing files using the Ogg CODEC."

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


patch -Np1 -i ../vorbis-tools-1.4.0-security_fix-1.patch
./configure --prefix=/usr \
            --enable-vcut \
            --without-curl &&
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

