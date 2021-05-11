#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:harfbuzz
#REQ:giflib
#REQ:gnutls
#REQ:jansson
#REQ:libtiff


cd $SOURCE_DIR

wget -nc https://ftp.gnu.org/gnu/emacs/emacs-27.2.tar.xz
wget -nc ftp://ftp.gnu.org/gnu/emacs/emacs-27.2.tar.xz


NAME=emacs
VERSION=27.2
URL=https://ftp.gnu.org/gnu/emacs/emacs-27.2.tar.xz
SECTION="Editors"
DESCRIPTION="The Emacs package contains an extensible, customizable, self-documenting real-time display editor."

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

echo $USER > /tmp/currentuser


./configure --prefix=/usr &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
chown -v -R root:root /usr/share/emacs/27.2
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

gtk-update-icon-cache -qtf /usr/share/icons/hicolor


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

