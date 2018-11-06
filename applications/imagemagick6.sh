#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak ImageMagick underwent many changesbr3ak in its libraries between versions 6 and 7. Most packages in BLFSbr3ak which use ImageMagick can usebr3ak version 7, but for the others this page will install only thebr3ak libraries, headers and general documentation (not programs,br3ak manpages, perl modules), and it will rename the unversionedbr3ak pkgconfig files so that they do not overwrite the same-named filesbr3ak from version 7.br3ak"
SECTION="general"
VERSION=10
NAME="imagemagick6"

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

URL=https://www.imagemagick.org/download/releases/ImageMagick-6.9.10-10.tar.xz

if [ ! -z $URL ]
then
wget -nc https://www.imagemagick.org/download/releases/ImageMagick-6.9.10-10.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/ImageMagick/ImageMagick-6.9.10-10.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/ImageMagick/ImageMagick-6.9.10-10.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/ImageMagick/ImageMagick-6.9.10-10.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/ImageMagick/ImageMagick-6.9.10-10.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/ImageMagick/ImageMagick-6.9.10-10.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/ImageMagick/ImageMagick-6.9.10-10.tar.xz || wget -nc ftp://ftp.imagemagick.org/pub/ImageMagick/releases/ImageMagick-6.9.10-10.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/ImageMagick-6.9.10-10-libs_only-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/ImageMagick/ImageMagick-6.9.10-10-libs_only-1.patch
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

patch -Np1 -i ../ImageMagick-6.9.10-10-libs_only-1.patch &&
autoreconf -fi                                          &&
./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --enable-hdri     \
            --with-modules    \
            --disable-static  &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make DOCUMENTATION_PATH=/usr/share/doc/imagemagick-6.9.10 install-libs-only

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
