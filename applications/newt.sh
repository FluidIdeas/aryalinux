#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:popt
#REQ:slang
#REC:tcl
#REC:gpm
#OPT:python2

cd $SOURCE_DIR

wget -nc https://releases.pagure.org/newt/newt-0.52.20.tar.gz

NAME=newt
VERSION=0.52.20
URL=https://releases.pagure.org/newt/newt-0.52.20.tar.gz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

sed -e 's/^LIBNEWT =/#&/' \
-e '/install -m 644 $(LIBNEWT)/ s/^/#/' \
-e 's/$(LIBNEWT)/$(LIBNEWTSONAME)/g' \
-i Makefile.in &&

./configure --prefix=/usr --with-gpm-support &&
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
