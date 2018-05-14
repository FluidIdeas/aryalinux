#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:cmake
#REQ:cups
#REQ:wayland
#REQ:pulseaudio

cd $SOURCE_DIR

if [ ! -f FreeRDP.zip ]
then

wget -nc https://github.com/FreeRDP/FreeRDP/archive/master.zip -O FreeRDP.zip

fi
unzip FreeRDP.zip
DIRECTORY=FreeRDP-master

cd $DIRECTORY

cmake -DCMAKE_BUILD_TYPE=Release -DWITH_SSE2=ON -DWITH_CUPS=on -DWITH_WAYLAND=on -DWITH_PULSE=on -DCMAKE_INSTALL_PREFIX:PATH=/opt/remmina_devel/freerdp .
make &&
sudo make install
echo /opt/remmina_devel/freerdp/lib | sudo tee /etc/ld.so.conf.d/freerdp_devel.conf > /dev/null
sudo ldconfig
sudo ln -svf /opt/remmina_devel/freerdp/bin/xfreerdp /usr/bin/

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
