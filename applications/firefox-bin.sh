#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="firefox-bin"
DESCRIPTION="Firefox is a very popular open source browser that stands for the freedom of internet. This package simply downloads and installs the latest firefox binaries"
VERSION="latest"

#REQ:curl
#REQ:alsa-lib
#REQ:gtk2
#REQ:unzip
#REQ:yasm
#REQ:zip
#REC:icu
#REC:libevent
#REC:libvpx
#REC:nspr
#REC:nss
#REC:sqlite
#OPT:curl
#OPT:dbus-glib
#OPT:doxygen
#OPT:gst-plugins-base
#OPT:gst-plugins-good
#OPT:gst-ffmpeg
#OPT:gst10-plugins-base
#OPT:gst10-plugins-good
#OPT:gst10-libav
#OPT:libnotify
#OPT:openjdk
#OPT:pulseaudio
#OPT:startup-notification
#OPT:wget
#OPT:wireless_tools


cd $SOURCE_DIR

if [ "x$INSTALL_LANGUAGE" == "x" ]; then

echo "These are the languages in which firefox is available:"
echo ""
wget -O /tmp/langfile https://ftp.mozilla.org/pub/firefox/releases/latest/README.txt &> /dev/null
cat /tmp/langfile | grep "lang=" | grep -v "wget" | grep -v "http" | grep -v "For" | tr -s ' ' | sed "s@ (@@g" | rev | cut -d= -f1 | rev | sed "s@lang=@@g" | tr "\n" " " | sed "s@en-GB@en-US en-GB@g"
echo ""
read -p "Enter the language for Firefox " LANG
rm /tmp/langfile

else
	LANG="$INSTALL_LANGUAGE"
fi

if [ $(uname -m) == "x86_64" ]
then
	wget -O $SOURCE_DIR/firefox.tar.bz2 "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=$LANG"
else
	wget -O $SOURCE_DIR/firefox.tar.bz2 "https://download.mozilla.org/?product=firefox-latest&os=linux&lang=$LANG"
fi

TARBALL="firefox.tar.bz2"
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq`

tar -xf $TARBALL

cd $DIRECTORY

cat > 1434987998846.sh << "ENDOFFILE"
mkdir /opt/firefox
cp -rf * /opt/firefox

cat > /usr/share/applications/firefox.desktop << "EOF" &&
[Desktop Entry]
Encoding=UTF-8
Name=Firefox Web Browser
Comment=Browse the World Wide Web
GenericName=Web Browser
Exec=/opt/firefox/firefox %u
Terminal=false
Type=Application
Icon=firefox
Categories=GNOME;GTK;Network;WebBrowser;
MimeType=application/xhtml+xml;text/xml;application/xhtml+xml;application/vnd.mozilla.xul+xml;text/mml;x-scheme-handler/http;x-scheme-handler/https;
StartupNotify=true
EOF

for s in 16 32 48
do
install -v -Dm644 /opt/firefox/browser/chrome/icons/default/default${s}.png \
                  /usr/share/icons/hicolor/${s}x${s}/apps/firefox.png
done &&
install -v -Dm644 /opt/firefox/browser/icons/mozicon128.png \
                  /usr/share/icons/hicolor/128x128/apps/firefox.png
ENDOFFILE
chmod a+x 1434987998846.sh
sudo ./1434987998846.sh
sudo rm -rf 1434987998846.sh


 
cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"
 
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
