#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The libbytesize package is abr3ak library facilitates the common operations with sizes in bytes.br3ak"
SECTION="general"
VERSION=1.4
NAME="libbytesize"

#REQ:pcre
#OPT:gtk-doc
#OPT:python2
#OPT:python-modules#six


cd $SOURCE_DIR

URL=https://github.com/storaged-project/libbytesize/releases/download/1.4/libbytesize-1.4.tar.gz

if [ ! -z $URL ]
then
wget -nc https://github.com/storaged-project/libbytesize/releases/download/1.4/libbytesize-1.4.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libbytesize/libbytesize-1.4.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libbytesize/libbytesize-1.4.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libbytesize/libbytesize-1.4.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libbytesize/libbytesize-1.4.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libbytesize/libbytesize-1.4.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libbytesize/libbytesize-1.4.tar.gz

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

./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
