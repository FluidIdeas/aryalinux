#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The PCRE2 package contains a newbr3ak generation of the Perl Compatible Regularbr3ak Expression libraries. These are useful for implementingbr3ak regular expression pattern matching using the same syntax andbr3ak semantics as Perl.br3ak"
SECTION="general"
VERSION=10.31
NAME="pcre2"

#OPT:valgrind


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/pcre/pcre2-10.31.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/pcre/pcre2-10.31.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/pcre2/pcre2-10.31.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/pcre2/pcre2-10.31.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/pcre2/pcre2-10.31.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/pcre2/pcre2-10.31.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/pcre2/pcre2-10.31.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/pcre2/pcre2-10.31.tar.bz2 || wget -nc ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre2-10.31.tar.bz2

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

./configure --prefix=/usr                       \
            --docdir=/usr/share/doc/pcre2-10.31 \
            --enable-unicode                    \
            --enable-jit                        \
            --enable-pcre2-16                   \
            --enable-pcre2-32                   \
            --enable-pcre2grep-libz             \
            --enable-pcre2grep-libbz2           \
            --enable-pcre2test-libreadline      \
            --disable-static                    &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
