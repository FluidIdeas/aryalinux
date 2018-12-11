#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Wireless Extension (WE) is a generic API in the Linux kernelbr3ak allowing a driver to expose configuration and statistics specificbr3ak to common Wireless LANs to user space. A single set of tools canbr3ak support all the variations of Wireless LANs, regardless of theirbr3ak type as long as the driver supports Wireless Extensions. WEbr3ak parameters may also be changed on the fly without restarting thebr3ak driver (or Linux).br3ak"
SECTION="basicnet"
VERSION=29
NAME="wireless_tools"



cd $SOURCE_DIR

URL=https://hewlettpackard.github.io/wireless-tools/wireless_tools.29.tar.gz

if [ ! -z $URL ]
then
wget -nc https://hewlettpackard.github.io/wireless-tools/wireless_tools.29.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/wireless_tools/wireless_tools.29.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/wireless_tools/wireless_tools.29.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/wireless_tools/wireless_tools.29.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/wireless_tools/wireless_tools.29.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/wireless_tools/wireless_tools.29.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/wireless_tools/wireless_tools.29.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/wireless_tools-29-fix_iwlist_scanning-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/wireless_tools/wireless_tools-29-fix_iwlist_scanning-1.patch

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

patch -Np1 -i ../wireless_tools-29-fix_iwlist_scanning-1.patch


make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make PREFIX=/usr INSTALL_MAN=/usr/share/man install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
