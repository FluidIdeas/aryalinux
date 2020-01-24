#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:fuse
#REQ:glib2
#REQ:openssh


cd $SOURCE_DIR

wget -nc https://github.com/libfuse/sshfs/releases/download/sshfs-3.5.2/sshfs-3.5.2.tar.xz


NAME=sshfs
VERSION=3.5.2
URL=https://github.com/libfuse/sshfs/releases/download/sshfs-3.5.2/sshfs-3.5.2.tar.xz
SECTION="Filesystems and disk management"
DESCRIPTION="The Sshfs package contains a filesystem client based on the SSH File Transfer Protocol. This is useful for mounting a remote computer that you have ssh access to as a local filesystem. This allows you to drag and drop files or run shell commands on the remote files as if they were on your local computer."

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


mkdir build &&
cd    build &&
          
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

