#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The LXDM is a lightweight Displaybr3ak Manager for the LXDE desktop. Itbr3ak can also be used as an alternative to other Display Managers suchbr3ak as GNOME's GDM or LightDM.br3ak"
SECTION="x"
VERSION=0.5.3
NAME="lxdm"

#REQ:gtk2
#REQ:iso-codes
#REQ:librsvg
#REC:linux-pam
#OPT:gtk3


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/lxdm/lxdm-0.5.3.tar.xz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/lxdm/lxdm-0.5.3.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lxdm/lxdm-0.5.3.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/lxdm/lxdm-0.5.3.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxdm/lxdm-0.5.3.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxdm/lxdm-0.5.3.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lxdm/lxdm-0.5.3.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lxdm/lxdm-0.5.3.tar.xz

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

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static"

cat > pam/lxdm << "EOF"
# Begin /etc/pam.d/lxdm
auth requisite pam_nologin.so
auth required pam_env.so
auth include system-auth
account include system-account
password include system-password
session required pam_limits.so
session include system-session
# End /etc/pam.d/lxdm
EOF
sed -i 's:sysconfig/i18n:profile.d/i18n.sh:g' data/lxdm.in &&
sed -i 's:/etc/xprofile:/etc/profile:g' data/Xsession &&
sed -e 's/^bg/#&/'        \
    -e '/reset=1/ s/# //' \
    -e 's/logou$/logout/' \
    -e "/arg=/a arg=/usr/bin/X" \
    -i data/lxdm.conf.in


./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --with-pam        \
            --with-systemdsystemunitdir=/lib/systemd/system &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl enable lxdm

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
