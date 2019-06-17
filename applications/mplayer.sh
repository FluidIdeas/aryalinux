#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:yasm
#REQ:gtk2
#REQ:libvdpau-va-gl


cd $SOURCE_DIR

wget -nc http://www.mplayerhq.hu/MPlayer/releases/MPlayer-1.4.tar.xz
wget -nc ftp://ftp.mplayerhq.hu/MPlayer/releases/MPlayer-1.4.tar.xz
wget -nc https://www.mplayerhq.hu/MPlayer/skins/Clearlooks-2.0.tar.bz2
wget -nc ftp://ftp.mplayerhq.hu/MPlayer/skins/Clearlooks-2.0.tar.bz2
wget -nc https://www.mplayerhq.hu/MPlayer/skins/


NAME=mplayer
VERSION=1.4
URL=http://www.mplayerhq.hu/MPlayer/releases/MPlayer-1.4.tar.xz

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


./configure --prefix=/usr            \
            --confdir=/etc/mplayer   \
            --enable-dynamic-plugins \
            --enable-menu            \
            --enable-gui             &&
make
make doc
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install  &&
ln -svf ../icons/hicolor/48x48/apps/mplayer.png \
        /usr/share/pixmaps/mplayer.png
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -m755 -d /usr/share/doc/mplayer-1.4 &&
install -v -m644    DOCS/HTML/en/* \
                    /usr/share/doc/mplayer-1.4
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -m644 etc/codecs.conf /etc/mplayer
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -m644 etc/*.conf /etc/mplayer
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
gtk-update-icon-cache -qtf /usr/share/icons/hicolor &&
update-desktop-database -q
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
tar -xvf  ../Clearlooks-2.0.tar.bz2 \
    -C    /usr/share/mplayer/skins &&
ln  -sfvn Clearlooks /usr/share/mplayer/skins/default
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

