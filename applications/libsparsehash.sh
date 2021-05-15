#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR
mkdir -pv $NAME
pushd $NAME

wget -nc https://github.com/sparsehash/sparsehash/archive/sparsehash-2.0.3.tar.gz


NAME=libsparsehash
VERSION=2.0.3
URL=https://github.com/sparsehash/sparsehash/archive/sparsehash-2.0.3.tar.gz
DESCRIPTION="The Google SparseHash project contains several C++ template hash-map implementations in use at Google, with different performance characteristics, including an implementation that optimizes for space and one that optimizes for speed."

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

./configure --prefix=/usr  &&
make "-j`nproc`"
sudo make install


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd