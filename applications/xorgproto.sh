#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The xorgproto package provides thebr3ak header files required to build the X Window system, and to allowbr3ak other applications to build against the installed X Window system.br3ak"
SECTION="x"
VERSION=2018.4
NAME="xorgproto"

#REQ:util-macros
#OPT:fop
#OPT:libxslt
#OPT:xmlto
#OPT:asciidoc


cd $SOURCE_DIR

URL=https://xorg.freedesktop.org/archive/individual/proto/xorgproto-2018.4.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://xorg.freedesktop.org/archive/individual/proto/xorgproto-2018.4.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/Xorg/xorgproto-2018.4.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/Xorg/xorgproto-2018.4.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/Xorg/xorgproto-2018.4.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/Xorg/xorgproto-2018.4.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/Xorg/xorgproto-2018.4.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/Xorg/xorgproto-2018.4.tar.bz2

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

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static"

mkdir build &&
cd    build &&
meson --prefix=/usr .. &&
ninja



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ninja install &&
install -vdm 755 /usr/share/doc/xorgproto-2018.4 &&
install -vm 644 ../[^m]*.txt ../PM_spec /usr/share/doc/xorgproto-2018.4

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
