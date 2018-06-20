#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Poppler package contains a PDFbr3ak rendering library and command line tools used to manipulate PDFbr3ak files. This is useful for providing PDF rendering functionality asbr3ak a shared library.br3ak"
SECTION="general"
VERSION=0.65.0
NAME="poppler"

#REQ:cmake
#REQ:fontconfig
#REC:cairo
#REC:lcms2
#REC:libjpeg
#REC:libpng
#REC:nss
#REC:openjpeg2
#OPT:curl
#OPT:gdk-pixbuf
#OPT:git
#OPT:gobject-introspection
#OPT:gtk-doc
#OPT:gtk3
#OPT:libtiff
#OPT:qt5
#OPT:okular5


cd $SOURCE_DIR

URL=https://poppler.freedesktop.org/poppler-0.65.0.tar.xz

if [ ! -z $URL ]
then
wget -nc https://poppler.freedesktop.org/poppler-0.65.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/poppler/poppler-0.65.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/poppler/poppler-0.65.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/poppler/poppler-0.65.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/poppler/poppler-0.65.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/poppler/poppler-0.65.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/poppler/poppler-0.65.0.tar.xz
wget -nc https://poppler.freedesktop.org/poppler-data-0.4.9.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/poppler/poppler-data-0.4.9.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/poppler/poppler-data-0.4.9.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/poppler/poppler-data-0.4.9.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/poppler/poppler-data-0.4.9.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/poppler/poppler-data-0.4.9.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/poppler/poppler-data-0.4.9.tar.gz

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

mkdir build                         &&
cd    build                         &&
cmake  -DCMAKE_BUILD_TYPE=Release   \
       -DCMAKE_INSTALL_PREFIX=/usr  \
       -DTESTDATADIR=$PWD/testfiles \
       -DENABLE_XPDF_HEADERS=ON     \
       ..                           &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m755 -d           /usr/share/doc/poppler-0.65.0 &&
cp -vr ../glib/reference/html /usr/share/doc/poppler-0.65.0

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


tar -xf ../../poppler-data-0.4.9.tar.gz &&
cd poppler-data-0.4.9



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make prefix=/usr install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
