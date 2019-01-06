#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:libwnck2
#REQ:libxfce4ui
#REQ:which
#REQ:x7app
#REQ:xfdesktop
#REC:desktop-file-utils
#REC:shared-mime-info
#REC:polkit-gnome

cd $SOURCE_DIR

wget -nc http://archive.xfce.org/src/xfce/xfce4-session/4.12/xfce4-session-4.12.1.tar.bz2

NAME=xfce4-session
VERSION=4.12.1.
URL=http://archive.xfce.org/src/xfce/xfce4-session/4.12/xfce4-session-4.12.1.tar.bz2

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

./configure --prefix=/usr \
            --sysconfdir=/etc \
            --disable-legacy-sm &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
update-desktop-database &&
update-mime-database /usr/share/mime
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

cat > ~/.xinitrc << "EOF"
<code class="literal">dbus-launch --exit-with-session startxfce4</code>
EOF

startx
startx &> ~/.x-session-errors

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
