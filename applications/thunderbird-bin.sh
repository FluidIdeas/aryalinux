#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="thunderbird-bin"
DESCRIPTION="Thunderbird is a mail client from mozilla. This package simply downloads and installs the most current version of Thunderbird (which is not very current)"
VERSION="latest"

#REQ:curl
#REQ:alsa-lib
#REQ:gtk2
#REQ:unzip
#REQ:yasm
#REQ:zip
#REC:libevent
#REC:libvpx
#REC:nspr
#REC:nss
#REC:sqlite
#OPT:curl
#OPT:cyrus-sasl
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

echo "These are the languages in which thunderbird is available:"
echo ""
wget -O /tmp/langfile https://ftp.mozilla.org/pub/thunderbird/releases/latest/README.txt &> /dev/null
cat /tmp/langfile | grep "lang=" | grep -v "wget" | grep -v "http" | grep -v "For" | tr -s ' ' | sed "s@ (@@g" | rev | cut -d= -f1 | rev | sed "s@lang=@@g" | tr "\n" " " | sed "s@en-GB@en-US en-GB@g"
echo ""
read -p "Enter the language for Thunderbird " LANG
rm /tmp/langfile

else
	LANG="$INSTALL_LANGUAGE"
fi

if [ $(uname -m) == "x86_64" ]
then
	wget -O $SOURCE_DIR/thunderbird.tar.bz2 "https://download.mozilla.org/?product=thunderbird-latest&os=linux64&lang=$LANG"
else
	wget -O $SOURCE_DIR/thunderbird.tar.bz2 "https://download.mozilla.org/?product=thunderbird-latest&os=linux&lang=$LANG"
fi

TARBALL="thunderbird.tar.bz2"
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq`

tar -xf $TARBALL

cd $DIRECTORY

cat > 1434987998846.sh << "ENDOFFILE"
mkdir /opt/thunderbird
cp -rf * /opt/thunderbird

cat > /usr/share/applications/thunderbird.desktop << "EOF"
[Desktop Entry]
Encoding=UTF-8
Name=Thunderbird Mail
Comment=Send and receive mail with Thunderbird
GenericName=Mail Client
Exec=/opt/thunderbird/thunderbird %u
Terminal=false
Type=Application
Icon=thunderbird
Categories=Application;Network;Email;
MimeType=application/xhtml+xml;text/xml;application/xhtml+xml;application/xml;application/rss+xml;x-scheme-handler/mailto;
StartupNotify=true
EOF

for s in 16 22 24 32 48 256
do
install -v -Dm644 /opt/thunderbird/chrome/icons/default/default${s}.png \
                  /usr/share/icons/hicolor/${s}x${s}/apps/thunderbird.png
done &&
gtk-update-icon-cache -qf /usr/share/icons/hicolor &&

unset s

ENDOFFILE
chmod a+x 1434987998846.sh
sudo ./1434987998846.sh
sudo rm -rf 1434987998846.sh


 
cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"
 
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
