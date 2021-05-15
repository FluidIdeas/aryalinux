#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:cryptsetup
#REQ:glib2
#REQ:gpgme
#REQ:nss
#REQ:swig


cd $SOURCE_DIR

NAME=volume_key
VERSION=0.3.12
URL=https://github.com/felixonmars/volume_key/archive/volume_key-0.3.12.tar.gz
SECTION="Security"
DESCRIPTION="The volume_key package provides a library for manipulating storage volume encryption keys and storing them separately from volumes to handle forgotten passphrases."


mkdir -pv $NAME
pushd $NAME

wget -nc https://github.com/felixonmars/volume_key/archive/volume_key-0.3.12.tar.gz


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


autoreconf -fiv              &&
./configure --prefix=/usr    \
            --without-python &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd