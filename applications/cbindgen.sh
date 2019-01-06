#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:rust

cd $SOURCE_DIR

wget -nc https://github.com/eqrion/cbindgen/archive/v0.6.6/cbindgen-0.6.6.tar.gz

NAME=cbindgen
VERSION=0.6.6
URL=https://github.com/eqrion/cbindgen/archive/v0.6.6/cbindgen-0.6.6.tar.gz

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

cargo build --release

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
install -Dm755 target/release/cbindgen /usr/bin/
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
