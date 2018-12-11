#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The gptfdisk package is a set ofbr3ak programs for creation and maintenance of GUID Partition Table (GPT)br3ak disk drives. A GPT partitioned disk is required for drives greaterbr3ak than 2 TB and is a modern replacement for legacy PC-BIOSbr3ak partitioned disk drives that use a Master Boot Record (MBR). Thebr3ak main program, <span class=\"command\"><strong>gdisk</strong>,br3ak has an inteface similar to the classic <span class=\"command\"><strong>fdisk</strong> program.br3ak"
SECTION="postlfs"
VERSION=1.0.4
NAME="gptfdisk"

#REQ:popt
#OPT:icu


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/gptfdisk/gptfdisk-1.0.4.tar.gz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/gptfdisk/gptfdisk-1.0.4.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gptfdisk/gptfdisk-1.0.4.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gptfdisk/gptfdisk-1.0.4.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gptfdisk/gptfdisk-1.0.4.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gptfdisk/gptfdisk-1.0.4.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gptfdisk/gptfdisk-1.0.4.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gptfdisk/gptfdisk-1.0.4.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/gptfdisk-1.0.4-convenience-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/gptfdisk/gptfdisk-1.0.4-convenience-1.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

patch -Np1 -i ../gptfdisk-1.0.4-convenience-1.patch &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
