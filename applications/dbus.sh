#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Even though D-Bus was built inbr3ak LFS, there are some features provided by the package that otherbr3ak BLFS packages need, but their dependencies didn't fit into LFS.br3ak"
SECTION="general"
VERSION=1.12.10
NAME="dbus"

#REQ:systemd
#REC:x7lib
#OPT:dbus-glib
#OPT:python-modules#dbus-python
#OPT:python-modules#pygobject3
#OPT:valgrind
#OPT:doxygen
#OPT:xmlto


cd $SOURCE_DIR

URL=https://dbus.freedesktop.org/releases/dbus/dbus-1.12.10.tar.gz

if [ ! -z $URL ]
then
wget -nc https://dbus.freedesktop.org/releases/dbus/dbus-1.12.10.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/db/dbus-1.12.10.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/db/dbus-1.12.10.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/db/dbus-1.12.10.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/db/dbus-1.12.10.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/db/dbus-1.12.10.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/db/dbus-1.12.10.tar.gz
wget -nc https://dbus.freedesktop.org/releases/dbus/dbus-1.12.8.tar.gz

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

./configure --prefix=/usr                        \
            --sysconfdir=/etc                    \
            --localstatedir=/var                 \
            --enable-user-session                \
            --disable-doxygen-docs               \
            --disable-xml-docs                   \
            --disable-static                     \
            --docdir=/usr/share/doc/dbus-1.12.10 \
            --with-console-auth-dir=/run/console \
            --with-system-pid-file=/run/dbus/pid \
            --with-system-socket=/run/dbus/system_bus_socket &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mv -v /usr/lib/libdbus-1.so.* /lib &&
ln -sfv ../../lib/$(readlink /usr/lib/libdbus-1.so) /usr/lib/libdbus-1.so

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
chown -v root:messagebus /usr/libexec/dbus-daemon-launch-helper &&
chmod -v      4750       /usr/libexec/dbus-daemon-launch-helper

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/dbus-1/session-local.conf << "EOF"
<!DOCTYPE busconfig PUBLIC
 "-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN"
 "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
<busconfig>
 <!-- Search for .service files in /usr/local -->
 <servicedir>/usr/local/share/dbus-1/services</servicedir>
</busconfig>
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
