#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Flash Player is a multi-platformbr3ak client runtime to view and interact with SWF content, distributedbr3ak as a browser plugin for both NPAPI (Gecko and WebKit) and PPAPIbr3ak (Blink) based browsers.br3ak"
SECTION="multimedia"
VERSION=86_64
NAME="flashplayer"

#REQ:cairo
#REQ:curl
#REQ:graphite2
#REQ:gtk2
#REQ:libffi
#REQ:pcre
#REQ:mesa
#REQ:nss
#OPT:epiphany
#OPT:firefox
#OPT:libreoffice
#OPT:midori
#OPT:seamonkey
#OPT:thunderbird
#OPT:chromium
#OPT:qupzilla


cd $SOURCE_DIR

URL=https://fpdownload.adobe.com/pub/flashplayer/pdc/26.0.0.151/flash_player_npapi_linux.x86_64.tar.gz

if [ ! -z $URL ]
then
wget -nc https://fpdownload.adobe.com/pub/flashplayer/pdc/26.0.0.151/flash_player_npapi_linux.x86_64.tar.gz
wget -nc https://fpdownload.adobe.com/pub/flashplayer/pdc/26.0.0.151/flash_player_npapi_linux.i386.tar.gz
wget -nc https://fpdownload.adobe.com/pub/flashplayer/pdc/26.0.0.151/flash_player_ppapi_linux.x86_64.tar.gz
wget -nc https://fpdownload.adobe.com/pub/flashplayer/pdc/26.0.0.151/flash_player_ppapi_linux.i386.tar.gz
wget -nc https://github.com/foutrelis/chromium-launcher/archive/v5.tar.gz

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

wget https://github.com/foutrelis/chromium-launcher/archive/v5.tar.gz \
     -O chromium-launcher-v5.tar.gz


mkdir flashplayer &&
cd flashplayer    &&
case $(uname -m) in
    x86_64) tar -xf ../flash_player_npapi_linux.x86_64.tar.gz
    ;;
    i?86)   tar -xf ../flash_player_npapi_linux.i386.tar.gz
    ;;
esac



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -vdm755 /usr/lib/mozilla/plugins &&
install -vm755 libflashplayer.so /usr/lib/mozilla/plugins/libflashplayer.so &&
install -vm755 usr/bin/flash-player-properties /usr/bin &&
install -vm644 usr/share/applications/flash-player-properties.desktop \
               /usr/share/applications &&
for size in 16 22 24 32 48
do
    install -vdm755 usr/share/icons/hicolor/${size}x${size}/apps/ &&
    install -vm644 usr/share/icons/hicolor/${size}x${size}/apps/flash-player-properties.png \
                   /usr/share/icons/hicolor/${size}x${size}/apps
done &&
update-desktop-database

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


mkdir flashplayer &&
cd flashplayer    &&
case $(uname -m) in
    x86_64) tar -xf ../flash_player_ppapi_linux.x86_64.tar.gz
    ;;
    i?86)   tar -xf ../flash_player_ppapi_linux.i386.tar.gz
    ;;
esac



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -vdm755 /usr/lib/PepperFlash &&
install -vDm755 libpepflashplayer.so /usr/lib/PepperFlash/ &&
install -vm644 manifest.json /usr/lib/PepperFlash/

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


tar -xf chromium-launcher-5.tar.gz &&
cd chromium-launcher-5             &&
make PREFIX=/usr



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mv -v /usr/bin/chromium /usr/bin/chromium-orig &&
make PREFIX=/usr install-strip

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
