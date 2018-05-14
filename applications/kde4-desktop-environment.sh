#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="kde4-desktop-environment"
VERSION="4.11.20"

cd $SOURCE_DIR

whoami > /tmp/currentuser

echo "Which KDE Language pack do you want to install from the following list? If you do not want to install a language pack simply press enter."
echo ""
echo "ar bg bs ca ca@valencia cs da de el en_GB es et eu fa fi fr ga gl he hi hr hu ia id is it ja kk km ko lt lv mr nb nds nl nn pa pl pt pt_BR ro ru sk sl sr sv tr ug uk wa zh_CN zh_TW"
read  LANGPACK
export LANGPACK

export KDE_PREFIX=/usr

yes | alps install automoc4 phonon phonon-backend-gstreamer akonadi attica qimageblitz polkit-qt oxygen-icons kdelibs kfilemetadata kdepimlibs baloo baloo-widgets polkit-kde-agent kactivities kde-runtime kde-baseapps kde-base-artwork kde-workspace #konsole kate ark kmix libkcddb kdepim-runtime kdepim libkexiv2 kdeplasma-addons okular libkcdraw gwenview

if [ ! -f /lib/systemd/system/kdm.service ]
then

cat > rootscript <<EOF1
cat > /lib/systemd/system/kdm.service << EOF &&
[Unit]
Description=K Display Manager
After=systemd-user-sessions.service

[Service]
ExecStart=$KDE_PREFIX/bin/kdm -nodaemon

[Install]
Alias=display-manager.service
EOF
systemctl enable kdm

if [ \$LANGPACK != "" ]
then
	wget kde-l10n-$LANGPACK-4.14.3.tar.xz
	tar xf kde-l10n-$LANGPACK-4.14.3.tar.xz
	cd kde-l10n-$LANGPACK-4.14.3
	cmake -DCMAKE_INSTALL_PREFIX=$KDE_PREFIX &&
	make
	make install
	cd ..
	rm -r kde-l10n-$LANGPACK-4.14.3
fi
EOF1
sudo bash rootscript
rm rootscript

cd $SOURCE_DIR

cleanup "$NAME" "$DIRECTORY"
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
