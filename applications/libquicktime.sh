#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The libquicktime package containsbr3ak the <code class=\"filename\">libquicktime library, variousbr3ak plugins and codecs, along with graphical and command line utilitiesbr3ak used for encoding and decoding QuickTime files. This is useful forbr3ak reading and writing files in the QuickTime format. The goal of thebr3ak project is to enhance, while providing compatibility with thebr3ak Quicktime 4 Linux library.br3ak"
SECTION="multimedia"
VERSION=1.2.4
NAME="libquicktime"

#OPT:alsa-lib
#OPT:doxygen
#OPT:faac
#OPT:faad2
#OPT:ffmpeg
#OPT:gtk2
#OPT:lame
#OPT:libdv
#OPT:libjpeg
#OPT:libpng
#OPT:libvorbis
#OPT:x264
#OPT:x7lib


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/libquicktime/libquicktime-1.2.4.tar.gz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/libquicktime/libquicktime-1.2.4.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libquicktime/libquicktime-1.2.4.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libquicktime/libquicktime-1.2.4.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libquicktime/libquicktime-1.2.4.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libquicktime/libquicktime-1.2.4.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libquicktime/libquicktime-1.2.4.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libquicktime/libquicktime-1.2.4.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/libquicktime-1.2.4-ffmpeg4-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/libquicktime/libquicktime-1.2.4-ffmpeg4-1.patch

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

patch -Np1 -i ../libquicktime-1.2.4-ffmpeg4-1.patch &&
./configure --prefix=/usr     \
            --enable-gpl      \
            --without-doxygen \
            --docdir=/usr/share/doc/libquicktime-1.2.4
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/doc/libquicktime-1.2.4 &&
install -v -m644    README doc/{*.txt,*.html,mainpage.incl} \
                    /usr/share/doc/libquicktime-1.2.4

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
