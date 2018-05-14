#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Colord is a system service thatbr3ak makes it easy to manage, install, and generate color profiles. Itbr3ak is used mainly by GNOME Colorbr3ak Manager for system integration and use when no users arebr3ak logged in.br3ak"
SECTION="general"
VERSION=1.3.5
NAME="colord1"

#REQ:dbus
#REQ:glib2
#REQ:lcms2
#REQ:sqlite
#REC:gobject-introspection
#REC:libgudev
#REC:libgusb
#REC:polkit
#REC:systemd
#REC:vala
#OPT:docbook-utils
#OPT:gnome-desktop
#OPT:colord-gtk
#OPT:gtk-doc
#OPT:libxslt
#OPT:sane


cd $SOURCE_DIR

URL=https://www.freedesktop.org/software/colord/releases/colord-1.3.5.tar.xz

if [ ! -z $URL ]
then
wget -nc https://www.freedesktop.org/software/colord/releases/colord-1.3.5.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/colord/colord-1.3.5.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/colord/colord-1.3.5.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/colord/colord-1.3.5.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/colord/colord-1.3.5.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/colord/colord-1.3.5.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/colord/colord-1.3.5.tar.xz

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


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -g 71 colord &&
useradd -c "Color Daemon Owner" -d /var/lib/colord -u 71 \
        -g colord -s /bin/false colord

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


./configure --prefix=/usr              \
            --sysconfdir=/etc          \
            --localstatedir=/var       \
            --with-daemon-user=colord  \
            --enable-vala              \
            --enable-daemon            \
            --enable-session-helper    \
            --enable-libcolordcompat   \
            --disable-rpath            \
            --disable-argyllcms-sensor \
            --disable-bash-completion  \
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
