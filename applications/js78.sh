#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:autoconf213
#REQ:icu
#REQ:rust
#REQ:which


cd $SOURCE_DIR

wget -nc https://archive.mozilla.org/pub/firefox/releases/78.10.0esr/source/firefox-78.10.0esr.source.tar.xz


NAME=js78
VERSION=78.10.
URL=https://archive.mozilla.org/pub/firefox/releases/78.10.0esr/source/firefox-78.10.0esr.source.tar.xz
SECTION="General Libraries"
DESCRIPTION="JS is Mozilla's JavaScript engine written in C. JS78 is taken from Firefox."

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


if ! grep -ri "/opt/rustc/lib" /etc/ld.so.conf &> /dev/null; then
	echo "/opt/rustc/lib" | sudo tee -a /etc/ld.so.conf
	sudo ldconfig
fi

sudo ldconfig
export PATH=/opt/rustc/bin:$PATH

mkdir obj &&
cd    obj &&

CC=gcc CXX=g++ \
../js/src/configure --prefix=/usr            \
                    --with-intl-api          \
                    --with-system-zlib       \
                    --with-system-icu        \
                    --disable-jemalloc       \
                    --disable-debug-symbols  \
                    --enable-readline        &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
rm -fv /usr/lib/libmozjs-78.so
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
rm -v /usr/lib/libjs_static.ajs &&
sed -i '/@NSPR_CFLAGS@/d' /usr/bin/js78-config
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

