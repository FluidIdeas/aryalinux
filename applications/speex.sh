#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Speex is an audio compressionbr3ak format designed especially for speech. It is well-adapted tobr3ak internet applications and provides useful features that are notbr3ak present in most other CODECs.br3ak"
SECTION="multimedia"
VERSION=1.2.0
NAME="speex"

#REQ:libogg
#OPT:valgrind


cd $SOURCE_DIR

URL=https://downloads.xiph.org/releases/speex/speex-1.2.0.tar.gz

if [ ! -z $URL ]
then
wget -nc https://downloads.xiph.org/releases/speex/speex-1.2.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/speex/speex-1.2.0.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/speex/speex-1.2.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/speex/speex-1.2.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/speex/speex-1.2.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/speex/speex-1.2.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/speex/speex-1.2.0.tar.gz
wget -nc https://downloads.xiph.org/releases/speex/speexdsp-1.2rc3.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/speex/speexdsp-1.2rc3.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/speex/speexdsp-1.2rc3.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/speex/speexdsp-1.2rc3.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/speex/speexdsp-1.2rc3.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/speex/speexdsp-1.2rc3.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/speex/speexdsp-1.2rc3.tar.gz

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

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/speex-1.2.0 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cd ..                          &&
tar -xf speexdsp-1.2rc3.tar.gz &&
cd speexdsp-1.2rc3             &&
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/speexdsp-1.2rc3 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cd $SOURCE_DIR
for f in speex*; do if [ -d $f ]; then rm -rf $f; fi; done;
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
