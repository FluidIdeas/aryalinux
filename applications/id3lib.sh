#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak id3lib is a library for reading,br3ak writing and manipulating id3v1 and id3v2 multimedia databr3ak containers.br3ak"
SECTION="multimedia"
VERSION=3.8.3
NAME="id3lib"



cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/id3lib/id3lib-3.8.3.tar.gz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/id3lib/id3lib-3.8.3.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/id3lib/id3lib-3.8.3.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/id3lib/id3lib-3.8.3.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/id3lib/id3lib-3.8.3.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/id3lib/id3lib-3.8.3.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/id3lib/id3lib-3.8.3.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/id3lib/id3lib-3.8.3.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/id3lib-3.8.3-consolidated_patches-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/id3lib/id3lib-3.8.3-consolidated_patches-1.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

patch -Np1 -i ../id3lib-3.8.3-consolidated_patches-1.patch &&
libtoolize -fc                &&
aclocal                       &&
autoconf                      &&
automake --add-missing --copy &&
./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install  &&
cp doc/man/* /usr/share/man/man1 &&
install -v -m755 -d /usr/share/doc/id3lib-3.8.3 &&
install -v -m644 doc/*.{gif,jpg,png,ico,css,txt,php,html} \
                    /usr/share/doc/id3lib-3.8.3

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
