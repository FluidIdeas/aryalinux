#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:glib2
#REQ:libgcrypt
#REC:libpcap
#REC:qt5
#OPT:c-ares
#OPT:gnutls
#OPT:gtk3
#OPT:gtk2
#OPT:libnl
#OPT:lua
#OPT:mitkrb
#OPT:nghttp2
#OPT:sbc

cd $SOURCE_DIR

wget -nc https://www.wireshark.org/download/src/all-versions/wireshark-2.6.5.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/wireshark-2.6.5-lua_5_3-1.patch

NAME=wireshark
VERSION=2.6.5
URL=https://www.wireshark.org/download/src/all-versions/wireshark-2.6.5.tar.xz

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


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
groupadd -g 62 wireshark
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

patch -Np1 -i ../wireshark-2.6.5-lua_5_3-1.patch &&

./configure --prefix=/usr --sysconfdir=/etc &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&

install -v -m755 -d /usr/share/doc/wireshark-2.6.5 &&
install -v -m644 README.linux doc/README.* doc/*.{pod,txt} \
/usr/share/doc/wireshark-2.6.5 &&

pushd /usr/share/doc/wireshark-2.6.5 &&
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
install -v -m644 <em class="replaceable"><code><Downloaded_Files></code></em> \
/usr/share/doc/wireshark-2.6.5
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
usermod -a -G wireshark <username>
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
