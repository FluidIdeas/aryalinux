#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:gtk2
#REQ:qt5
#REQ:libxml2
#REQ:xorg7#xorg-env
#REQ:installing
#REC:mpg123
#OPT:alsa
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
#OPT:libsamplerate

cd $SOURCE_DIR

wget -nc https://distfiles.audacious-media-player.org/audacious-3.10.tar.bz2
wget -nc https://distfiles.audacious-media-player.org/audacious-plugins-3.10.tar.bz2

NAME=audacious
VERSION=3.10.
URL=https://distfiles.audacious-media-player.org/audacious-3.10.tar.bz2

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

TPUT=/bin/true ./configure --prefix=/usr \
                           --with-buildstamp="BLFS" &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

TPUT=/bin/true ./configure --prefix=/usr --disable-wavpack &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
gtk-update-icon-cache &&
update-desktop-database
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cp -v /usr/share/applications/audacious{,-qt}.desktop &&

sed -e '/^Name/ s/$/ Qt/' \
    -e '/Exec=/ s/audacious/& --qt/' \
    -i /usr/share/applications/audacious-qt.desktop
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
