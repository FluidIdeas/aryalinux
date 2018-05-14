#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak FAAD2 is a decoder for a lossybr3ak sound compression scheme specified in MPEG-2 Part 7 and MPEG-4 Partbr3ak 3 standards and known as Advanced Audio Coding (AAC).br3ak"
SECTION="multimedia"
VERSION=2.8.8
NAME="faad2"



cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/faac/faad2-2.8.8.tar.gz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/faac/faad2-2.8.8.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/faad2/faad2-2.8.8.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/faad2/faad2-2.8.8.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/faad2/faad2-2.8.8.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/faad2/faad2-2.8.8.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/faad2/faad2-2.8.8.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/faad2/faad2-2.8.8.tar.gz

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

./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
