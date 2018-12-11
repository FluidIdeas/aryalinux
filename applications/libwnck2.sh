#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The libwnck package contains abr3ak Window Navigator Construction Kit.br3ak"
SECTION="xfce"
VERSION=2.30.7
NAME="libwnck2"

#REQ:gtk2
#REC:startup-notification
#OPT:gobject-introspection
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/libwnck/2.30/libwnck-2.30.7.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/libwnck/2.30/libwnck-2.30.7.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libwnck/libwnck-2.30.7.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libwnck/libwnck-2.30.7.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libwnck/libwnck-2.30.7.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libwnck/libwnck-2.30.7.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libwnck/libwnck-2.30.7.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libwnck/libwnck-2.30.7.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libwnck/2.30/libwnck-2.30.7.tar.xz

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

./configure --prefix=/usr \
            --disable-static \
            --program-suffix=-1 &&
make GETTEXT_PACKAGE=libwnck-1



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make GETTEXT_PACKAGE=libwnck-1 install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
