#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:curl
#REQ:libevent
#REC:gtk3
#REC:qt5
#OPT:doxygen
#OPT:gdb

cd $SOURCE_DIR

wget -nc https://raw.githubusercontent.com/transmission/transmission-releases/master/transmission-2.94.tar.xz

NAME=transmission
VERSION=2.94
URL=https://raw.githubusercontent.com/transmission/transmission-releases/master/transmission-2.94.tar.xz

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

./configure --prefix=/usr &&
make
pushd qt        &&
  qmake qtr.pro &&
  make          &&
popd

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make INSTALL_ROOT=/usr -C qt install &&

install -m644 qt/transmission-qt.desktop /usr/share/applications/transmission-qt.desktop &&
install -m644 qt/icons/transmission.png  /usr/share/pixmaps/transmission-qt.png
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
