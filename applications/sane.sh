#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#OPT:avahi
#OPT:cups
#OPT:libjpeg
#OPT:libusb
#OPT:v4l-utils
#OPT:texlive
#OPT:installing
#OPT:gtk2
#OPT:gimp

cd $SOURCE_DIR

wget -nc http://fossies.org/linux/misc/sane-backends-1.0.27.tar.gz
wget -nc http://anduin.linuxfromscratch.org/BLFS/sane-frontends/sane-frontends-1.0.14.tar.gz

NAME=sane
VERSION=1.0.27
URL=http://fossies.org/linux/misc/sane-backends-1.0.27.tar.gz

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


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
groupadd -g 70 scanner
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

su $(whoami)
./configure --prefix=/usr \
--sysconfdir=/etc \
--localstatedir=/var \
--with-group=scanner \
--with-docdir=/usr/share/doc/sane-backends-1.0.27 &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install &&
install -m 644 -v tools/udev/libsane.rules \
/etc/udev/rules.d/65-scanner.rules &&
chgrp -v scanner /var/lock/sane
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sed -i -e "/SANE_CAP_ALWAYS_SETTABLE/d" src/gtkglue.c &&
./configure --prefix=/usr --mandir=/usr/share/man &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install &&
install -v -m644 doc/sane.png xscanimage-icon-48x48-2.png \
/usr/share/sane
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
ln -v -s ../../../../bin/xscanimage /usr/lib/gimp/2.0/plug-ins
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cat >> /etc/sane.d/net.conf << "EOF"
connect_timeout = 60
<server_ip>
EOF
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
mkdir -pv /usr/share/{applications,pixmaps} &&

cat > /usr/share/applications/xscanimage.desktop << "EOF" &&
[Desktop Entry]
Encoding=UTF-8
Name=XScanImage - Scanning
Comment=Acquire images from a scanner
Exec=xscanimage
Icon=xscanimage
Terminal=false
Type=Application
Categories=Application;Graphics
EOF

ln -svf ../sane/xscanimage-icon-48x48-2.png /usr/share/pixmaps/xscanimage.png
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
