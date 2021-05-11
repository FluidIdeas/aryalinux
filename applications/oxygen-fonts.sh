#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

wget -nc http://aryalinux.info/files/oxygen-fonts-5.4.3-x86_64.tar.xz


NAME=oxygen-fonts
VERSION=5.4.3
URL=http://aryalinux.info/files/oxygen-fonts-5.4.3-x86_64.tar.xz
DESCRIPTION="The Oxygen typeface family is created as part of the KDE Project, a libre desktop for the GNU+Linux operating system. The design is optimised for the FreeType font rendering system and works well in all graphical user interfaces, desktops and devices."

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	if [ $NAME == "firefox" ]; then set +e; fi;
	tar --no-overwrite-dir -xf $TARBALL
	set -e
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

sudo cp -rv share /usr/
sudo cp -r lib64/* /usr/lib/


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

