#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:x7app
#REQ:TTF-and-OTF-fonts#dejavu-fonts
#OPT:valgrind

cd $SOURCE_DIR

wget -nc http://invisible-mirror.net/archives/xterm/xterm-337.tgz

URL=http://invisible-mirror.net/archives/xterm/xterm-337.tgz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

sed -i '/v0/{n;s/new:/new:kb=^?:/}' termcap &&
printf '\tkbs=\\177,\n' >> terminfo &&

TERMINFO=/usr/share/terminfo \
./configure $XORG_CONFIG     \
    --with-app-defaults=/etc/X11/app-defaults &&

make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install    &&
make install-ti &&

mkdir -pv /usr/share/applications &&
cp -v *.desktop /usr/share/applications/
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cat >> /etc/X11/app-defaults/XTerm << "EOF"
<code class="literal">*VT100*locale: true *VT100*faceName: Monospace *VT100*faceSize: 10 *backarrowKeyIsErase: true *ptyInitialErase: true</code>
EOF
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
