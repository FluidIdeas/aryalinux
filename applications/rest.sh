#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:make-ca
#REQ:libsoup
#REQ:gobject-introspection


cd $SOURCE_DIR

wget -nc https://download.gnome.org/sources/rest/0.8/rest-0.8.1.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/rest/0.8/rest-0.8.1.tar.xz


NAME=rest
VERSION=0.8.1
URL=https://download.gnome.org/sources/rest/0.8/rest-0.8.1.tar.xz
SECTION="GNOME Libraries and Desktop"
DESCRIPTION="The rest package contains a library that was designed to make it easier to access web services that claim to be \"RESTful\". It includes convenience wrappers for libsoup and libxml to ease remote use of the RESTful API."

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


./configure --prefix=/usr \
    --with-ca-certificates=/etc/pki/tls/certs/ca-bundle.crt &&
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

