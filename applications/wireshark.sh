#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:cmake
#REQ:c-ares
#REQ:libgcrypt
#REQ:speex
#REQ:libpcap

cd $SOURCE_DIR
NAME=wireshark
VERSION=4.6.3
URL=https://www.wireshark.org/download/src/all-versions/wireshark-4.6.3.tar.xz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://www.wireshark.org/download/src/all-versions/wireshark-4.6.3.tar.xz


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

mkdir build
cd    build
cmake -D CMAKE_INSTALL_PREFIX=/usr \
      -D CMAKE_BUILD_TYPE=Release  \
      -D CMAKE_INSTALL_DOCDIR=/usr/share/doc/wireshark-4.6.3 \
      -G Ninja \
      ..
ninja
groupadd -g 62 wireshark
pushd /usr/share/doc/wireshark-4.6.3
for FILENAME in ../../wireshark/*.html; do
      ln -s -v -f $FILENAME .
   done
popd
unset FILENAME
chown -v root:wireshark /usr/bin/tshark
chmod -v 6550 /usr/bin/tshark
usermod -a -G wireshark <username>


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
install -v -m755 -d /usr/share/doc/wireshark-4.6.3
install -v -m644    ../README.linux ../doc/README.* ../doc/randpkt.txt \
                    /usr/share/doc/wireshark-4.6.3
install -v -m644 <Downloaded_Files> \
                 /usr/share/doc/wireshark-4.6.3
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd