#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

NAME=vscode

SECTION="Programming"
DESCRIPTION="Visual Studio Code is a code editor redefined and optimized for building and debugging modern web and cloud applications"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")


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

wget --content-disposition "https://code.visualstudio.com/sha/download?build=stable&os=linux-x64"
tarball=$(ls code-stable-x64*.tar.gz)
VERSION=$(ls code-stable-x64*.tar.gz | sed "s@code-stable-x64@@g" | sed ".tar.gz@@g")
dir=$(tar tf $tarball | cut -d/ -f1 | uniq)
sudo tar xf $tarball -C /opt/

sudo tee /usr/share/applications/code.desktop <<"EOF"
[Desktop Entry]
Name=Visual Studio Code
Comment=Programming Text Editor
Exec=/opt/VSCode-linux-x64/code
Icon=/opt/VSCode-linux-x64/resources/app/resources/linux/code.png
Terminal=false
Type=Application
Categories=Programming;
EOF


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd
