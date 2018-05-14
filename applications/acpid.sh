#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The acpid (Advanced Configurationbr3ak and Power Interface event daemon) is a completely flexible, totallybr3ak extensible daemon for delivering ACPI events. It listens on netlinkbr3ak interface and when an event occurs, executes programs to handle thebr3ak event. The programs it executes are configured through a set ofbr3ak configuration files, which can be dropped into place by packages orbr3ak by the user.br3ak"
SECTION="general"
VERSION=2.0.29
NAME="acpid"



cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/acpid2/acpid-2.0.29.tar.xz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/acpid2/acpid-2.0.29.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/acpid/acpid-2.0.29.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/acpid/acpid-2.0.29.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/acpid/acpid-2.0.29.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/acpid/acpid-2.0.29.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/acpid/acpid-2.0.29.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/acpid/acpid-2.0.29.tar.xz

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

./configure --prefix=/usr \
            --docdir=/usr/share/doc/acpid-2.0.29 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install                         &&
install -v -m755 -d /etc/acpi/events &&
cp -r samples /usr/share/doc/acpid-2.0.29

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/acpi/events/lid << "EOF"
event=button/lid
action=/etc/acpi/lid.sh
EOF
cat > /etc/acpi/lid.sh << "EOF"
#!/bin/sh
/bin/grep -q open /proc/acpi/button/lid/LID/state && exit 0
/usr/sbin/pm-suspend
EOF
chmod +x /etc/acpi/lid.sh

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf

pushd $SOURCE_DIR
wget -nc http://www.linuxfromscratch.org/blfs/downloads/svn/blfs-systemd-units-20180105.tar.bz2
tar xf blfs-systemd-units-20180105.tar.bz2
cd blfs-systemd-units-20180105
make install-acpid

cd ..
rm -rf blfs-systemd-units-20180105
popd
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
