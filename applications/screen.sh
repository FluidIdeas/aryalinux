#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions


cd $SOURCE_DIR

wget -nc https://ftp.gnu.org/gnu/screen/screen-4.6.2.tar.gz
wget -nc ftp://ftp.gnu.org/gnu/screen/screen-4.6.2.tar.gz

NAME=screen
VERSION=4.6.2
URL=https://ftp.gnu.org/gnu/screen/screen-4.6.2.tar.gz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

./configure --prefix=/usr \
--infodir=/usr/share/info \
--mandir=/usr/share/man \
--with-socket-dir=/run/screen \
--with-pty-group=5 \
--with-sys-screenrc=/etc/screenrc &&

sed -i -e "s%/usr/local/etc/screenrc%/etc/screenrc%" {etc,doc}/* &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
install -m 644 etc/etcscreenrc /etc/screenrc
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
