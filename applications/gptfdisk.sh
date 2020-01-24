#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:popt


cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/gptfdisk/gptfdisk-1.0.4.tar.gz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/2.1/gptfdisk-1.0.4-convenience-1.patch


NAME=gptfdisk
VERSION=1.0.4
URL=https://downloads.sourceforge.net/gptfdisk/gptfdisk-1.0.4.tar.gz
SECTION="Filesystems and disk management"
DESCRIPTION="The gptfdisk package is a set of programs for creation and maintenance of GUID Partition Table (GPT) disk drives. A GPT partitioned disk is required for drives greater than 2 TB and is a modern replacement for legacy PC-BIOS partitioned disk drives that use a Master Boot Record (MBR). The main program, gdisk, has an inteface similar to the classic fdisk program."

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


patch -Np1 -i ../gptfdisk-1.0.4-convenience-1.patch &&
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

