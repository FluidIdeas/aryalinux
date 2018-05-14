#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The enchant package provide abr3ak generic interface into various existing spell checking libraries.br3ak"
SECTION="general"
VERSION=2.2.3
NAME="enchant"

#REQ:glib2
#REC:aspell
#OPT:dbus-glib


cd $SOURCE_DIR

URL=https://github.com/AbiWord/enchant/releases/download/v2.2.3/enchant-2.2.3.tar.gz

if [ ! -z $URL ]
then
wget -nc https://github.com/AbiWord/enchant/releases/download/v2.2.3/enchant-2.2.3.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/enchant/enchant-2.2.3.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/enchant/enchant-2.2.3.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/enchant/enchant-2.2.3.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/enchant/enchant-2.2.3.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/enchant/enchant-2.2.3.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/enchant/enchant-2.2.3.tar.gz

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

./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install                                   &&
rm -rf /usr/include/enchant                    &&
ln -sfv enchant-2       /usr/include/enchant   &&
ln -sfv enchant-2       /usr/bin/enchant       &&
ln -sfv libenchant-2.so /usr/lib/libenchant.so &&
ln -sfv enchant-2.pc    /usr/lib/pkgconfig/enchant.pc

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cat > /tmp/test-enchant.txt << "EOF"
Tel me more abot linux
Ther ar so many commads
EOF
enchant -d en_GB -l /tmp/test-enchant.txt &&
enchant -d en_GB -a /tmp/test-enchant.txt




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
