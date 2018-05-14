#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The DConf package contains abr3ak low-level configuration system. Its main purpose is to provide abr3ak backend to GSettings on platforms that don't already havebr3ak configuration storage systems.br3ak"
SECTION="gnome"
VERSION=0.28.0
NAME="dconf"

#REQ:dbus
#REQ:glib2
#REQ:gtk3
#REQ:libxml2
#REC:libxslt
#REC:vala
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/dconf/0.28/dconf-0.28.0.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/dconf/0.28/dconf-0.28.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/dconf/dconf-0.28.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/dconf/dconf-0.28.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/dconf/dconf-0.28.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/dconf/dconf-0.28.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/dconf/dconf-0.28.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/dconf/dconf-0.28.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/dconf/0.28/dconf-0.28.0.tar.xz
wget -nc http://ftp.gnome.org/pub/gnome/sources/dconf-editor/3.28/dconf-editor-3.28.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/dconf/dconf-editor-3.28.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/dconf/dconf-editor-3.28.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/dconf/dconf-editor-3.28.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/dconf/dconf-editor-3.28.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/dconf/dconf-editor-3.28.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/dconf/dconf-editor-3.28.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/dconf-editor/3.28/dconf-editor-3.28.0.tar.xz

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
meson --prefix=/usr --sysconfdir=/etc &&
ninja



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ninja install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


tar -xf ../dconf-editor-3.28.0.tar.xz &&
cd dconf-editor-3.28.0 &&
mkdir build &&
cd    build &&
meson --prefix=/usr --sysconfdir=/etc &&
ninja



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ninja install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
