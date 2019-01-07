#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:glib2
#REQ:pcre
#REC:slang
#OPT:doxygen
#OPT:gpm
#OPT:samba
#OPT:unzip
#OPT:installing
#OPT:zip

cd $SOURCE_DIR

wget -nc http://ftp.midnight-commander.org/mc-4.8.22.tar.xz
wget -nc ftp://ftp.osuosl.org/pub/midnightcommander/mc-4.8.22.tar.xz

NAME=mc
VERSION=4.8.22
URL=http://ftp.midnight-commander.org/mc-4.8.22.tar.xz

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
--enable-charset &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
cp -v doc/keybind-migration.txt /usr/share/mc
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
