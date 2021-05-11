#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:efivar
#REQ:popt


cd $SOURCE_DIR

wget -nc https://github.com/rhboot/efibootmgr/archive/17/efibootmgr-17.tar.gz


NAME=efibootmgr
VERSION=17
URL=https://github.com/rhboot/efibootmgr/archive/17/efibootmgr-17.tar.gz
SECTION="File Systems and Disk Management"
DESCRIPTION="The efibootmgr package provides tools and libraries to manipulate EFI variables."

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


sed -e '/extern int efi_set_verbose/d' -i src/efibootmgr.c
make EFIDIR=LFS EFI_LOADER=grubx64.efi
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install sbindir=/sbin EFIDIR=LFS
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

