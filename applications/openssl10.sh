#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The OpenSSL-1.0.2p packagebr3ak contains libraries relating to cryptography. These are useful forbr3ak providing cryptographic functions to other packages, such as emailbr3ak applications and web browsers (for accessing HTTPS sites). Thisbr3ak package provides only the libraries and headers for packages thatbr3ak have not yet been ported to openssl-1.1.x or later.br3ak"
SECTION="postlfs"
VERSION=1.0.2p
NAME="openssl10"

#OPT:mitkrb


cd $SOURCE_DIR

URL=https://openssl.org/source/openssl-1.0.2p.tar.gz

if [ ! -z $URL ]
then
wget -nc https://openssl.org/source/openssl-1.0.2p.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/openssl/openssl-1.0.2p.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/openssl/openssl-1.0.2p.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/openssl/openssl-1.0.2p.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/openssl/openssl-1.0.2p.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/openssl/openssl-1.0.2p.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/openssl/openssl-1.0.2p.tar.gz || wget -nc ftp://openssl.org/source/openssl-1.0.2p.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/openssl-1.0.2p-compat_versioned_symbols-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/openssl/openssl-1.0.2p-compat_versioned_symbols-1.patch

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

patch -Np1 -i ../openssl-1.0.2p-compat_versioned_symbols-1.patch &&
./config --prefix=/usr            \
         --openssldir=/etc/ssl    \
         --libdir=lib/openssl-1.0 \
         shared                   \
         zlib-dynamic             &&
make depend                       &&
make -j1



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make INSTALL_PREFIX=$PWD/Dest install_sw                      &&
rm -rf /usr/lib/openssl-1.0                                   &&
install -vdm755                   /usr/lib/openssl-1.0        &&
cp -Rv Dest/usr/lib/openssl-1.0/* /usr/lib/openssl-1.0        &&
mv -v  /usr/lib/openssl-1.0/lib{crypto,ssl}.so.1.0.0 /usr/lib &&
ln -sv ../libssl.so.1.0.0         /usr/lib/openssl-1.0        &&
ln -sv ../libcrypto.so.1.0.0      /usr/lib/openssl-1.0        &&
install -vdm755                   /usr/include/openssl-1.0    &&
cp -Rv Dest/usr/include/openssl   /usr/include/openssl-1.0    &&
sed 's@/include$@/include/openssl-1.0@' -i /usr/lib/openssl-1.0/pkgconfig/*.pc

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
