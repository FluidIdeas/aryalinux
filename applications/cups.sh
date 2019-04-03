#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:gnutls
#REC:colord
#REC:dbus
#REC:libusb
#REC:linux-pam
#REC:xdg-utils

cd $SOURCE_DIR

wget -nc https://github.com/apple/cups/releases/download/v2.2.11/cups-2.2.11-source.tar.gz

NAME=cups
VERSION=source
URL=https://github.com/apple/cups/releases/download/v2.2.11/cups-2.2.11-source.tar.gz

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


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
useradd -c "Print Service User" -d /var/spool/cups -g lp -s /bin/false -u 9 lp
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
groupadd -g 19 lpadmin
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sed -i 's#@CUPS_HTMLVIEW@#firefox#' desktop/cups.desktop.in
sed -i 's:555:755:g;s:444:644:g' Makedefs.in &&
sed -i '/MAN.EXT/s:.gz::g' configure config-scripts/cups-manpages.m4 &&

aclocal -I config-scripts &&
autoconf -I config-scripts &&

CC=gcc \
./configure --libdir=/usr/lib \
--with-rcdir=/tmp/cupsinit \
--with-system-groups=lpadmin \
--with-docdir=/usr/share/cups/doc-2.2.11 &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
rm -rf /tmp/cupsinit &&
ln -svnf ../cups/doc-2.2.11 /usr/share/doc/cups-2.2.11
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
echo "ServerName /var/run/cups/cups.sock" > /etc/cups/client.conf
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
gtk-update-icon-cache
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
cat > /etc/pam.d/cups << "EOF"
# Begin /etc/pam.d/cups

auth include system-auth
account include system-account
session include system-session

# End /etc/pam.d/cups
EOF
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
systemctl enable org.cups.cupsd
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo usermod -a -G lpadmin $USER

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
