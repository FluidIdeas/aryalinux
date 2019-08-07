#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

wget -nc https://hewlettpackard.github.io/wireless-tools/wireless_tools.29.tar.gz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/2.0/wireless_tools-29-fix_iwlist_scanning-1.patch


NAME=wireless_tools
VERSION=.29
URL=https://hewlettpackard.github.io/wireless-tools/wireless_tools.29.tar.gz

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

echo $USER > /tmp/currentuser


patch -Np1 -i ../wireless_tools-29-fix_iwlist_scanning-1.patch
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make PREFIX=/usr INSTALL_MAN=/usr/share/man install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

