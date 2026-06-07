#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:inih

cd $SOURCE_DIR
NAME=xfsprogs
VERSION=6.18.0
URL=https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-6.18.0.tar.xz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-6.18.0.tar.xz


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
     LOCAL_CONFIGURE_OPTIONS="--localstatedir=/var"
make PKG_DOC_DIR=/usr/share/doc/xfsprogs-6.18.0 install
make PKG_DOC_DIR=/usr/share/doc/xfsprogs-6.18.0 install-dev
rm -rfv /usr/lib/libhandle.{a,la}

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd