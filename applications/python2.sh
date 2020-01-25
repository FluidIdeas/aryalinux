#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

wget -nc https://www.python.org/ftp/python/2.7.16/Python-2.7.16.tar.xz
wget -nc https://docs.python.org/ftp/python/doc/2.7.16/python-2.7.16-docs-html.tar.bz2


NAME=python2
VERSION=2.7.16
URL=https://www.python.org/ftp/python/2.7.16/Python-2.7.16.tar.xz
SECTION="Programming"
DESCRIPTION="The Python 2 package contains the Python development environment. It is useful for object-oriented programming, writing scripts, prototyping large programs or developing entire applications. This version is for backward compatibility with other dependent packages."

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


./configure --prefix=/usr       \
            --enable-shared     \
            --with-system-expat \
            --with-system-ffi   \
            --with-ensurepip=yes \
            --enable-unicode=ucs4 &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
chmod -v 755 /usr/lib/libpython2.7.so.1.0
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -dm755 /usr/share/doc/python-2.7.16 &&

tar --strip-components=1                     \
    --no-same-owner                          \
    --directory /usr/share/doc/python-2.7.16 \
    -xvf ../python-2.7.16-docs-html.tar.bz2 &&

find /usr/share/doc/python-2.7.16 -type d -exec chmod 0755 {} \; &&
find /usr/share/doc/python-2.7.16 -type f -exec chmod 0644 {} \;
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
export PYTHONDOCS=/usr/share/doc/python-2.7.16
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

