#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Cbindgen can be used to generate Cbr3ak bindings for Rust code.br3ak"
SECTION="general"
VERSION=0.6.6
NAME="cbindgen"

#REQ:rust


cd $SOURCE_DIR

URL=https://github.com/eqrion/cbindgen/archive/v0.6.6/cbindgen-0.6.6.tar.gz

if [ ! -z $URL ]
then
wget -nc https://github.com/eqrion/cbindgen/archive/v0.6.6/cbindgen-0.6.6.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/cbindgen/cbindgen-0.6.6.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/cbindgen/cbindgen-0.6.6.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/cbindgen/cbindgen-0.6.6.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/cbindgen/cbindgen-0.6.6.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/cbindgen/cbindgen-0.6.6.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/cbindgen/cbindgen-0.6.6.tar.gz

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

cargo build --release



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -Dm755 target/release/cbindgen /usr/bin/

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
