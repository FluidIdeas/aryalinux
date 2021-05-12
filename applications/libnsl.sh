#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:rpcsvc-proto
#REQ:libtirpc


cd $SOURCE_DIR

wget -nc https://github.com/thkukuk/libnsl/releases/download/v1.3.0/libnsl-1.3.0.tar.xz


NAME=libnsl
VERSION=1.3.0
URL=https://github.com/thkukuk/libnsl/releases/download/v1.3.0/libnsl-1.3.0.tar.xz
SECTION="Networking Libraries"
DESCRIPTION="The libnsl package contains the public client interface for NIS(YP) and NIS+. It replaces the NIS library that used to be in glibc."

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


autoreconf -fi                &&
./configure --sysconfdir=/etc &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install                  &&
mv /usr/lib/libnsl.so.2* /lib &&
ln -sfv ../../lib/libnsl.so.2.0.1 /usr/lib/libnsl.so
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

