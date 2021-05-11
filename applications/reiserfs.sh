#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

wget -nc https://www.kernel.org/pub/linux/kernel/people/jeffm/reiserfsprogs/v3.6.27/reiserfsprogs-3.6.27.tar.xz


NAME=reiserfs
VERSION=3.6.27
URL=https://www.kernel.org/pub/linux/kernel/people/jeffm/reiserfsprogs/v3.6.27/reiserfsprogs-3.6.27.tar.xz
SECTION="File Systems and Disk Management"
DESCRIPTION="The reiserfsprogs package contains various utilities for use with the Reiser file system."

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	if [ $NAME == "firefox" ]; then set +e; fi;
	tar --no-overwrite-dir -xf $TARBALL
	set -e
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

echo $USER > /tmp/currentuser


sed -i '/parse_time.h/i #define _GNU_SOURCE' lib/parse_time.c &&
autoreconf -fiv             &&
./configure --prefix=/usr   \
            --sbindir=/sbin &&

make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

