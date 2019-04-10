#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions


cd $SOURCE_DIR

wget -nc https://mirrors.tuna.tsinghua.edu.cn/eclipse/technology/epp/downloads/release/2019-03/R/eclipse-java-2019-03-R-linux-gtk-x86_64.tar.gz

NAME=eclipse-ide
VERSION=2019-03
URL=https://mirrors.tuna.tsinghua.edu.cn/eclipse/technology/epp/downloads/release/2019-03/R/eclipse-java-2019-03-R-linux-gtk-x86_64.tar.gz

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

sudo mkdir -pv /opt/eclipse/
sudo mv * /opt/eclipse/
sudo tee /usr/share/applications/eclipse.desktop << EOF
[Desktop Entry]
Encoding=UTF-8
Name=Eclipse IDE
Comment=The Eclipse IDE for Java
GenericName=Java Integrated Development Environment
Exec=/opt/eclipse/eclipse
Terminal=false
Type=Application
Icon=eclipse
Categories=GNOME;GTK;Development;
MimeType=application/xhtml+xml;text/xml;application/xhtml+xml;application/vnd.mozilla.xul+xml;text/mml;x-scheme-handler/http;x-scheme-handler/https;
StartupNotify=true
EOF

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
