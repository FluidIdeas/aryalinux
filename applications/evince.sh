#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Evince is a document viewer forbr3ak multiple document formats. It supports PDF, Postscript, DjVu, TIFFbr3ak and DVI. It is useful for viewing documents of various types usingbr3ak one simple application instead of the multiple document viewersbr3ak that once existed on the GNOMEbr3ak Desktop.br3ak"
SECTION="gnome"
VERSION=3.28.2
NAME="evince"

#REQ:adwaita-icon-theme
#REQ:gsettings-desktop-schemas
#REQ:gtk3
#REQ:itstool
#REQ:libxml2
#REC:gnome-keyring
#REC:gobject-introspection
#REC:libsecret
#REC:nautilus
#REC:poppler
#OPT:cups
#OPT:gnome-desktop
#OPT:gst10-plugins-base
#OPT:gtk-doc
#OPT:libtiff
#OPT:texlive
#OPT:tl-installer


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/evince/3.28/evince-3.28.2.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/evince/3.28/evince-3.28.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/evince/evince-3.28.2.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/evince/evince-3.28.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/evince/evince-3.28.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/evince/evince-3.28.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/evince/evince-3.28.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/evince/evince-3.28.2.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/evince/3.28/evince-3.28.2.tar.xz
wget -nc http://www.ibiblio.org/pub/Linux/libs/graphics/t1lib-5.1.2.tar.gz

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

./configure --prefix=/usr                     \
            --enable-compile-warnings=minimum \
            --enable-introspection            \
            --disable-static                  &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
