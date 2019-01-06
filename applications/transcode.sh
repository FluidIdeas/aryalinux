#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:ffmpeg
#REC:alsa-lib
#REC:lame
#REC:libdvdread
#REC:libmpeg2
#REC:x7lib
#OPT:faac
#OPT:freetype2
#OPT:imagemagick6
#OPT:liba52
#OPT:libdv
#OPT:libjpeg
#OPT:libogg
#OPT:libquicktime
#OPT:libtheora
#OPT:libvorbis
#OPT:libxml2
#OPT:lzo
#OPT:sdl
#OPT:v4l-utils
#OPT:x264
#OPT:xvid

cd $SOURCE_DIR

wget -nc https://sources.archlinux.org/other/community/transcode/transcode-1.1.7.tar.bz2
wget -nc ftp://ftp.mirrorservice.org/sites/distfiles.gentoo.org/distfiles/transcode-1.1.7.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/transcode-1.1.7-ffmpeg4-1.patch

NAME=transcode
VERSION=1.1.7.
URL=https://sources.archlinux.org/other/community/transcode/transcode-1.1.7.tar.bz2

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

sed -i 's|doc/transcode|&-$(PACKAGE_VERSION)|' \
       $(find . -name Makefile.in -exec grep -l 'docsdir =' {} \;) &&

patch -Np1 -i ../transcode-1.1.7-ffmpeg4-1.patch                   &&
./configure --prefix=/usr \
            --enable-alsa \
            --enable-libmpeg2 &&
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
