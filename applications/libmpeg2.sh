#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions



cd $SOURCE_DIR

wget -nc http://libmpeg2.sourceforge.net/files/libmpeg2-0.5.1.tar.gz
wget -nc ftp://ftp.mirrorservice.org/sites/distfiles.gentoo.org/distfiles/libmpeg2-0.5.1.tar.gz


NAME=libmpeg2
VERSION=0.5.1
URL=http://libmpeg2.sourceforge.net/files/libmpeg2-0.5.1.tar.gz

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


sed -i 's/static const/static/' libmpeg2/idct_mmx.c &&

./configure --prefix=/usr    \
            --enable-shared  \
            --disable-static &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&

install -v -m755 -d /usr/share/doc/mpeg2dec-0.5.1 &&
install -v -m644 README doc/libmpeg2.txt \
                    /usr/share/doc/mpeg2dec-0.5.1
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

