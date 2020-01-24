#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:libjpeg


cd $SOURCE_DIR

wget -nc https://github.com/qpdf/qpdf/releases/download/release-qpdf-8.4.2/qpdf-8.4.2.tar.gz


NAME=qpdf
VERSION=8.4.2
URL=https://github.com/qpdf/qpdf/releases/download/release-qpdf-8.4.2/qpdf-8.4.2.tar.gz
SECTION="General Libraries and Utilities"
DESCRIPTION="The Qpdf package contains command-line programs and library that do structural, content-preserving transformations on PDF files."

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


./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/qpdf-8.4.2 &&
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

