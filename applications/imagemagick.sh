#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak ImageMagick is a collection ofbr3ak tools and libraries to read, write, and manipulate an image inbr3ak various image formats. Image processing operations are availablebr3ak from the command line. Bindings for Perl and C++ are alsobr3ak available.br3ak"
SECTION="general"
VERSION=23
NAME="imagemagick"

#REC:x7lib
#OPT:cups
#OPT:curl
#OPT:ffmpeg
#OPT:fftw
#OPT:p7zip
#OPT:sane
#OPT:wget
#OPT:xdg-utils
#OPT:xterm
#OPT:gnupg
#OPT:jasper
#OPT:lcms
#OPT:lcms2
#OPT:libexif
#OPT:libjpeg
#OPT:libpng
#OPT:libraw
#OPT:librsvg
#OPT:libtiff
#OPT:libwebp
#OPT:openjpeg2
#OPT:pango
#OPT:TTF-and-OTF-fonts#dejavu-fonts
#OPT:gs
#OPT:gimp
#OPT:graphviz
#OPT:inkscape
#OPT:enscript
#OPT:texlive
#OPT:tl-installer


cd $SOURCE_DIR

URL=https://www.imagemagick.org/download/releases/ImageMagick-7.0.7-23.tar.xz

if [ ! -z $URL ]
then
wget -nc https://www.imagemagick.org/download/releases/ImageMagick-7.0.7-23.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/ImageMagick/ImageMagick-7.0.7-23.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/ImageMagick/ImageMagick-7.0.7-23.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/ImageMagick/ImageMagick-7.0.7-23.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/ImageMagick/ImageMagick-7.0.7-23.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/ImageMagick/ImageMagick-7.0.7-23.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/ImageMagick/ImageMagick-7.0.7-23.tar.xz || wget -nc ftp://ftp.imagemagick.org/pub/ImageMagick/releases/ImageMagick-7.0.7-23.tar.xz
wget -nc http://www.mcmurchy.com/ralcgm/ralcgm-3.51.tar.gz
wget -nc http://www.mcmurchy.com/urt/urt-3.1b.tar.gz

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

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --enable-hdri     \
            --with-modules    \
            --with-perl       \
            --disable-static  &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make DOCUMENTATION_PATH=/usr/share/doc/imagemagick-7.0.7 install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
