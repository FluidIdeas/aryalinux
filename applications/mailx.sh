#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

cd $SOURCE_DIR
NAME=mailx
VERSION=12.5
URL=https://anduin.linuxfromscratch.org/BLFS/mailx/heirloom-mailx_12.5.orig.tar.gz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://anduin.linuxfromscratch.org/BLFS/mailx/heirloom-mailx_12.5.orig.tar.gz


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

patch -Np1 -i ../heirloom-mailx-12.5-fixes-1.patch
sed 's@<openssl@<openssl-1.0/openssl@' \
    -i openssl.c fio.c makeconfig
make -j1 LDFLAGS+="-L /usr/lib/openssl/" \
         SENDMAIL=/usr/sbin/sendmail
echo "set PAGER=<more|less>" >> /etc/nail.rc
echo "set PAGER=<more|less>" >> ~/.mailrc
echo "set EDITOR=<vim|nano|...>" >> /etc/nail.rc
echo "set MAILDIR=Maildir" >> /etc/nail.rc
make PREFIX=/usr UCBINSTALL=/usr/bin/install install
ln -v -sf mailx /usr/bin/mail
ln -v -sf mailx /usr/bin/nail


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -m755 -d     /usr/share/doc/heirloom-mailx-12.5
install -v -m644 README /usr/share/doc/heirloom-mailx-12.5
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd