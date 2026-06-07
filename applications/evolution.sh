#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:adwaita-icon-theme
#REQ:evolution-data-server
#REQ:gcr4
#REQ:webkitgtk
#REQ:bogofilter
#REQ:highlight
#REQ:libcanberra
#REQ:libnotify

cd $SOURCE_DIR
NAME=evolution
VERSION=3.58.3
URL=https://download.gnome.org/sources/evolution/3.58/evolution-3.58.3.tar.xz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/evolution/3.58/evolution-3.58.3.tar.xz


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
      -D SYSCONF_INSTALL_DIR=/etc  \
      -D ENABLE_INSTALLED_TESTS=ON \
      -D ENABLE_PST_IMPORT=OFF     \
      -D ENABLE_YTNEF=OFF          \
      -D ENABLE_CONTACT_MAPS=OFF   \
      -D ENABLE_MARKDOWN=OFF       \
      -D ENABLE_WEATHER=ON         \
      -G Ninja ..
ninja


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd