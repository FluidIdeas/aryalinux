#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="%DESCRIPTION%"
SECTION="x"
VERSION=20130214
NAME="TTF-and-OTF-fonts"



cd $SOURCE_DIR

URL=http://gsdview.appspot.com/chromeos-localmirror/distfiles/crosextrafonts-20130214.tar.gz

if [ ! -z $URL ]
then
wget -nc http://gsdview.appspot.com/chromeos-localmirror/distfiles/crosextrafonts-20130214.tar.gz
wget -nc http://gsdview.appspot.com/chromeos-localmirror/distfiles/crosextrafonts-carlito-20130920.tar.gz
wget -nc http://download.kde.org/stable/plasma/5.4.3/oxygen-fonts-5.4.3.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/oxygen-fonts/oxygen-fonts-5.4.3.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/oxygen-fonts/oxygen-fonts-5.4.3.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/oxygen-fonts/oxygen-fonts-5.4.3.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/oxygen-fonts/oxygen-fonts-5.4.3.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/oxygen-fonts/oxygen-fonts-5.4.3.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/oxygen-fonts/oxygen-fonts-5.4.3.tar.xz

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


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -d -m755 /usr/share/fonts/dejavu &&
install -v -m644 ttf/*.ttf /usr/share/fonts/dejavu &&
fc-cache -v /usr/share/fonts/dejavu

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
