#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:yasm
#REC:gtk2
#REC:libvdpau-va-gl
#OPT:cdparanoia
#OPT:libdvdread
#OPT:libdvdcss
#OPT:samba
#OPT:libbluray
#OPT:alsa
#OPT:pulseaudio
#OPT:sdl
#OPT:nas
#OPT:aalib
#OPT:giflib
#OPT:libjpeg
#OPT:libpng
#OPT:faac
#OPT:faad2
#OPT:libdv
#OPT:libmad
#OPT:libmpeg2
#OPT:libtheora
#OPT:libvpx
#OPT:lzo
#OPT:mpg123
#OPT:speex
#OPT:fontconfig
#OPT:freetype2
#OPT:fribidi
#OPT:gnutls
#OPT:opus
#OPT:unrar
#OPT:libxslt
#OPT:docbook
#OPT:docbook-xsl

cd $SOURCE_DIR

wget -nc http://www.mplayerhq.hu/MPlayer/releases/MPlayer-1.3.0.tar.xz
wget -nc ftp://ftp.mplayerhq.hu/MPlayer/releases/MPlayer-1.3.0.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/MPlayer-1.3.0-x264_fix-1.patch
wget -nc https://www.mplayerhq.hu/MPlayer/skins/Clearlooks-2.0.tar.bz2
wget -nc ftp://ftp.mplayerhq.hu/MPlayer/skins/Clearlooks-2.0.tar.bz2

NAME=mplayer
VERSION=1.3.0
URL=http://www.mplayerhq.hu/MPlayer/releases/MPlayer-1.3.0.tar.xz

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

patch -Np0 -i ../MPlayer-1.3.0-x264_fix-1.patch &&

./configure --prefix=/usr \
--confdir=/etc/mplayer \
--enable-dynamic-plugins \
--enable-menu \
--enable-gui &&
make
make doc

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
ln -svf ../icons/hicolor/48x48/apps/mplayer.png \
/usr/share/pixmaps/mplayer.png
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -m755 -d /usr/share/doc/mplayer-1.3.0 &&
install -v -m644 DOCS/HTML/en/* \
/usr/share/doc/mplayer-1.3.0
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
gtk-update-icon-cache &&
update-desktop-database
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
tar -xvf ../Clearlooks-2.0.tar.bz2 \
-C /usr/share/mplayer/skins &&
ln -sfvn Clearlooks /usr/share/mplayer/skins/default
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
