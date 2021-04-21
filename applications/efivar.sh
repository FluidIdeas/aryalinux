#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

wget -nc https://github.com/rhboot/efivar/releases/download/37/efivar-37.tar.bz2
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/4.0/efivar-37-gcc_9-1.patch


NAME=efivar
VERSION=37
URL=https://github.com/rhboot/efivar/releases/download/37/efivar-37.tar.bz2
SECTION="File Systems and Disk Management"
DESCRIPTION="The efivar package provides tools and libraries to manipulate EFI variables."

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


patch -Np1 -i ../efivar-37-gcc_9-1.patch
make CFLAGS="-O2 -Wno-stringop-truncation"
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install LIBDIR=/usr/lib BINDIR=/bin
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
mv /usr/lib/libefi{boot,var}.so.* /lib &&
ln -sfv ../../lib/$(readlink /usr/lib/libefiboot.so) /usr/lib/libefiboot.so &&
ln -sfv ../../lib/$(readlink /usr/lib/libefivar.so) /usr/lib/libefivar.so
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

