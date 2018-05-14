#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The cpio package contains toolsbr3ak for archiving.br3ak"
SECTION="general"
VERSION=2.12
NAME="cpio"

#OPT:texlive
#OPT:tl-installer


cd $SOURCE_DIR

URL=https://ftp.gnu.org/gnu/cpio/cpio-2.12.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://ftp.gnu.org/gnu/cpio/cpio-2.12.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/cpio/cpio-2.12.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/cpio/cpio-2.12.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/cpio/cpio-2.12.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/cpio/cpio-2.12.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/cpio/cpio-2.12.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/cpio/cpio-2.12.tar.bz2 || wget -nc ftp://ftp.gnu.org/gnu/cpio/cpio-2.12.tar.bz2

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
            --bindir=/bin \
            --enable-mt   \
            --with-rmt=/usr/libexec/rmt &&
make &&
makeinfo --html            -o doc/html      doc/cpio.texi &&
makeinfo --html --no-split -o doc/cpio.html doc/cpio.texi &&
makeinfo --plaintext       -o doc/cpio.txt  doc/cpio.texi



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/doc/cpio-2.12/html &&
install -v -m644    doc/html/* \
                    /usr/share/doc/cpio-2.12/html &&
install -v -m644    doc/cpio.{html,txt} \
                    /usr/share/doc/cpio-2.12

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
