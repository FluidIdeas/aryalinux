#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gst10-plugins-base
#REQ:tracker
#REQ:exempi
#REQ:gexiv2
#REQ:ffmpeg
#REQ:flac
#REQ:giflib
#REQ:icu
#REQ:libexif
#REQ:libgrss
#REQ:libgxps
#REQ:poppler


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/tracker-miners/2.3/tracker-miners-2.3.1.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/tracker-miners/2.3/tracker-miners-2.3.1.tar.xz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/2.0/tracker-miners-2.3.1-upstream_fixes-1.patch


NAME=tracker-miners
VERSION=2.3.1
URL=http://ftp.gnome.org/pub/gnome/sources/tracker-miners/2.3/tracker-miners-2.3.1.tar.xz

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


patch -Np1 -i ../tracker-miners-2.3.1-upstream_fixes-1.patch
mkdir build &&
cd    build &&

meson --prefix=/usr .. &&
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

