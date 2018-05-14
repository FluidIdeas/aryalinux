#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak neon is an HTTP and WebDAV clientbr3ak library, with a C interface.br3ak"
SECTION="basicnet"
VERSION=0.30.2
NAME="neon"

#OPT:gnutls
#OPT:libxml2
#OPT:mitkrb


cd $SOURCE_DIR

URL=https://fossies.org/linux/www/neon-0.30.2.tar.gz

if [ ! -z $URL ]
then
wget -nc https://fossies.org/linux/www/neon-0.30.2.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/neon/neon-0.30.2.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/neon/neon-0.30.2.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/neon/neon-0.30.2.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/neon/neon-0.30.2.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/neon/neon-0.30.2.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/neon/neon-0.30.2.tar.gz

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

sed -e 's/client_set/set/'  \
    -e 's/gnutls_retr/&2/'  \
    -e 's/type = t/cert_&/' \
    -i src/ne_gnutls.c


./configure --prefix=/usr    \
            --with-ssl       \
            --enable-shared  \
            --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
