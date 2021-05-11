#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:cmake
#REQ:glib2
#REQ:libgcrypt
#REQ:qt5
#REQ:libpcap


cd $SOURCE_DIR

wget -nc https://www.wireshark.org/download/src/all-versions/wireshark-3.4.5.tar.xz
wget -nc https://www.wireshark.org/download/docs/


NAME=wireshark
VERSION=3.4.5
URL=https://www.wireshark.org/download/src/all-versions/wireshark-3.4.5.tar.xz
SECTION="Networking Utilities"
DESCRIPTION="The Wireshark package contains a network protocol analyzer, also known as a “sniffer”. This is useful for analyzing data captured “off the wire” from a live network connection, or data read from a capture file."

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	if [ $NAME == "firefox" ]; then set +e; fi;
	tar --no-overwrite-dir -xf $TARBALL
	set -e
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

echo $USER > /tmp/currentuser


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
groupadd -g 62 wireshark
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release  \
      -DCMAKE_INSTALL_DOCDIR=/usr/share/doc/wireshark-3.4.5 \
      -G Ninja \
      .. &&
ninja
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install &&

install -v -m755 -d /usr/share/doc/wireshark-3.4.5 &&
install -v -m644    ../README.linux ../doc/README.* ../doc/{*.pod,randpkt.txt} \
                    /usr/share/doc/wireshark-3.4.5 &&

pushd /usr/share/doc/wireshark-3.4.5 &&
   for FILENAME in ../../wireshark/*.html; do
      ln -s -v -f $FILENAME .
   done &&
popd
unset FILENAME
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -m644 <Downloaded_Files> \
                 /usr/share/doc/wireshark-3.4.5
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
chown -v root:wireshark /usr/bin/{tshark,dumpcap} &&
chmod -v 6550 /usr/bin/{tshark,dumpcap}
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
usermod -a -G wireshark $(cat /tmp/currentuser)
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

