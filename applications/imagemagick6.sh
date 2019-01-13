#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

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
#OPT:dejavu-fonts
#OPT:gs
#OPT:gimp
#OPT:graphviz
#OPT:inkscape
#OPT:gpcldnld
#OPT:enscript
#OPT:texlive
#OPT:tl-installer
#OPT:html2ps

cd $SOURCE_DIR

wget -nc https://www.imagemagick.org/download/releases/ImageMagick-6.9.10-10.tar.xz
wget -nc ftp://ftp.imagemagick.org/pub/ImageMagick/releases/ImageMagick-6.9.10-10.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/ImageMagick-6.9.10-10-libs_only-1.patch
wget -nc http://www.mcmurchy.com/ralcgm/ralcgm-3.51.tar.gz
wget -nc http://www.mcmurchy.com/urt/urt-3.1b.tar.gz

NAME=imagemagick6
VERSION=10
URL=https://www.imagemagick.org/download/releases/ImageMagick-6.9.10-10.tar.xz

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

patch -Np1 -i ../ImageMagick-6.9.10-10-libs_only-1.patch &&
autoreconf -fi &&
./configure --prefix=/usr \
--sysconfdir=/etc \
--enable-hdri \
--with-modules \
--disable-static &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make DOCUMENTATION_PATH=/usr/share/doc/imagemagick-6.9.10 install-libs-only
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
