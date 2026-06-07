#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:cmake
#REQ:imlib2

cd $SOURCE_DIR
NAME=icewm
VERSION=4.0.0
URL=https://github.com/ice-wm/icewm/archive/4.0.0/icewm-4.0.0.tar.gz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://github.com/ice-wm/icewm/archive/4.0.0/icewm-4.0.0.tar.gz


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

mkdir build
cd    build
cmake -D CMAKE_INSTALL_PREFIX=/usr \
      -D CMAKE_BUILD_TYPE=Release  \
      -D CFGDIR=/etc               \
      -D ENABLE_LTO=ON             \
      -D DOCDIR=/usr/share/doc/icewm-4.0.0  \
      ..
make
echo icewm-session > ~/.xinitrc
mkdir -pv ~/.icewm
cp -v /usr/share/icewm/keys ~/.icewm/keys
cp -v /usr/share/icewm/menu ~/.icewm/menu
cp -v /usr/share/icewm/preferences ~/.icewm/preferences
cp -v /usr/share/icewm/toolbar ~/.icewm/toolbar
cp -v /usr/share/icewm/winoptions ~/.icewm/winoptions
icewm-menu-fdo >~/.icewm/menu
cat > ~/.icewm/startup << "EOF"
rox -p Default &
EOF
chmod +x ~/.icewm/startup
rm -v /usr/share/xsessions/icewm.desktop


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd