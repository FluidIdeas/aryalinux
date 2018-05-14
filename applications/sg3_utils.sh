#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The sg3_utils package contains lowbr3ak level utilities for devices that use a SCSI command set. Apart frombr3ak SCSI parallel interface (SPI) devices, the SCSI command set is usedbr3ak by ATAPI devices (CD/DVDs and tapes), USB mass storage devices,br3ak Fibre Channel disks, IEEE 1394 storage devices (that use the \"SBP\"br3ak protocol), SAS, iSCSI and FCoE devices (amongst others).br3ak"
SECTION="general"
VERSION=1.42
NAME="sg3_utils"



cd $SOURCE_DIR

URL=http://sg.danny.cz/sg/p/sg3_utils-1.42.tar.xz

if [ ! -z $URL ]
then
wget -nc http://sg.danny.cz/sg/p/sg3_utils-1.42.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/sg3_utils/sg3_utils-1.42.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/sg3_utils/sg3_utils-1.42.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/sg3_utils/sg3_utils-1.42.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/sg3_utils/sg3_utils-1.42.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/sg3_utils/sg3_utils-1.42.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/sg3_utils/sg3_utils-1.42.tar.xz

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

./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
