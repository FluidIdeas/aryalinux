#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gtk2
#REQ:sudo
#REQ:x7lib


cd $SOURCE_DIR

wget -nc http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-8.1p1.tar.gz
wget -nc ftp://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-8.1p1.tar.gz


NAME=ssh-askpass
VERSION=8.
URL=http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-8.1p1.tar.gz

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


cd contrib &&
make gnome-ssh-askpass2
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -d -m755 /usr/libexec/openssh/contrib  &&
install -v -m755    gnome-ssh-askpass2 \
                    /usr/libexec/openssh/contrib  &&
ln -sv -f contrib/gnome-ssh-askpass2 \
                    /usr/libexec/openssh/ssh-askpass
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
cat >> /etc/sudo.conf << "EOF" &&
# Path to askpass helper program
Path askpass /usr/libexec/openssh/ssh-askpass
EOF
chmod -v 0644 /etc/sudo.conf
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

