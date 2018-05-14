#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak DejaGnu is a framework for runningbr3ak test suites on GNU tools. It is written in <span class=\"command\"><strong>expect</strong>, which uses Tcl (Tool command language). It was installedbr3ak by LFS in the temporary <code class=\"filename\">/toolsbr3ak directory. These instructions install it permanently.br3ak"
SECTION="general"
VERSION=1.6.1
NAME="dejagnu"

#REQ:expect
#OPT:docbook-utils


cd $SOURCE_DIR

URL=https://ftp.gnu.org/gnu/dejagnu/dejagnu-1.6.1.tar.gz

if [ ! -z $URL ]
then
wget -nc https://ftp.gnu.org/gnu/dejagnu/dejagnu-1.6.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/dejagnu/dejagnu-1.6.1.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/dejagnu/dejagnu-1.6.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/dejagnu/dejagnu-1.6.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/dejagnu/dejagnu-1.6.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/dejagnu/dejagnu-1.6.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/dejagnu/dejagnu-1.6.1.tar.gz || wget -nc ftp://ftp.gnu.org/gnu/dejagnu/dejagnu-1.6.1.tar.gz

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
makeinfo --html --no-split -o doc/dejagnu.html doc/dejagnu.texi &&
makeinfo --plaintext       -o doc/dejagnu.txt  doc/dejagnu.texi



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -dm755   /usr/share/doc/dejagnu-1.6.1 &&
install -v -m644    doc/dejagnu.{html,txt} \
                    /usr/share/doc/dejagnu-1.6.1

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
