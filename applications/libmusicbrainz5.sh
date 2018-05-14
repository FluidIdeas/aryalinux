#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The libmusicbrainz packagebr3ak contains a library which allows you to access the data held on thebr3ak MusicBrainz server.br3ak"
SECTION="multimedia"
VERSION=5.1.0
NAME="libmusicbrainz5"

#REQ:cmake
#REQ:libxml2
#REQ:neon
#OPT:doxygen


cd $SOURCE_DIR

URL=https://github.com/metabrainz/libmusicbrainz/releases/download/release-5.1.0/libmusicbrainz-5.1.0.tar.gz

if [ ! -z $URL ]
then
wget -nc https://github.com/metabrainz/libmusicbrainz/releases/download/release-5.1.0/libmusicbrainz-5.1.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libmusicbrainz/libmusicbrainz-5.1.0.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libmusicbrainz/libmusicbrainz-5.1.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libmusicbrainz/libmusicbrainz-5.1.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libmusicbrainz/libmusicbrainz-5.1.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libmusicbrainz/libmusicbrainz-5.1.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libmusicbrainz/libmusicbrainz-5.1.0.tar.gz

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

mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr .. &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
