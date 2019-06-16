#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions



cd $SOURCE_DIR

wget -nc http://www.jedsoft.org/releases/slang/slang-2.3.2.tar.bz2


NAME=slang
VERSION=2.3.2
URL=http://www.jedsoft.org/releases/slang/slang-2.3.2.tar.bz2

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
            --sysconfdir=/etc \
            --with-readline=gnu &&
make -j1
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install_doc_dir=/usr/share/doc/slang-2.3.2   \
     SLSH_DOC_DIR=/usr/share/doc/slang-2.3.2/slsh \
     install-all &&

chmod -v 755 /usr/lib/libslang.so.2.3.2 \
             /usr/lib/slang/v2/modules/*.so
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

