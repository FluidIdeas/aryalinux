#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:gnutls
#REQ:cups-filters
#REC:colord
#REC:dbus
#REC:libusb
#REC:linux-pam
#REC:xdg-utils
#OPT:avahi
#OPT:libpaper
#OPT:mitkrb
#OPT:openjdk
#OPT:php
#OPT:python2
#OPT:gutenprint
#OPT:index

cd $SOURCE_DIR

wget -nc https://github.com/apple/cups/releases/download/v2.2.9/cups-2.2.9-source.tar.gz

NAME=cups
VERSION=2.2.9-source
URL=https://github.com/apple/cups/releases/download/v2.2.9/cups-2.2.9-source.tar.gz

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


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
useradd -c "Print Service User" -d /var/spool/cups -g lp -s /bin/false -u 9 lp
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
groupadd -g 19 lpadmin
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
usermod -a -G lpadmin <em class="replaceable"><code><username></code></em>
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

sed -i 's#@CUPS_HTMLVIEW@#firefox#' desktop/cups.desktop.in
sed -i 's:555:755:g;s:444:644:g' Makedefs.in                         &&
sed -i '/MAN.EXT/s:.gz::g' configure config-scripts/cups-manpages.m4 &&

aclocal  -I config-scripts &&
autoconf -I config-scripts &&

CC=gcc \
./configure --libdir=/usr/lib            \
            --with-rcdir=/tmp/cupsinit   \
            --with-system-groups=lpadmin \
            --with-docdir=/usr/share/cups/doc-2.2.9 &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install &&
rm -rf /tmp/cupsinit &&
ln -svnf ../cups/doc-2.2.9 /usr/share/doc/cups-2.2.9
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
echo "ServerName /var/run/cups/cups.sock" > /etc/cups/client.conf
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
gtk-update-icon-cache
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cat > /etc/pam.d/cups << "EOF"
<code class="literal"># Begin /etc/pam.d/cups auth include system-auth account include system-account session include system-session # End /etc/pam.d/cups</code>
EOF
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
systemctl enable org.cups.cupsd
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
