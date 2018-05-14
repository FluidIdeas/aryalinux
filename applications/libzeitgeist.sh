#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The libzeitgeist package containsbr3ak a client library used to access and manage the Zeitgeist event logbr3ak from languages such as C and Vala. Zeitgeist is a service whichbr3ak logs the user's activities and events (files opened, websitesbr3ak visited, conversations hold with other people, etc.) and makes thebr3ak relevant information available to other applications.br3ak"
SECTION="general"
VERSION=0.3.18
NAME="libzeitgeist"

#REQ:glib2
#OPT:gtk-doc


cd $SOURCE_DIR

URL=https://launchpad.net/libzeitgeist/0.3/0.3.18/+download/libzeitgeist-0.3.18.tar.gz

if [ ! -z $URL ]
then
wget -nc https://launchpad.net/libzeitgeist/0.3/0.3.18/+download/libzeitgeist-0.3.18.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libzeitgeist/libzeitgeist-0.3.18.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libzeitgeist/libzeitgeist-0.3.18.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libzeitgeist/libzeitgeist-0.3.18.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libzeitgeist/libzeitgeist-0.3.18.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libzeitgeist/libzeitgeist-0.3.18.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libzeitgeist/libzeitgeist-0.3.18.tar.gz

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

sed -i  "s|/doc/libzeitgeist|&-0.3.18|" Makefile.in &&
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
