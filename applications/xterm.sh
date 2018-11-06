#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak xterm is a terminal emulator forbr3ak the X Window System.br3ak"
SECTION="x"
VERSION=337
NAME="xterm"

#REQ:x7app
#REQ:dejavu-fonts
#OPT:valgrind


cd $SOURCE_DIR

URL=http://invisible-mirror.net/archives/xterm/xterm-337.tgz

if [ ! -z $URL ]
then
wget -nc http://invisible-mirror.net/archives/xterm/xterm-337.tgz

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

sed -i '/v0/{n;s/new:/new:kb=^?:/}' termcap &&
printf '\tkbs=\\177,\n' >> terminfo &&
TERMINFO=/usr/share/terminfo \
./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static     \
    --with-app-defaults=/etc/X11/app-defaults &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install    &&
make install-ti &&
mkdir -pv /usr/share/applications &&
cp -v *.desktop /usr/share/applications/

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/X11/app-defaults/XTerm << "EOF"
*VT100*locale: true
*VT100*faceName: Monospace
*VT100*faceSize: 10
*backarrowKeyIsErase: true
*ptyInitialErase: true
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
