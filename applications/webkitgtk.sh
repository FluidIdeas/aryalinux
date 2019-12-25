#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:cairo
#REQ:cmake
#REQ:gst10-plugins-base
#REQ:gst10-plugins-bad
#REQ:gtk2
#REQ:gtk3
#REQ:icu
#REQ:libgudev
#REQ:libsecret
#REQ:libsoup
#REQ:libwebp
#REQ:mesa
#REQ:openjpeg2
#REQ:ruby
#REQ:sqlite
#REQ:which
#REQ:enchant
#REQ:geoclue2
#REQ:gobject-introspection
#REQ:hicolor-icon-theme
#REQ:libnotify


cd $SOURCE_DIR

wget -nc https://webkitgtk.org/releases/webkitgtk-2.24.4.tar.xz


NAME=webkitgtk
VERSION=2.24.4
URL=https://webkitgtk.org/releases/webkitgtk-2.24.4.tar.xz

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


mkdir -vp build &&
cd        build &&

CFLAGS=-Wno-expansion-to-defined  \
CXXFLAGS=-Wno-expansion-to-defined \
cmake -DCMAKE_BUILD_TYPE=Release  \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_SKIP_RPATH=ON       \
      -DPORT=GTK                  \
      -DLIB_INSTALL_DIR=/usr/lib  \
      -DUSE_LIBHYPHEN=OFF         \
      -DENABLE_MINIBROWSER=ON     \
      -DUSE_WOFF2=OFF             \
      -Wno-dev -G Ninja .. &&
ninja
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install &&

install -vdm755 /usr/share/gtk-doc/html/webkit{2,dom}gtk-4.0 &&
install -vm644  ../Documentation/webkit2gtk-4.0/html/*   \
                /usr/share/gtk-doc/html/webkit2gtk-4.0       &&
install -vm644  ../Documentation/webkitdomgtk-4.0/html/* \
                /usr/share/gtk-doc/html/webkitdomgtk-4.0
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

