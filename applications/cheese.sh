#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:clutter-gst
#REQ:clutter-gtk
#REQ:gnome-desktop
#REQ:gst10-plugins-bad
#REQ:gst10-plugins-good
#REQ:v4l-utils
#REQ:libcanberra
#REQ:libgudev
#REQ:gnome-video-effects
#REQ:gobject-introspection
#REQ:vala


cd $SOURCE_DIR

wget -nc https://download.gnome.org/sources/cheese/3.38/cheese-3.38.0.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/cheese/3.38/cheese-3.38.0.tar.xz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/4.0/cheese-3.38.0-upstream_fixes-1.patch


NAME=cheese
VERSION=3.38.0
URL=https://download.gnome.org/sources/cheese/3.38/cheese-3.38.0.tar.xz
SECTION="GNOME Applications"
DESCRIPTION="Cheese is used to take photos and videos with fun graphical effects."

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	if [ $NAME == "firefox" ]; then set +e; fi;
	tar --no-overwrite-dir -xf $TARBALL
	set -e
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

echo $USER > /tmp/currentuser


sed -i "s/&version;/3.38.0/" docs/reference/cheese{,-docs}.xml
patch -Np1 -i ../cheese-3.38.0-upstream_fixes-1.patch
mkdir build &&
cd    build &&

meson --prefix=/usr -Dgtk_doc=false .. &&
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

