#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:make-ca


cd $SOURCE_DIR

wget -nc https://curl.haxx.se/download/curl-7.76.1.tar.xz


NAME=curl
VERSION=7.76.1
URL=https://curl.haxx.se/download/curl-7.76.1.tar.xz
SECTION="Networking Libraries"
DESCRIPTION="The cURL package contains an utility and a library used for transferring files with URL syntax to any of the following protocols: FTP, FTPS, HTTP, HTTPS, SCP, SFTP, TFTP, TELNET, DICT, LDAP, LDAPS and FILE. Its ability to both download and upload files can be incorporated into other programs to support functions like streaming media."

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


grep -rl '#!.*python$' | xargs sed -i '1s/python/&3/'
./configure --prefix=/usr                           \
            --disable-static                        \
            --enable-threaded-resolver              \
            --with-ca-path=/etc/ssl/certs &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&

rm -rf docs/examples/.deps &&

find docs \( -name Makefile\* -o -name \*.1 -o -name \*.3 \) -exec rm {} \; &&

install -v -d -m755 /usr/share/doc/curl-7.76.1 &&
cp -v -R docs/*     /usr/share/doc/curl-7.76.1
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

