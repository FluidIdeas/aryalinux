#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="visual-studio-code"
VERSION="1.26.1"
DESCRIPTION="Visual Studio Code is an open source Code Editor and IDE. The source code is available at https://github.com/Microsoft/vscode"

cd $SOURCE_DIR

URL="https://go.microsoft.com/fwlink/?LinkID=620884"
TARBALL="$NAME-$VERSION.tar.gz"

echo "Downloading..."
wget -q --content-disposition "$URL" -O $TARBALL
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

echo "Installing"
sudo tar xf $TARBALL -C /opt/
sudo ln -svf /opt/$DIRECTORY/resources/app/resources/linux/code.png /usr/share/pixmaps/

sudo tee /etc/profile.d/vscode.sh <<EOF
export PATH=$PATH:/opt/$DIRECTORY
EOF

sudo tee /usr/share/applications/vscode.desktop <<EOF
[Desktop Entry]
Name=Visual Studio Code
GenericName=Visual Studio Code Editor
Comment=Open Source Code Editor
Exec=/opt/$DIRECTORY/code
Icon=code.png
Terminal=false
Encoding=UTF-8
Type=Application
Categories=Development;Debugger;
EOF

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
