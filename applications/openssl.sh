#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The OpenSSL package containsbr3ak management tools and libraries relating to cryptography. These arebr3ak useful for providing cryptographic functions to other packages,br3ak such as OpenSSH, emailbr3ak applications and web browsers (for accessing HTTPS sites).br3ak"
SECTION="postlfs"
VERSION=1.1.0g
NAME="openssl"



cd $SOURCE_DIR

URL=https://openssl.org/source/openssl-1.1.0g.tar.gz

if [ ! -z $URL ]
then
wget -nc https://openssl.org/source/openssl-1.1.0g.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/openssl/openssl-1.1.0g.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/openssl/openssl-1.1.0g.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/openssl/openssl-1.1.0g.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/openssl/openssl-1.1.0g.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/openssl/openssl-1.1.0g.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/openssl/openssl-1.1.0g.tar.gz || wget -nc ftp://openssl.org/source/openssl-1.1.0g.tar.gz

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

./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic &&
make "-j`nproc`" || make


sed -i 's# libcrypto.a##;s# libssl.a##;/INSTALL_LIBS/s#libcrypto.a##' Makefile



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make MANSUFFIX=ssl install           &&
mv -vf /usr/share/doc/openssl{,-1.1.0g} &&
cp -vfr doc/* /usr/share/doc/openssl-1.1.0g

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
