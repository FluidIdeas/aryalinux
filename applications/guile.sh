#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Guile package contains the GNUbr3ak Project's extension language library. Guile also contains a stand alone Scheme interpreter.br3ak"
SECTION="general"
VERSION=2.2.4
NAME="guile"

#REQ:gc
#REQ:libunistring
#OPT:emacs
#OPT:gdb


cd $SOURCE_DIR

URL=https://ftp.gnu.org/gnu/guile/guile-2.2.4.tar.xz

if [ ! -z $URL ]
then
wget -nc https://ftp.gnu.org/gnu/guile/guile-2.2.4.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/guile/guile-2.2.4.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/guile/guile-2.2.4.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/guile/guile-2.2.4.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/guile/guile-2.2.4.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/guile/guile-2.2.4.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/guile/guile-2.2.4.tar.xz || wget -nc ftp://ftp.gnu.org/gnu/guile/guile-2.2.4.tar.xz

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
            --docdir=/usr/share/doc/guile-2.2.4 &&
make      &&
make html &&
makeinfo --plaintext -o doc/r5rs/r5rs.txt doc/r5rs/r5rs.texi &&
makeinfo --plaintext -o doc/ref/guile.txt doc/ref/guile.texi



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install      &&
make install-html &&
mv /usr/lib/libguile-*-gdb.scm /usr/share/gdb/auto-load/usr/lib &&
mv /usr/share/doc/guile-2.2.4/{guile.html,ref} &&
mv /usr/share/doc/guile-2.2.4/r5rs{.html,}     &&
find examples -name "Makefile*" -delete         &&
cp -vR examples   /usr/share/doc/guile-2.2.4   &&
for DIRNAME in r5rs ref; do
  install -v -m644  doc/${DIRNAME}/*.txt \
                    /usr/share/doc/guile-2.2.4/${DIRNAME}
done &&
unset DIRNAME

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
