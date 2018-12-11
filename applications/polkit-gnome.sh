#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Polkit GNOME package providesbr3ak an Authentication Agent for Polkitbr3ak that integrates well with the GNOME Desktop environment.br3ak"
SECTION="gnome"
VERSION=0.105
NAME="polkit-gnome"

#REQ:gtk3
#REQ:polkit


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/polkit-gnome/0.105/polkit-gnome-0.105.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/polkit-gnome/0.105/polkit-gnome-0.105.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/polkit-gnome/polkit-gnome-0.105.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/polkit-gnome/polkit-gnome-0.105.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/polkit-gnome/polkit-gnome-0.105.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/polkit-gnome/polkit-gnome-0.105.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/polkit-gnome/polkit-gnome-0.105.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/polkit-gnome/polkit-gnome-0.105.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/polkit-gnome/0.105/polkit-gnome-0.105.tar.xz

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

./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mkdir -p /etc/xdg/autostart &&
cat > /etc/xdg/autostart/polkit-gnome-authentication-agent-1.desktop << "EOF"
[Desktop Entry]
Name=PolicyKit Authentication Agent
Comment=PolicyKit Authentication Agent
Exec=/usr/libexec/polkit-gnome-authentication-agent-1
Terminal=false
Type=Application
Categories= NoDisplay=true
OnlyShowIn=GNOME;XFCE;Unity;
AutostartCondition=GNOME3 unless-session gnome
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
