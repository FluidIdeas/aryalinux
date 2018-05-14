#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Ghostscript is a versatilebr3ak processor for PostScript data with the ability to render PostScriptbr3ak to different targets. It is a mandatory part of the cups printingbr3ak stack.br3ak"
SECTION="pst"
VERSION=9.23
NAME="gs"

#REC:cups
#REC:fontconfig
#REC:freetype2
#REC:libjpeg
#REC:libpng
#REC:libtiff
#REC:lcms2
#OPT:cairo
#OPT:gtk3
#OPT:libidn
#OPT:libpaper
#OPT:lcms
#OPT:xorg-server


cd $SOURCE_DIR

URL=https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs923/ghostscript-9.23.tar.gz

if [ ! -z $URL ]
then
wget -nc https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs923/ghostscript-9.23.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/ghostscript/ghostscript-9.23.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/ghostscript/ghostscript-9.23.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/ghostscript/ghostscript-9.23.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/ghostscript/ghostscript-9.23.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/ghostscript/ghostscript-9.23.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/ghostscript/ghostscript-9.23.tar.gz
wget -nc https://downloads.sourceforge.net/gs-fonts/ghostscript-fonts-std-8.11.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/ghostscript/ghostscript-fonts-std-8.11.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/ghostscript/ghostscript-fonts-std-8.11.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/ghostscript/ghostscript-fonts-std-8.11.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/ghostscript/ghostscript-fonts-std-8.11.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/ghostscript/ghostscript-fonts-std-8.11.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/ghostscript/ghostscript-fonts-std-8.11.tar.gz
wget -nc https://downloads.sourceforge.net/gs-fonts/gnu-gs-fonts-other-6.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnu-gs-fonts-other/gnu-gs-fonts-other-6.0.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gnu-gs-fonts-other/gnu-gs-fonts-other-6.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnu-gs-fonts-other/gnu-gs-fonts-other-6.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnu-gs-fonts-other/gnu-gs-fonts-other-6.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnu-gs-fonts-other/gnu-gs-fonts-other-6.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnu-gs-fonts-other/gnu-gs-fonts-other-6.0.tar.gz

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

rm -rf freetype lcms2 jpeg libpng


rm -rf zlib &&
./configure --prefix=/usr           \
            --disable-compile-inits \
            --enable-dynamic        \
            --with-system-libtiff   &&
make "-j`nproc`" || make


make so



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make soinstall &&
install -v -m644 base/*.h /usr/include/ghostscript &&
ln -v -s ghostscript /usr/include/ps

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ln -sfvn ../ghostscript/9.23/doc /usr/share/doc/ghostscript-9.23

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
