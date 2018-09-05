#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The GLib Networking packagebr3ak contains Network related gio modules for GLib.br3ak"
SECTION="basicnet"
VERSION=2.56.1
NAME="glib-networking"

#REQ:glib2
#REQ:gnutls
#REQ:gsettings-desktop-schemas
#REC:make-ca
#REC:p11-kit


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/glib-networking/2.56/glib-networking-2.56.1.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/glib-networking/2.56/glib-networking-2.56.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/glib-networking/glib-networking-2.56.1.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/glib-networking/glib-networking-2.56.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/glib-networking/glib-networking-2.56.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/glib-networking/glib-networking-2.56.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/glib-networking/glib-networking-2.56.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/glib-networking/glib-networking-2.56.1.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/glib-networking/2.56/glib-networking-2.56.1.tar.xz

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
meson --prefix=/usr            \
      -Dlibproxy_support=false \
      -Dca_certificates_path=/etc/ssl/ca-bundle.crt &&
ninja



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ninja install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/profile.d/gio.sh << "EOF"
# Begin gio.sh
export GIO_USE_TLS=gnutls-pkcs11
# End gio.sh
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
