#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:fuse
#REQ:glib2
#REQ:openssh
#OPT:docutils

cd $SOURCE_DIR

wget -nc https://github.com/libfuse/sshfs/releases/download/sshfs-3.5.1/sshfs-3.5.1.tar.xz

NAME=sshfs
VERSION=3.5.1
URL=https://github.com/libfuse/sshfs/releases/download/sshfs-3.5.1/sshfs-3.5.1.tar.xz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

if [ $(uname -m) = "i686" ]; then
export CFLAGS+="-D_FILE_OFFSET_BITS=64";
fi
mkdir build &&
cd build &&

meson --prefix=/usr .. &&
ninja

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sshfs example.com:/home/userid ~/examplepath
fusermount3 -u ~/example

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
