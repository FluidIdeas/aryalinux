#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The libfm-extra package contains abr3ak library and other files required by <span class=\"command\"><strong>menu-cache-gen</strong> libexec ofbr3ak <a class=\"xref\" href=\"menu-cache.html\" title=\"menu-cache-1.1.0\">menu-cache-1.1.0</a>.br3ak"
SECTION="lxde"
VERSION=1.3.0.2
NAME="libfm-extra"

#REQ:glib2


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/pcmanfm/libfm-1.3.0.2.tar.xz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/pcmanfm/libfm-1.3.0.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libfm/libfm-1.3.0.2.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libfm/libfm-1.3.0.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libfm/libfm-1.3.0.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libfm/libfm-1.3.0.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libfm/libfm-1.3.0.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libfm/libfm-1.3.0.2.tar.xz

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
            --with-extra-only \
            --with-gtk=no     \
            --disable-static  &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
