#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:lxde-icon-theme
#REQ:lxpanel
#REQ:lxsession
#REQ:openbox
#REQ:pcmanfm
#REC:desktop-file-utils
#REC:hicolor-icon-theme
#REC:shared-mime-info
#REC:dbus
#OPT:notification-daemon
#OPT:xfce4-notifyd
#OPT:lxdm
#OPT:lightdm

cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/lxde/lxde-common-0.99.2.tar.xz

NAME=lxde-common
VERSION=0.99.2
URL=https://downloads.sourceforge.net/lxde/lxde-common-0.99.2.tar.xz

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

./configure --prefix=/usr --sysconfdir=/etc &&
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
update-mime-database /usr/share/mime &&
gtk-update-icon-cache -qf /usr/share/icons/hicolor &&
update-desktop-database -q
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

cat > ~/.xinitrc << "EOF"
<code class="literal"># No need to run dbus-launch, since it is run by startlxde startlxde</code>
EOF

startx
startx &> ~/.x-session-errors

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
