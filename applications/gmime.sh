#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:glib2
#REQ:libgpg-error
#REQ:gobject-introspection
#REQ:vala


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gmime/2.6/gmime-2.6.23.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gmime/2.6/gmime-2.6.23.tar.xz


NAME=gmime
VERSION=2.6.23
URL=http://ftp.gnome.org/pub/gnome/sources/gmime/2.6/gmime-2.6.23.tar.xz
SECTION="General Libraries and Utilities"
DESCRIPTION="The GMime package contains a set of utilities for parsing and creating messages using the Multipurpose Internet Mail Extension (MIME) as defined by the applicable RFCs. See the GMime web site for the RFCs resourced. This is useful as it provides an API which adheres to the MIME specification as closely as possible while also providing programmers with an extremely easy to use interface to the API functions."

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


./configure --prefix=/usr --disable-static &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

