#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gtk2
#REQ:libgcrypt
#REQ:gstreamer10
#REQ:gnutls
#REQ:nss


cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/pidgin/pidgin-2.14.3.tar.bz2


NAME=pidgin
VERSION=2.14.3
URL=https://downloads.sourceforge.net/pidgin/pidgin-2.14.3.tar.bz2
SECTION="Other X-based Programs"
DESCRIPTION="Pidgin is a Gtk+ 2 instant messaging client that can connect with a wide range of networks including Bonjour, ICQ, GroupWise, Jabber/XMPP, IRC, Gadu-Gadu, SILC, SIMPLE, and Zephyr."

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

echo $USER > /tmp/currentuser


sed -i '/srunner_add_suite(sr, oscar_util_suite());/d' libpurple/tests/check_libpurple.c
./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --disable-gstreamer  \
            --disable-avahi      \
            --disable-gtkspell   \
            --disable-meanwhile  \
            --disable-idn        \
            --disable-nm         \
            --disable-vv         &&
make
make docs
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
mkdir -pv /usr/share/doc/pidgin-2.14.3 &&
cp -v README doc/gtkrc-2.0 /usr/share/doc/pidgin-2.14.3
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
mkdir -pv /usr/share/doc/pidgin-2.14.3/api &&
cp -v doc/html/* /usr/share/doc/pidgin-2.14.3/api
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

gtk-update-icon-cache -qtf /usr/share/icons/hicolor &&
update-desktop-database -q


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

