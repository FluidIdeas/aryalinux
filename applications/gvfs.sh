#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Gvfs package is a userspacebr3ak virtual filesystem designed to work with the I/O abstractions ofbr3ak GLib's GIO library.br3ak"
SECTION="gnome"
VERSION=1.36.2
NAME="gvfs"

#REQ:dbus
#REQ:glib2
#REQ:libsecret
#REQ:libsoup
#REC:gcr
#REC:gtk3
#REC:libcdio
#REC:libgdata
#REC:libgudev
#REC:systemd
#REC:udisks2
#OPT:apache
#OPT:avahi
#OPT:bluez
#OPT:dbus-glib
#OPT:fuse2
#OPT:gnome-online-accounts
#OPT:gtk-doc
#OPT:libarchive
#OPT:libgcrypt
#OPT:libxml2
#OPT:libxslt
#OPT:openssh
#OPT:samba


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gvfs/1.36/gvfs-1.36.2.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/gvfs/1.36/gvfs-1.36.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gvfs/gvfs-1.36.2.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gvfs/gvfs-1.36.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gvfs/gvfs-1.36.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gvfs/gvfs-1.36.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gvfs/gvfs-1.36.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gvfs/gvfs-1.36.2.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gvfs/1.36/gvfs-1.36.2.tar.xz

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
meson --prefix=/usr     \
      --sysconfdir=/etc \
      -Dfuse=false      \
      -Dgphoto2=false   \
      -Dafc=false       \
      -Dbluray=false    \
      -Dnfs=false       \
      -Dmtp=false       \
      -Dsmb=false       \
      -Ddnssd=false     \
      -Dgoa=false       \
      -Dgoogle=false    .. &&
ninja



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ninja install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
glib-compile-schemas /usr/share/glib-2.0/schemas

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
