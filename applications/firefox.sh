#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:autoconf
#REQ:cbindgen
#REQ:llvm
#REQ:gtk3
#REQ:gtk2
#REQ:libnotify
#REQ:nodejs
#REQ:nss
#REQ:pulseaudio
#REQ:alsa-lib
#REQ:rust
#REQ:unzip
#REQ:yasm
#REQ:zip
#REC:icu
#REC:libevent
#REC:libwebp
#REC:sqlite

cd $SOURCE_DIR



NAME=firefox
VERSION=66.0.source
URL=

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

export LANG=en-US

if [ $(uname -m) == "x86_64" ]
then
	wget -O $SOURCE_DIR/firefox.tar.bz2 "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=$LANG"
else
	wget -O $SOURCE_DIR/firefox.tar.bz2 "https://download.mozilla.org/?product=firefox-latest&os=linux&lang=$LANG"
fi

TARBALL="firefox.tar.bz2"
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq`

sudo tar -xf $TARBALL -C /opt
sudo chmod -R a+rw /opt/firefox

sudo tee /usr/share/applications/firefox.desktop << "EOF" &&
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

for s in 16 32 48 128
do
sudo install -v -Dm644 /opt/firefox/browser/chrome/icons/default/default${s}.png \
                  /usr/share/icons/hicolor/${s}x${s}/apps/firefox.png
done

cd $SOURCE_DIR
rm -rf $DIRECTORY

sudo update-desktop-database
sudo update-mime-database /usr/share/mime

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
