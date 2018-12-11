#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Sysstat package containsbr3ak utilities to monitor system performance and usage activity.br3ak Sysstat contains the <span class=\"command\"><strong>sar</strong> utility, common to manybr3ak commercial Unixes, and tools you can schedule via cron to collectbr3ak and historize performance and activity data.br3ak"
SECTION="general"
VERSION=11.6.5
NAME="sysstat"



cd $SOURCE_DIR

URL=http://perso.wanadoo.fr/sebastien.godard/sysstat-11.6.5.tar.xz

if [ ! -z $URL ]
then
wget -nc http://perso.wanadoo.fr/sebastien.godard/sysstat-11.6.5.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/sysstat/sysstat-11.6.5.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/sysstat/sysstat-11.6.5.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/sysstat/sysstat-11.6.5.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/sysstat/sysstat-11.6.5.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/sysstat/sysstat-11.6.5.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/sysstat/sysstat-11.6.5.tar.xz

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

sa_lib_dir=/usr/lib/sa    \
sa_dir=/var/log/sa        \
conf_dir=/etc/sysconfig   \
./configure --prefix=/usr \
            --disable-file-attr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m644 sysstat.service /lib/systemd/system/sysstat.service

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
sed -i "/^Also=/d" /lib/systemd/system/sysstat.service

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl enable sysstat

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
