#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:gst10-plugins-base
#REC:cairo
#REC:flac
#REC:lame
#REC:mpg123
#REC:mesa
#REC:gdk-pixbuf
#REC:libgudev
#REC:libjpeg
#REC:libsoup
#REC:libvpx
#REC:x7lib
#OPT:aalib
#OPT:alsa-oss
#OPT:gtk3
#OPT:gtk-doc
#OPT:libdv
#OPT:libgudev
#OPT:pulseaudio
#OPT:speex
#OPT:valgrind
#OPT:v4l-utils

cd $SOURCE_DIR

wget -nc https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.14.4.tar.xz

NAME=gst10-plugins-good
VERSION=1.14.4
URL=https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.14.4.tar.xz

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
--with-package-name="GStreamer Good Plugins 1.14.4 BLFS" \
--with-package-origin="http://www.linuxfromscratch.org/blfs/view/svn/" &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
