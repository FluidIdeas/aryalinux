#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The USB Utils package containsbr3ak utilities used to display information about USB buses in the systembr3ak and the devices connected to them.br3ak"
SECTION="general"
VERSION=010
NAME="usbutils"

#REQ:libusb
#REQ:python2


cd $SOURCE_DIR

URL=https://www.kernel.org/pub/linux/utils/usb/usbutils/usbutils-010.tar.xz

if [ ! -z $URL ]
then
wget -nc https://www.kernel.org/pub/linux/utils/usb/usbutils/usbutils-010.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/usbutils/usbutils-010.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/usbutils/usbutils-010.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/usbutils/usbutils-010.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/usbutils/usbutils-010.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/usbutils/usbutils-010.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/usbutils/usbutils-010.tar.xz

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

./configure --prefix=/usr --datadir=/usr/share/hwdata &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -dm755 /usr/share/hwdata/ &&
pushd /var/cache/alps/sources/ && wget -nc http://www.linux-usb.org/usb.ids && cp -v usb.ids /usr/share/hwdata/usb.ids && popd

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /lib/systemd/system/update-usbids.service << "EOF" &&
[Unit]
Description=Update usb.ids file
Documentation=man:lusub(8)
DefaultDependencies=no
After=local-fs.target
Before=shutdown.target
[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/pushd /var/cache/alps/sources/ && wget -nc http://www.linux-usb.org/usb.ids && cp -v usb.ids /usr/share/hwdata/usb.ids && popd
EOF
cat > /lib/systemd/system/update-usbids.timer << "EOF" &&
[Unit]
Description=Update usb.ids file weekly
[Timer]
OnCalendar=Sun 03:00:00
Persistent=true
[Install]
WantedBy=timers.target
EOF
systemctl enable update-usbids.timer

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
