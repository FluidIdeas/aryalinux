#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:libpng
#REQ:imlib2
#REQ:giflib
#REQ:curl


cd $SOURCE_DIR

wget -nc https://feh.finalrewind.org/feh-3.6.3.tar.bz2


NAME=feh
VERSION=3.6.3
URL=https://feh.finalrewind.org/feh-3.6.3.tar.bz2
SECTION="Other X-based Programs"
DESCRIPTION="feh is a fast, lightweight image viewer which uses Imlib2. It is commandline-driven and supports multiple images through slideshows, thumbnail browsing or multiple windows, and montages or index prints (using TrueType fonts to display file info). Advanced features include fast dynamic zooming, progressive loading, loading via HTTP (with reload support for watching webcams), recursive file opening (slideshow of a directory hierarchy), and mouse wheel/keyboard control."

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


sed -i "s:doc/feh:&-3.6.3:" config.mk &&
make PREFIX=/usr
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make PREFIX=/usr install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

