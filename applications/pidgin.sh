#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Pidgin is a Gtk+ 2 instantbr3ak messaging client that can connect with a wide range of networksbr3ak including AIM, ICQ, GroupWise, MSN, Jabber, IRC, Napster,br3ak Gadu-Gadu, SILC, Zephyr and Yahoo!br3ak"
SECTION="xsoft"
VERSION=2.13.0
NAME="pidgin"

#REQ:gtk2
#REC:libgcrypt
#REC:gstreamer10
#REC:gnutls
#REC:nss
#OPT:avahi
#OPT:cyrus-sasl
#OPT:dbus
#OPT:GConf
#OPT:libidn
#OPT:networkmanager
#OPT:sqlite
#OPT:startup-notification
#OPT:tcl
#OPT:tk
#OPT:evolution-data-server
#OPT:mitkrb
#OPT:xdg-utils


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/pidgin/pidgin-2.13.0.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/pidgin/pidgin-2.13.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/pidgin/pidgin-2.13.0.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/pidgin/pidgin-2.13.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/pidgin/pidgin-2.13.0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/pidgin/pidgin-2.13.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/pidgin/pidgin-2.13.0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/pidgin/pidgin-2.13.0.tar.bz2

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

./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --with-gstreamer=1.0 \
            --disable-avahi      \
            --disable-gtkspell   \
            --disable-meanwhile  \
            --disable-idn        \
            --disable-nm         \
            --disable-vv         \
            --disable-tcl        &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
mkdir -pv /usr/share/doc/pidgin-2.13.0 &&
cp -v README doc/gtkrc-2.0 /usr/share/doc/pidgin-2.13.0

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
gtk-update-icon-cache &&
update-desktop-database

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
