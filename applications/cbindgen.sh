#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:rust


cd $SOURCE_DIR

wget -nc https://github.com/eqrion/cbindgen/archive/v0.13.1/cbindgen-0.13.1.tar.gz


NAME=cbindgen
VERSION=0.13.1
URL=https://github.com/eqrion/cbindgen/archive/v0.13.1/cbindgen-0.13.1.tar.gz
SECTION="Programming"
DESCRIPTION="Cbindgen can be used to generate C bindings for Rust code."

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

echo $USER > /tmp/currentuser


if ! grep -ri "/opt/rustc/lib" /etc/ld.so.conf &> /dev/null; then
	echo "/opt/rustc/lib" | sudo tee -a /etc/ld.so.conf
	sudo ldconfig
fi

sudo ldconfig
. /etc/profile.d/rustc.sh

cargo build --release
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -Dm755 target/release/cbindgen /usr/bin/
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

