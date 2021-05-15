#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:brotli
#REQ:gs
#REQ:potrace
#REQ:woff2


cd $SOURCE_DIR

NAME=dvisvgm
VERSION=2.11.1
URL=https://github.com/mgieseki/dvisvgm/releases/download/2.11.1/dvisvgm-2.11.1.tar.gz
SECTION="Typesetting"
DESCRIPTION="The dvisvgm package converts DVI, EPS and PDF files to SVG format."


mkdir -pv $NAME
pushd $NAME

wget -nc https://github.com/mgieseki/dvisvgm/releases/download/2.11.1/dvisvgm-2.11.1.tar.gz


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


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ln -svf /opt/texlive/2021/lib/libkpathsea.so /usr/lib
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

autoreconf -fiv                               &&
sed -i 's/python/&3/' tests/Makefile.in       &&
./configure                                    \
 --bindir=/opt/texlive/2021/bin/${TEXARCH}     \
 --mandir=/opt/texlive/2021/texmf-dist/doc/man \
 --with-kpathsea=/opt/texlive/2021            &&
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

popd