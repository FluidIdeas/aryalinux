#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gdk-pixbuf


cd $SOURCE_DIR

wget -nc https://github.com/ice-wm/icewm/archive/1.6.1/icewm-1.6.1.tar.gz


NAME=icewm
VERSION=1.6.1
URL=https://github.com/ice-wm/icewm/archive/1.6.1/icewm-1.6.1.tar.gz

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


sed -i "s/nullptr/NULL/" src/{wmconfig.cc,icewmhint.cc} &&

mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release  \
      -DCFGDIR=/etc               \
      -DCMAKE_EXE_LINKER_FLAGS='-lXrandr -lXinerama' \
      -DDOCDIR=/usr/share/doc/icewm-1.6.1  \
      ..
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install         &&
rm /usr/share/xsessions/icewm.desktop
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

echo icewm-session > ~/.xinitrc
mkdir -v ~/.icewm                                       &&
cp -v /usr/share/icewm/keys ~/.icewm/keys               &&
cp -v /usr/share/icewm/menu ~/.icewm/menu               &&
cp -v /usr/share/icewm/preferences ~/.icewm/preferences &&
cp -v /usr/share/icewm/toolbar ~/.icewm/toolbar         &&
cp -v /usr/share/icewm/winoptions ~/.icewm/winoptions
icewm-menu-fdo >~/.icewm/menu
cat > ~/.icewm/startup << "EOF"
rox -p Default &
EOF &&
chmod +x ~/.icewm/startup


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

