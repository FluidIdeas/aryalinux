#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Audacious is an audio player.br3ak"
SECTION="multimedia"
VERSION=3.9
NAME="audacious"

#REQ:gtk2
#REQ:qt5
#REQ:libxml2
#REQ:xorg-server
#REQ:mpg123
#REC:mpg123
#OPT:dbus
#OPT:gnome-icon-theme
#OPT:valgrind
#OPT:curl
#OPT:faad2
#OPT:ffmpeg
#OPT:flac
#OPT:lame
#OPT:libcdio
#OPT:libnotify
#OPT:libsamplerate
#OPT:libsndfile
#OPT:libvorbis
#OPT:neon
#OPT:pulseaudio
#OPT:sdl


cd $SOURCE_DIR

URL=http://distfiles.audacious-media-player.org/audacious-3.9.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://distfiles.audacious-media-player.org/audacious-3.9.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/audacious/audacious-3.9.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/audacious/audacious-3.9.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/audacious/audacious-3.9.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/audacious/audacious-3.9.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/audacious/audacious-3.9.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/audacious/audacious-3.9.tar.bz2
wget -nc http://distfiles.audacious-media-player.org/audacious-plugins-3.9.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/audacious-plugins/audacious-plugins-3.9.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/audacious-plugins/audacious-plugins-3.9.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/audacious-plugins/audacious-plugins-3.9.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/audacious-plugins/audacious-plugins-3.9.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/audacious-plugins/audacious-plugins-3.9.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/audacious-plugins/audacious-plugins-3.9.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static"


TPUT=/bin/true ./configure --prefix=/usr \
                           --with-buildstamp="BLFS" &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

tar xf audacious-plugins-3.9.tar.bz2
cd `tar -tf audacious-plugins-3.9.tar.bz2 | cut -d/ -f1 | uniq`



TPUT=/bin/true ./configure --prefix=/usr --disable-wavpack &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
gtk-update-icon-cache &&
update-desktop-database

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cp -v /usr/share/applications/audacious{,-qt}.desktop &&
sed -e '/^Name/ s/$/ Qt/' \
    -e '/Exec=/ s/audacious/& --qt/' \
    -i /usr/share/applications/audacious-qt.desktop

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
