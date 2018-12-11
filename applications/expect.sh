#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Expect package was installedbr3ak in the LFS temporary tools directory for testing other packages.br3ak These procedures install it in a permanent location. It containsbr3ak tools for automating interactive applications such as <span class=\"command\"><strong>telnet</strong>, <span class=\"command\"><strong>ftp</strong>, <span class=\"command\"><strong>passwd</strong>, <span class=\"command\"><strong>fsck</strong>, <span class=\"command\"><strong>rlogin</strong>, <span class=\"command\"><strong>tip</strong>, etc. Expect is also useful for testing these samebr3ak applications as well as easing all sorts of tasks that arebr3ak prohibitively difficult with anything else.br3ak"
SECTION="general"
VERSION=5.45.4
NAME="expect"

#REQ:tcl
#OPT:tk


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/expect/expect5.45.4.tar.gz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/expect/expect5.45.4.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/expect/expect5.45.4.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/expect/expect5.45.4.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/expect/expect5.45.4.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/expect/expect5.45.4.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/expect/expect5.45.4.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/expect/expect5.45.4.tar.gz

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

./configure --prefix=/usr           \
            --with-tcl=/usr/lib     \
            --enable-shared         \
            --mandir=/usr/share/man \
            --with-tclinclude=/usr/include &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
ln -svf expect5.45.4/libexpect5.45.4.so /usr/lib

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
