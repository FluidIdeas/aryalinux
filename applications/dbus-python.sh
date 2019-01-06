#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:dbus
#REQ:glib2
#OPT:python2

cd $SOURCE_DIR

wget -nc https://dbus.freedesktop.org/releases/dbus-python/dbus-python-1.2.8.tar.gz

NAME=d-bus python-1.2.8
VERSION=1.2.8
URL=https://dbus.freedesktop.org/releases/dbus-python/dbus-python-1.2.8.tar.gz

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

mkdir python2 &&
pushd python2 &&
PYTHON=/usr/bin/python     \
../configure --prefix=/usr --docdir=/usr/share/doc/dbus-python-1.2.8 &&
make &&
popd
mkdir python3 &&
pushd python3 &&
PYTHON=/usr/bin/python3    \
../configure --prefix=/usr --docdir=/usr/share/doc/dbus-python-1.2.8 &&
make &&
popd

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make -C python2 install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make -C python3 install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
