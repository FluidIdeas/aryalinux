#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:dbus
#REQ:glib2
#REQ:libusb
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
#OPT:libbluray

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gvfs/1.36/gvfs-1.36.2.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gvfs/1.36/gvfs-1.36.2.tar.xz

URL=http://ftp.gnome.org/pub/gnome/sources/gvfs/1.36/gvfs-1.36.2.tar.xz

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

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
ninja install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
glib-compile-schemas /usr/share/glib-2.0/schemas
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
