#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The volume_key package provides abr3ak library for manipulating storage volume encryption keys and storingbr3ak them separately from volumes to handle forgotten passphrases.br3ak"
SECTION="postlfs"
VERSION=0.3.12
NAME="volume_key"

#REQ:cryptsetup
#REQ:glib2
#REQ:gpgme
#REQ:nss
#REQ:python2
#OPT:swig


cd $SOURCE_DIR

URL=https://github.com/felixonmars/volume_key/archive/volume_key-0.3.12.tar.gz

if [ ! -z $URL ]
then
wget -nc https://github.com/felixonmars/volume_key/archive/volume_key-0.3.12.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/volume_key/volume_key-0.3.12.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/volume_key/volume_key-0.3.12.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/volume_key/volume_key-0.3.12.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/volume_key/volume_key-0.3.12.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/volume_key/volume_key-0.3.12.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/volume_key/volume_key-0.3.12.tar.gz

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

autoreconf -fiv           &&
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
