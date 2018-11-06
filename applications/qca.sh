#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Qca aims to provide abr3ak straightforward and cross-platform crypto API, using Qt datatypes and conventions. Qca separates the API from the implementation,br3ak using plugins known as Providers.br3ak"
SECTION="general"
VERSION=2.1.3
NAME="qca"

#REQ:make-ca
#REQ:cmake
#REQ:qt5
#REQ:general_which
#OPT:cyrus-sasl
#OPT:gnupg
#OPT:libgcrypt
#OPT:libgpg-error
#OPT:nss
#OPT:nspr
#OPT:openssl10
#OPT:p11-kit
#OPT:doxygen
#OPT:general_which


cd $SOURCE_DIR

URL=http://download.kde.org/stable/qca/2.1.3/src/qca-2.1.3.tar.xz

if [ ! -z $URL ]
then
wget -nc http://download.kde.org/stable/qca/2.1.3/src/qca-2.1.3.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/qca/qca-2.1.3.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/qca/qca-2.1.3.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/qca/qca-2.1.3.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/qca/qca-2.1.3.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/qca/qca-2.1.3.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/qca/qca-2.1.3.tar.xz

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

export QT4PREFIX="/opt/qt4"
export QT4BINDIR="$QT4PREFIX/bin"
export QT4DIR="$QT4PREFIX"
export QTDIR="$QT4PREFIX"
export PATH="$PATH:$QT4BINDIR"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/opt/qt4/lib/pkgconfig"
sed -i 's@ca-bundle.pem@ca-bundle.crt@' CMakeLists.txt


export QT4PREFIX="/opt/qt4"
export QT4BINDIR="$QT4PREFIX/bin"
export QT4DIR="$QT4PREFIX"
export QTDIR="$QT4PREFIX"
export PATH="$PATH:$QT4BINDIR"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/opt/qt4/lib/pkgconfig"
mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=/opt/qt5                             \
      -DCMAKE_BUILD_TYPE=Release                                 \
      -DQCA_MAN_INSTALL_DIR:PATH=/usr/share/man                  \
      -DOPENSSL_INCLUDE_DIR=/usr/include/openssl-1.0             \
      -DOPENSSL_SSL_LIBRARY=/usr/lib/openssl-1.0/libssl.so       \
      -DOPENSSL_CRYPTO_LIBRARY=/usr/lib/openssl-1.0/libcrypto.so \
      ..                                                         &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
export QT4PREFIX="/opt/qt4"
export QT4BINDIR="$QT4PREFIX/bin"
export QT4DIR="$QT4PREFIX"
export QTDIR="$QT4PREFIX"
export PATH="$PATH:$QT4BINDIR"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/opt/qt4/lib/pkgconfig"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
