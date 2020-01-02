#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:procmail


cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/fetchmail/fetchmail-6.3.26.tar.xz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/2.1/fetchmail-6.3.26-disable_sslv3-1.patch


NAME=fetchmail
VERSION=6.3.26
URL=https://downloads.sourceforge.net/fetchmail/fetchmail-6.3.26.tar.xz
SECTION="Networking"

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


patch -Np1 -i ../fetchmail-6.3.26-disable_sslv3-1.patch &&
./configure --prefix=/usr --with-ssl --enable-fallback=procmail &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

cat > ~/.fetchmailrc << "EOF"
set logfile /var/log/fetchmail.log
set no bouncemail
set postmaster root

poll SERVERNAME :
    user $(cat /tmp/currentuser) pass <password>;
    mda "/usr/bin/procmail -f %F -d %T";
EOF

chmod -v 0600 ~/.fetchmailrc


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

