#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="remmina"
VERSION=SVN
DESCRIPTION="Remmina is a remote desktop client written in GTK+, aiming to be useful for system administrators and travellers, who need to work with lots of remote computers in front of either large monitors or tiny netbooks."

#REQ:avahi
#REQ:libssh
#REQ:libvncserver
#REQ:free-rdp
#REQ:gnome-keyring
#REQ:pulseaudio
#REQ:vte
#REQ:cmake
#REQ:git
#REQ:webkitgtk

cd $SOURCE_DIR
URL="https://github.com/FreeRDP/Remmina/archive/next.zip"
if [ ! -z $(echo $URL | grep "/master.zip$") ] && [ ! -f $NAME-master.zip ]; then
	wget -nc $URL -O $NAME-master.zip
	TARBALL=$NAME-master.zip
elif [ ! -z $(echo $URL | grep "/master.zip$") ] && [ -f $NAME-master.zip ]; then
	echo "Tarball already downloaded. Skipping."
	TARBALL=$NAME-master.zip
else
	wget -nc $URL
	TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
fi
DIRECTORY=$(unzip -l $TARBALL | grep "/" | rev | tr -s " " | cut -d " " -f1 | rev | cut -d/ -f1 | uniq)
unzip -o $TARBALL
cd $DIRECTORY

cmake -DWITH_TELEPATHY=off -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=/opt/remmina_devel/remmina -DWITH_APPINDICATOR=off -DCMAKE_PREFIX_PATH=/opt/remmina_d$
make &&
sudo make install
sudo ln -svf /opt/remmina_devel/remmina/bin/remmina /usr/bin/
sudo ln -svf /opt/remmina_devel/remmina/share/applications/remmina.desktop /usr/share/applications/

cd $SOURCE_DIR
rm -rf $DIRECTORY

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
