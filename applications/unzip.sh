#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The UnZip package containsbr3ak <code class=\"filename\">ZIP extraction utilities. These arebr3ak useful for extracting files from <code class=\"filename\">ZIPbr3ak archives. <code class=\"filename\">ZIP archives are createdbr3ak with PKZIP or Info-ZIP utilities, primarily in a DOSbr3ak environment.br3ak"
SECTION="general"
VERSION=60
NAME="unzip"



cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/infozip/unzip60.tar.gz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/infozip/unzip60.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/unzip/unzip60.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/unzip/unzip60.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/unzip/unzip60.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/unzip/unzip60.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/unzip/unzip60.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/unzip/unzip60.tar.gz
wget -nc ftp://ftp.info-zip.org/pub/infozip/src/unzip60.tgz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/unzip/unzip60.tgz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/unzip/unzip60.tgz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/unzip/unzip60.tgz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/unzip/unzip60.tgz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/unzip/unzip60.tgz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/unzip/unzip60.tgz

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

make -f unix/Makefile generic



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make prefix=/usr MANDIR=/usr/share/man/man1 \
 -f unix/Makefile install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
