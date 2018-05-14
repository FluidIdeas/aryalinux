#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Brasero is an application used tobr3ak burn CD/DVD on the GNOME Desktop.br3ak It is designed to be as simple as possible and has some uniquebr3ak features that enable users to create their discs easily andbr3ak quickly.br3ak"
SECTION="gnome"
VERSION=3.12.2
NAME="brasero"

#REQ:gst10-plugins-base
#REQ:itstool
#REQ:libcanberra
#REQ:libnotify
#REC:gobject-introspection
#REC:libburn
#REC:libisofs
#REC:nautilus
#REC:totem-pl-parser
#REC:dvd-rw-tools
#REC:gvfs
#OPT:gtk-doc
#OPT:tracker
#OPT:cdrdao
#OPT:libdvdcss
#OPT:cdrtools


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/brasero/3.12/brasero-3.12.2.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/brasero/3.12/brasero-3.12.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/brasero/brasero-3.12.2.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/brasero/brasero-3.12.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/brasero/brasero-3.12.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/brasero/brasero-3.12.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/brasero/brasero-3.12.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/brasero/brasero-3.12.2.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/brasero/3.12/brasero-3.12.2.tar.xz

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

./configure --prefix=/usr                \
            --enable-compile-warnings=no \
            --enable-cxx-warnings=no     &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
