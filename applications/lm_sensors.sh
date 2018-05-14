#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The lm_sensors package providesbr3ak user-space support for the hardware monitoring drivers in the Linuxbr3ak kernel. This is useful for monitoring the temperature of the CPUbr3ak and adjusting the performance of some hardware (such as coolingbr3ak fans).br3ak"
SECTION="general"
VERSION=3.4.0
NAME="lm_sensors"

#REQ:general_which


cd $SOURCE_DIR

URL=https://ftp.gwdg.de/pub/linux/misc/lm-sensors/lm_sensors-3.4.0.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://ftp.gwdg.de/pub/linux/misc/lm-sensors/lm_sensors-3.4.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lmsensors/lm_sensors-3.4.0.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/lmsensors/lm_sensors-3.4.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lmsensors/lm_sensors-3.4.0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lmsensors/lm_sensors-3.4.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lmsensors/lm_sensors-3.4.0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lmsensors/lm_sensors-3.4.0.tar.bz2 || wget -nc ftp://ftp.gwdg.de/pub/linux/misc/lm-sensors/lm_sensors-3.4.0.tar.bz2

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

make PREFIX=/usr        \
     BUILD_STATIC_LIB=0 \
     MANDIR=/usr/share/man



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make PREFIX=/usr        \
     BUILD_STATIC_LIB=0 \
     MANDIR=/usr/share/man install &&
install -v -m755 -d /usr/share/doc/lm_sensors-3.4.0 &&
cp -rv              README INSTALL doc/* \
                    /usr/share/doc/lm_sensors-3.4.0

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
