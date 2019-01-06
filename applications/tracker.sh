#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:json-glib
#REQ:libseccomp
#REQ:libsoup
#REQ:python2
#REQ:vala
#REC:gobject-introspection
#REC:icu
#REC:networkmanager
#REC:upower
#OPT:gtk-doc

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/tracker/2.1/tracker-2.1.6.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/tracker/2.1/tracker-2.1.6.tar.xz

NAME=tracker
VERSION=2.1.6
URL=http://ftp.gnome.org/pub/gnome/sources/tracker/2.1/tracker-2.1.6.tar.xz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

./configure --prefix=/usr \
--sysconfdir=/etc \
--with-session-bus-services-dir=/usr/share/dbus-1/services &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
