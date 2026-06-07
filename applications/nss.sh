#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:nspr
#REQ:p11-kit

cd $SOURCE_DIR
NAME=nss
VERSION=3.120.1
URL=https://archive.mozilla.org/pub/security/nss/releases/NSS_3_120_1_RTM/src/nss-3.120.1.tar.gz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://archive.mozilla.org/pub/security/nss/releases/NSS_3_120_1_RTM/src/nss-3.120.1.tar.gz


if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

echo $USER > /tmp/currentuser

patch -Np1 -i ../nss-standalone-1.patch
cd nss
make BUILD_OPT=1                      \
  NSPR_INCLUDE_DIR=/usr/include/nspr  \
  USE_SYSTEM_ZLIB=1                   \
  ZLIB_LIBS=-lz                       \
  NSS_ENABLE_WERROR=0                 \
  NSS_USE_SYSTEM_SQLITE=1             \
  $([ $(uname -m) = x86_64 ]
echo USE_64=1)
cd tests
HOST=localhost DOMSUF=localdomain ./all.sh
cd ../
cd ../dist
cp -v -RL {public,private}/nss/*              /usr/include/nss
ln -sfv ./pkcs11/p11-kit-trust.so /usr/lib/libnssckbi.so


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -m755 Linux*/lib/*.so              /usr/lib
install -v -m644 Linux*/lib/{*.chk,libcrmf.a} /usr/lib
install -v -m755 -d                           /usr/include/nss
install -v -m755 Linux*/bin/{certutil,nss-config,pk12util} /usr/bin
install -v -m644 Linux*/lib/pkgconfig/nss.pc  /usr/lib/pkgconfig
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd