#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REC:make-ca
#OPT:c-ares
#OPT:gnutls
#OPT:libidn2
#OPT:libpsl
#OPT:libssh2
#OPT:mitkrb
#OPT:nghttp2
#OPT:openldap
#OPT:samba
#OPT:stunnel
#OPT:valgrind

cd $SOURCE_DIR

wget -nc https://curl.haxx.se/download/curl-7.63.0.tar.xz

NAME=curl
VERSION=7.63.0
URL=https://curl.haxx.se/download/curl-7.63.0.tar.xz

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

./configure --prefix=/usr \
--disable-static \
--enable-threaded-resolver \
--with-ca-path=/etc/ssl/certs &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install &&

rm -rf docs/examples/.deps &&

find docs \( -name Makefile\* -o -name \*.1 -o -name \*.3 \) -exec rm {} \; &&

install -v -d -m755 /usr/share/doc/curl-7.63.0 &&
cp -v -R docs/* /usr/share/doc/curl-7.63.0
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
