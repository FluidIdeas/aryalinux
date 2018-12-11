#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The libcap package was installedbr3ak in LFS, but if Linux-PAM supportbr3ak is desired, the PAM module must be built (after installation ofbr3ak Linux-PAM).br3ak"
SECTION="postlfs"
VERSION=2.25
NAME="libcap"

#REQ:linux-pam


cd $SOURCE_DIR

URL=https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-2.25.tar.xz

if [ ! -z $URL ]
then
wget -nc https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-2.25.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libcap/libcap-2.25.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libcap/libcap-2.25.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libcap/libcap-2.25.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libcap/libcap-2.25.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libcap/libcap-2.25.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libcap/libcap-2.25.tar.xz

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

make -C pam_cap



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m755 pam_cap/pam_cap.so /lib/security &&
install -v -m644 pam_cap/capability.conf /etc/security

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
