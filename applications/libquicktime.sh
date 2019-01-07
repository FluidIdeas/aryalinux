#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#OPT:alsa-lib
#OPT:doxygen
#OPT:faac
#OPT:faad2
#OPT:ffmpeg
#OPT:gtk2
#OPT:lame
#OPT:libjpeg
#OPT:libvorbis
#OPT:x264

cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/libquicktime/libquicktime-1.2.4.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/libquicktime-1.2.4-ffmpeg4-1.patch

NAME=libquicktime
VERSION=1.2.4
URL=https://downloads.sourceforge.net/libquicktime/libquicktime-1.2.4.tar.gz

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

patch -Np1 -i ../libquicktime-1.2.4-ffmpeg4-1.patch &&

./configure --prefix=/usr \
--enable-gpl \
--without-doxygen \
--docdir=/usr/share/doc/libquicktime-1.2.4
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&

install -v -m755 -d /usr/share/doc/libquicktime-1.2.4 &&
install -v -m644 README doc/{*.txt,*.html,mainpage.incl} \
/usr/share/doc/libquicktime-1.2.4
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
