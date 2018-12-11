#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:gtk3
#REQ:polkit

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/polkit-gnome/0.105/polkit-gnome-0.105.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/polkit-gnome/0.105/polkit-gnome-0.105.tar.xz

URL=http://ftp.gnome.org/pub/gnome/sources/polkit-gnome/0.105/polkit-gnome-0.105.tar.xz

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

./configure --prefix=/usr &&
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
mkdir -p /etc/xdg/autostart &&
cat > /etc/xdg/autostart/polkit-gnome-authentication-agent-1.desktop << "EOF"
<code class="literal">[Desktop Entry] Name=PolicyKit Authentication Agent Comment=PolicyKit Authentication Agent Exec=/usr/libexec/polkit-gnome-authentication-agent-1 Terminal=false Type=Application Categories= NoDisplay=true OnlyShowIn=GNOME;XFCE;Unity; AutostartCondition=GNOME3 unless-session gnome</code>
EOF
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
