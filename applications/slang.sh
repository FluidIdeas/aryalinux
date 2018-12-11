#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak S-Lang (slang) is an interpretedbr3ak language that may be embedded into an application to make thebr3ak application extensible. It provides facilities required bybr3ak interactive applications such as display/screen management,br3ak keyboard input and keymaps.br3ak"
SECTION="general"
VERSION=2.3.2
NAME="slang"

#OPT:libpng
#OPT:pcre


cd $SOURCE_DIR

URL=http://www.jedsoft.org/releases/slang/slang-2.3.2.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://www.jedsoft.org/releases/slang/slang-2.3.2.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/slang/slang-2.3.2.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/slang/slang-2.3.2.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/slang/slang-2.3.2.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/slang/slang-2.3.2.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/slang/slang-2.3.2.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/slang/slang-2.3.2.tar.bz2

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

./configure --prefix=/usr \
            --sysconfdir=/etc \
            --with-readline=gnu &&
make -j1



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install_doc_dir=/usr/share/doc/slang-2.3.2   \
     SLSH_DOC_DIR=/usr/share/doc/slang-2.3.2/slsh \
     install-all &&
chmod -v 755 /usr/lib/libslang.so.2.3.2 \
             /usr/lib/slang/v2/modules/*.so

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
