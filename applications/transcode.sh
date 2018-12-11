#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Transcode was a fast, versatilebr3ak and command-line based audio/video everything to everythingbr3ak converter primarily focussed on producing AVI video files with MP3br3ak audio, but also including a program to read all the video and audiobr3ak streams from a DVD.br3ak"
SECTION="multimedia"
VERSION=1.1.7
NAME="transcode"

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

URL=https://bitbucket.org/france/transcode-tcforge/downloads/transcode-1.1.7.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://bitbucket.org/france/transcode-tcforge/downloads/transcode-1.1.7.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/transcode/transcode-1.1.7.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/transcode/transcode-1.1.7.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/transcode/transcode-1.1.7.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/transcode/transcode-1.1.7.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/transcode/transcode-1.1.7.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/transcode/transcode-1.1.7.tar.bz2 || wget -nc ftp://ftp.mirrorservice.org/sites/distfiles.gentoo.org/distfiles/transcode-1.1.7.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/transcode-1.1.7-ffmpeg4-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/transcode/transcode-1.1.7-ffmpeg4-1.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

sed -i 's|doc/transcode|&-$(PACKAGE_VERSION)|' \
       $(find . -name Makefile.in -exec grep -l 'docsdir =' {} \;) &&
patch -Np1 -i ../transcode-1.1.7-ffmpeg4-1.patch                   &&
./configure --prefix=/usr \
            --enable-alsa \
            --enable-libmpeg2 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
