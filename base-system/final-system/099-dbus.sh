#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=099-dbus

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=dbus-1.14.0.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr                        \
            --sysconfdir=/etc                    \
            --localstatedir=/var                 \
            --runstatedir=/run                   \
            --disable-static                     \
            --disable-doxygen-docs               \
            --disable-xml-docs                   \
            --docdir=/usr/share/doc/dbus-1.14.0 \
            --with-system-socket=/run/dbus/system_bus_socket
make
make install
ln -sfv /etc/machine-id /var/lib/dbus

fi

cleanup $DIRECTORY
log $NAME