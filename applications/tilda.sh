#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="tilda"
DESCRIPTION="Tilda is a terminal emulator and can be compared with other popular terminal emulators such as gnome-terminal (Gnome), Konsole (KDE), xterm and many others."
VERSION="1.3.3"

#REQ:vte
#REQ:libconfuse

cd $SOURCE_DIR

URL=https://github.com/lanoxx/tilda/archive/tilda-1.3.3.tar.gz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)

wget -nc $URL
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

./autogen.sh --prefix=/usr &&
./configure --prefix=/usr &&
make "-j$(nproc)"
sudo make install

cd $SOURCE_DIR
rm -r $DIRECTORY

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
