#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Nano package contains a small,br3ak simple text editor which aims to replace Pico, the default editor in the Pine package.br3ak"
SECTION="postlfs"
VERSION=2.9.8
NAME="nano"



cd $SOURCE_DIR

URL=https://www.nano-editor.org/dist/v2.9/nano-2.9.8.tar.xz

if [ ! -z $URL ]
then
wget -nc https://www.nano-editor.org/dist/v2.9/nano-2.9.8.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/nano/nano-2.9.8.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/nano/nano-2.9.8.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/nano/nano-2.9.8.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/nano/nano-2.9.8.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/nano/nano-2.9.8.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/nano/nano-2.9.8.tar.xz

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
            --enable-utf8     \
            --docdir=/usr/share/doc/nano-2.9.8 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m644 doc/{nano.html,sample.nanorc} /usr/share/doc/nano-2.9.8

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
