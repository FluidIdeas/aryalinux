#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The libchamplain is a Clutterbr3ak based widget used to display rich, eye-candy and interactive maps.br3ak"
SECTION="gnome"
VERSION=0.12.16
NAME="libchamplain"

#REQ:clutter
#REQ:clutter-gtk
#REQ:gtk3
#REQ:libsoup
#REC:gobject-introspection
#REC:vala
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/libchamplain/0.12/libchamplain-0.12.16.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/libchamplain/0.12/libchamplain-0.12.16.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libchamplain/libchamplain-0.12.16.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libchamplain/libchamplain-0.12.16.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libchamplain/libchamplain-0.12.16.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libchamplain/libchamplain-0.12.16.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libchamplain/libchamplain-0.12.16.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libchamplain/libchamplain-0.12.16.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libchamplain/0.12/libchamplain-0.12.16.tar.xz

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
            --enable-vala    \
            --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
