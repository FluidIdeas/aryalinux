#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf


cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/infozip/unzip60.tar.gz
wget -nc ftp://ftp.info-zip.org/pub/infozip/src/unzip60.tgz

NAME=unzip
VERSION=""
URL=https://downloads.sourceforge.net/infozip/unzip60.tar.gz

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

convmv -f iso-8859-1 -t cp850 -r --nosmart --notest \
<em class="replaceable"><code></path/to/unzipped/files></code></em>
convmv -f cp866 -t koi8-r -r --nosmart --notest \
<em class="replaceable"><code></path/to/unzipped/files></code></em>
make -f unix/Makefile generic

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make prefix=/usr MANDIR=/usr/share/man/man1 \
-f unix/Makefile install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
