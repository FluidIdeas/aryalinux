#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak w3m is primarily a pager but itbr3ak can also be used as a text-mode WWW browser.br3ak"
SECTION="basicnet"
VERSION=0.5.3
NAME="w3m"

#REQ:gc
#OPT:gpm
#OPT:imlib2
#OPT:gtk2
#OPT:gdk-pixbuf
#OPT:compface


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/w3m/w3m-0.5.3.tar.gz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/w3m/w3m-0.5.3.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/w3m/w3m-0.5.3.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/w3m/w3m-0.5.3.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/w3m/w3m-0.5.3.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/w3m/w3m-0.5.3.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/w3m/w3m-0.5.3.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/w3m/w3m-0.5.3.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/w3m-0.5.3-bdwgc72-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/w3m/w3m-0.5.3-bdwgc72-1.patch

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

patch -Np1 -i ../w3m-0.5.3-bdwgc72-1.patch      &&
sed -i 's/file_handle/file_foo/' istream.{c,h}  &&
sed -i 's#gdk-pixbuf-xlib-2.0#& x11#' configure &&
sed -i '/USE_EGD/s/define/undef/' config.h.in   &&
./configure --prefix=/usr --sysconfdir=/etc  &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m644 -D doc/keymap.default /etc/w3m/keymap &&
install -v -m644    doc/menu.default /etc/w3m/menu &&
install -v -m755 -d /usr/share/doc/w3m-0.5.3 &&
install -v -m644    doc/{HISTORY,READ*,keymap.*,menu.*,*.html} \
                    /usr/share/doc/w3m-0.5.3

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
