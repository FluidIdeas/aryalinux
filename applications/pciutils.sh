#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The PCI Utils package contains abr3ak set of programs for listing PCI devices, inspecting their statusbr3ak and setting their configuration registers.br3ak"
SECTION="general"
VERSION=3.6.2
NAME="pciutils"



cd $SOURCE_DIR

URL=https://www.kernel.org/pub/software/utils/pciutils/pciutils-3.6.2.tar.xz

if [ ! -z $URL ]
then
wget -nc https://www.kernel.org/pub/software/utils/pciutils/pciutils-3.6.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/pciutils/pciutils-3.6.2.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/pciutils/pciutils-3.6.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/pciutils/pciutils-3.6.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/pciutils/pciutils-3.6.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/pciutils/pciutils-3.6.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/pciutils/pciutils-3.6.2.tar.xz

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

make PREFIX=/usr                \
     SHAREDIR=/usr/share/hwdata \
     SHARED=yes



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make PREFIX=/usr                \
     SHAREDIR=/usr/share/hwdata \
     SHARED=yes                 \
     install install-lib        &&
chmod -v 755 /usr/lib/libpci.so

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /lib/systemd/system/update-pciids.service << "EOF" &&
[Unit]
Description=Update pci.ids file
Documentation=man:update-pciids(8)
DefaultDependencies=no
After=local-fs.target
Before=shutdown.target
[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/sbin/update-pciids
EOF
cat > /lib/systemd/system/update-pciids.timer << "EOF" &&
[Unit]
Description=Update pci.ids file weekly
[Timer]
OnCalendar=Sun 02:30:00
Persistent=true
[Install]
WantedBy=timers.target
EOF
systemctl enable update-pciids.timer

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
