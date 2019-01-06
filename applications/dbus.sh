#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:systemd
#REC:x7lib
#OPT:dbus-glib
#OPT:dbus-python
#OPT:pygobject3
#OPT:valgrind
#OPT:doxygen
#OPT:xmlto

cd $SOURCE_DIR

wget -nc https://dbus.freedesktop.org/releases/dbus/dbus-1.12.12.tar.gz

NAME=dbus
VERSION=1.12.12
URL=https://dbus.freedesktop.org/releases/dbus/dbus-1.12.12.tar.gz

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
--localstatedir=/var \
--enable-user-session \
--disable-doxygen-docs \
--disable-xml-docs \
--disable-static \
--docdir=/usr/share/doc/dbus-1.12.12 \
--with-console-auth-dir=/run/console \
--with-system-pid-file=/run/dbus/pid \
--with-system-socket=/run/dbus/system_bus_socket &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
systemctl start rescue.target
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
mv -v /usr/lib/libdbus-1.so.* /lib &&
ln -sfv ../../lib/$(readlink /usr/lib/libdbus-1.so) /usr/lib/libdbus-1.so
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
chown -v root:messagebus /usr/libexec/dbus-daemon-launch-helper &&
chmod -v 4750 /usr/libexec/dbus-daemon-launch-helper
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
systemctl daemon-reload
systemctl start multi-user.target
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

make distclean &&
./configure --enable-tests \
--enable-asserts \
--disable-doxygen-docs \
--disable-xml-docs &&
make &&
make check

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cat > /etc/dbus-1/session-local.conf << "EOF"
<code class="literal"><!DOCTYPE busconfig PUBLIC
"-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN"
"http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
<busconfig>

<!-- Search for .service files in /usr/local -->
<servicedir>/usr/local/share/dbus-1/services</servicedir>

</busconfig></code>
EOF
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

<code class="literal"># Start the D-Bus session daemon
eval `dbus-launch`
export DBUS_SESSION_BUS_ADDRESS</code>
<code class="literal"># Kill the D-Bus session daemon
kill $DBUS_SESSION_BUS_PID</code>

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
