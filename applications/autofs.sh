#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Autofs controls the operation ofbr3ak the automount daemons. The automount daemons automatically mountbr3ak filesystems when they are accessed and unmount them after a periodbr3ak of inactivity. This is done based on a set of pre-configured maps.br3ak"
SECTION="general"
VERSION=5.1.4
NAME="autofs"

#REQ:libtirpc
#REQ:rpcsvc-proto
#OPT:nfs-utils
#OPT:libxml2
#OPT:mitkrb
#OPT:openldap
#OPT:cyrus-sasl


cd $SOURCE_DIR

URL=https://www.kernel.org/pub/linux/daemons/autofs/v5/autofs-5.1.4.tar.xz

if [ ! -z $URL ]
then
wget -nc https://www.kernel.org/pub/linux/daemons/autofs/v5/autofs-5.1.4.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/autofs/autofs-5.1.4.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/autofs/autofs-5.1.4.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/autofs/autofs-5.1.4.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/autofs/autofs-5.1.4.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/autofs/autofs-5.1.4.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/autofs/autofs-5.1.4.tar.xz

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

./configure --prefix=/         \
            --with-libtirpc    \
            --with-systemd     \            
            --without-openldap \
            --mandir=/usr/share/man &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mv /etc/auto.master /etc/auto.master.bak &&
cat > /etc/auto.master << "EOF"
# Begin /etc/auto.master
/media/auto /etc/auto.misc --ghost
#/home /etc/auto.home
# End /etc/auto.master
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl enable autofs

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
