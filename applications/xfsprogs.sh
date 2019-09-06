#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

wget -nc https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.2.1.tar.xz


NAME=xfsprogs
VERSION=5.2.1
URL=https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.2.1.tar.xz

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


make DEBUG=-DNDEBUG     \
     INSTALL_USER=root  \
     INSTALL_GROUP=root \
     LOCAL_CONFIGURE_OPTIONS="--enable-readline"
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make PKG_DOC_DIR=/usr/share/doc/xfsprogs-5.2.1 install     &&
make PKG_DOC_DIR=/usr/share/doc/xfsprogs-5.2.1 install-dev &&

rm -rfv /usr/lib/libhandle.a                                &&
rm -rfv /lib/libhandle.{a,la,so}                            &&
ln -sfv ../../lib/libhandle.so.1 /usr/lib/libhandle.so      &&
sed -i "s@libdir='/lib@libdir='/usr/lib@" /usr/lib/libhandle.la
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

