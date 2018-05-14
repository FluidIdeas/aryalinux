#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The XScreenSaver is a modularbr3ak screen saver and locker for the X Window System. It is highlybr3ak customizable and allows the use of any program that can draw on thebr3ak root window as a display mode. The purpose of XScreenSaver is to display pretty pictures onbr3ak your screen when it is not in use, in keeping with the philosophybr3ak that unattended monitors should always be doing somethingbr3ak interesting, just like they do in the movies. However, XScreenSaver can also be used as a screenbr3ak locker, to prevent others from using your terminal while you arebr3ak away.br3ak"
SECTION="xsoft"
VERSION=5.39
NAME="xscreensaver"

#REQ:libglade
#REQ:x7app
#REC:glu
#OPT:gdm
#OPT:linux-pam
#OPT:x7legacy


cd $SOURCE_DIR

URL=https://www.jwz.org/xscreensaver/xscreensaver-5.39.tar.gz

if [ ! -z $URL ]
then
wget -nc https://www.jwz.org/xscreensaver/xscreensaver-5.39.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xscreensaver/xscreensaver-5.39.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/xscreensaver/xscreensaver-5.39.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xscreensaver/xscreensaver-5.39.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xscreensaver/xscreensaver-5.39.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xscreensaver/xscreensaver-5.39.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xscreensaver/xscreensaver-5.39.tar.gz

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

./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/pam.d/xscreensaver << "EOF"
# Begin /etc/pam.d/xscreensaver
auth include system-auth
account include system-account
# End /etc/pam.d/xscreensaver
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
