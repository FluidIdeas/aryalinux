#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:gdk-pixbuf
#REQ:iso-codes
#REQ:librsvg
#REQ:pango
#REQ:python-modules#pygobject3
#REQ:adwaita-icon-theme
#REQ:glslc
#REQ:gst10-plugins-good
#REQ:libvpx
#REQ:glib2

cd $SOURCE_DIR
NAME=gtk4
VERSION=4.20.3
URL=https://download.gnome.org/sources/gtk/4.20/gtk-4.20.3.tar.xz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/gtk/4.20/gtk-4.20.3.tar.xz


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
meson setup --prefix=/usr            \
            --buildtype=release      \
            -D broadway-backend=true \
            -D introspection=enabled \
            -D vulkan=enabled        \
            ..
ninja
sed "s@'doc'@& / 'gtk-4.20.3'@" -i ../docs/reference/meson.build
meson configure -D documentation=true
ninja
env -u{GALLIUM_DRIVER,MESA_LOADER_DRIVER_OVERRIDE}          \
    LIBGL_ALWAYS_SOFTWARE=1 VK_LOADER_DRIVERS_SELECT='lvp*' \
    dbus-run-session meson test --setup x11                 \
                                --no-suite=headless
mkdir -pv ~/.config/gtk-4.0
cat > ~/.config/gtk-4.0/settings.ini << "EOF"
[Settings]
gtk-theme-name = Adwaita
gtk-icon-theme-name = oxygen
gtk-font-name = DejaVu Sans 12
gtk-cursor-theme-size = 18
gtk-xft-antialias = 1
gtk-xft-hinting = 1
gtk-xft-hintstyle = hintslight
gtk-xft-rgba = rgb
gtk-cursor-theme-name = Adwaita
EOF


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