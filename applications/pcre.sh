#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The PCRE package containsbr3ak Perl Compatible Regular Expressionbr3ak libraries. These are useful for implementing regular expressionbr3ak pattern matching using the same syntax and semantics asbr3ak Perl 5.br3ak"
SECTION="general"
VERSION=8.42
NAME="pcre"

#OPT:valgrind


cd $SOURCE_DIR

URL=https://ftp.pcre.org/pub/pcre/pcre-8.42.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://ftp.pcre.org/pub/pcre/pcre-8.42.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/pcre/pcre-8.42.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/pcre/pcre-8.42.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/pcre/pcre-8.42.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/pcre/pcre-8.42.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/pcre/pcre-8.42.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/pcre/pcre-8.42.tar.bz2 || wget -nc ftp://ftp.pcre.org/pub/pcre/pcre-8.42.tar.bz2

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

./configure --prefix=/usr                     \
            --docdir=/usr/share/doc/pcre-8.42 \
            --enable-unicode-properties       \
            --enable-pcre16                   \
            --enable-pcre32                   \
            --enable-pcregrep-libz            \
            --enable-pcregrep-libbz2          \
            --enable-pcretest-libreadline     \
            --disable-static                 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install                     &&
mv -v /usr/lib/libpcre.so.* /lib &&
ln -sfv ../../lib/$(readlink /usr/lib/libpcre.so) /usr/lib/libpcre.so

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
