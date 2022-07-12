#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

NAME=vscode
VERSION=1657183991

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

version="16.16.0"
wget https://az764295.vo.msecnd.net/stable/92d25e35d9bf1a6b16f7d0758f25d48ace11e5b9/code-stable-x64-$version.tar.gz
dir=$(tar tf code-stable-x64-$version.tar.gz | cut -d/ -f1 | uniq)
sudo tar xf code-stable-x64-$version.tar.gz -C /opt/

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
