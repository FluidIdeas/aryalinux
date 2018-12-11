#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Bluefish is a GTK+ text editor targeted towards programmersbr3ak and web designers, with many options to write websites, scripts andbr3ak programming code. Bluefishbr3ak supports many programming and markup languages, and it focuses onbr3ak editing dynamic and interactive websites.br3ak"
SECTION="postlfs"
VERSION=2.2.10
NAME="bluefish"

#REQ:gtk2
#REQ:gtk3
#REC:desktop-file-utils
#OPT:enchant
#OPT:gucharmap
#OPT:pcre


cd $SOURCE_DIR

URL=http://www.bennewitz.com/bluefish/stable/source/bluefish-2.2.10.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://www.bennewitz.com/bluefish/stable/source/bluefish-2.2.10.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/bluefish/bluefish-2.2.10.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/bluefish/bluefish-2.2.10.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/bluefish/bluefish-2.2.10.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/bluefish/bluefish-2.2.10.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/bluefish/bluefish-2.2.10.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/bluefish/bluefish-2.2.10.tar.bz2

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

./configure --prefix=/usr --docdir=/usr/share/doc/bluefish-2.2.10 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
gtk-update-icon-cache -t -f --include-image-data /usr/share/icons/hicolor &&
update-desktop-database

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
