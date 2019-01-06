#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REC:at-spi2-core

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/pyatspi/2.30/pyatspi-2.30.0.tar.xz

NAME=pyatspi2-2.30.0
VERSION=2.30.0
URL=http://ftp.gnome.org/pub/gnome/sources/pyatspi/2.30/pyatspi-2.30.0.tar.xz

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
../configure --prefix=/usr --with-python=/usr/bin/python &&
popd
mkdir python3 &&
pushd python3 &&
../configure --prefix=/usr --with-python=/usr/bin/python3 &&
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
