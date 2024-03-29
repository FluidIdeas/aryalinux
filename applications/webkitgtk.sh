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
#REQ:gtk3
#REQ:icu
#REQ:lcms2
#REQ:libgudev
#REQ:libsecret
#REQ:libsoup3
#REQ:libtasn1
#REQ:libwebp
#REQ:mesa
#REQ:openjpeg2
#REQ:ruby
#REQ:sqlite
#REQ:which
#REQ:wpebackend-fdo
#REQ:enchant
#REQ:geoclue2
#REQ:gobject-introspection
#REQ:hicolor-icon-theme
#REQ:hyphen
#REQ:libmanette
#REQ:libwpe
#REQ:wpebackend-fdo
#REQ:bubblewrap
#REQ:xdg-dbus-proxy
#REQ:geoclue2
#REQ:gtk-doc
#REQ:woff2
#REQ:libseccomp


cd $SOURCE_DIR

NAME=webkitgtk
VERSION=2.38.5
URL=https://webkitgtk.org/releases/webkitgtk-2.38.5.tar.xz
SECTION="Graphical Environment Libraries"
DESCRIPTION="The WebKitGTK package is a port of the portable web rendering engine WebKit to the GTK+ 3 and GTK 4 platforms."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://webkitgtk.org/releases/webkitgtk-2.38.5.tar.xz


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

cmake -DCMAKE_BUILD_TYPE=Release  \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_SKIP_RPATH=ON       \
      -DPORT=GTK                  \
      -DLIB_INSTALL_DIR=/usr/lib  \
      -DENABLE_MINIBROWSER=ON     \
	  -DENABLE_GLES2=ON           \
	  -DENABLE_QUARTZ_TARGET=ON   \
	  -DUSE_GTK4=OFF              \
      -Wno-dev -G Ninja ..        &&
ninja

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -vdm755 /usr/share/gtk-doc/html/{jsc-glib,webkit2gtk{,-web-extension}}-4.1 &&
install -vm644  ../Documentation/jsc-glib-4.1/*              \
                /usr/share/gtk-doc/html/jsc-glib-4.1         &&
install -vm644  ../Documentation/webkit2gtk-4.1/*            \
                /usr/share/gtk-doc/html/webkit2gtk-4.1       &&
install -vm644  ../Documentation/webkit2gtk-web-extension-4.1/* \
                /usr/share/gtk-doc/html/webkit2gtk-web-extension-4.1
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd