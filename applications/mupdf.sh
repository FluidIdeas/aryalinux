#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:x7lib
#REQ:freeglut
#REQ:harfbuzz
#REQ:libjpeg
#REQ:openjpeg2
#REQ:curl


cd $SOURCE_DIR

wget -nc http://www.mupdf.com/downloads/archive/mupdf-1.16.1-source.tar.gz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/2.1/mupdf-1.16.1-shared_libs-1.patch


NAME=mupdf
VERSION=1.16.
URL=http://www.mupdf.com/downloads/archive/mupdf-1.16.1-source.tar.gz
SECTION="PostScript"
DESCRIPTION="MuPDF is a lightweight PDF and XPS viewer."

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


patch -Np1 -i ../mupdf-1.16.1-shared_libs-1.patch &&

USE_SYSTEM_LIBS=yes make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
USE_SYSTEM_LIBS=yes                     \
make prefix=/usr                        \
     build=release                      \
     docdir=/usr/share/doc/mupdf-1.16.1 \
     install                            &&

ln -sfv mupdf-x11 /usr/bin/mupdf        &&
ldconfig
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

