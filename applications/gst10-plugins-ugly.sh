#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:gst10-plugins-base
#REC:liba52
#REC:libdvdread
#REC:x264
#OPT:gtk-doc
#OPT:libmpeg2
#OPT:libcdio
#OPT:valgrind

cd $SOURCE_DIR

wget -nc https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-1.14.4.tar.xz

NAME=gst10-plugins-ugly
VERSION=1.14.4
URL=https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-1.14.4.tar.xz

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

./configure --prefix=/usr \
            --with-package-name="GStreamer Ugly Plugins 1.14.4 BLFS" \
            --with-package-origin="http://www.linuxfromscratch.org/blfs/view/svn/" &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
