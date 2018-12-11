#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Gparted is the Gnome Partition Editor, a Gtk 2 GUI for otherbr3ak command line tools that can create, reorganise or delete diskbr3ak partitions.br3ak"
SECTION="xsoft"
VERSION=0.32.0
NAME="gparted"

#REQ:gtkmm2
#REQ:parted
#OPT:btrfs-progs
#OPT:rarian


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/gparted/gparted-0.32.0.tar.gz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/gparted/gparted-0.32.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gparted/gparted-0.32.0.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gparted/gparted-0.32.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gparted/gparted-0.32.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gparted/gparted-0.32.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gparted/gparted-0.32.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gparted/gparted-0.32.0.tar.gz

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

./configure --prefix=/usr    \
            --disable-doc    \
            --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cp -v /usr/share/applications/gparted.desktop /usr/share/applications/gparted.desktop.back &&
sed -i 's/Exec=/Exec=sudo -A /'               /usr/share/applications/gparted.desktop

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
