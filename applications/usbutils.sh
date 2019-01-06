#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:libusb
#REQ:wget
#REQ:python2

cd $SOURCE_DIR

wget -nc https://www.kernel.org/pub/linux/utils/usb/usbutils/usbutils-010.tar.xz

NAME=usbutils
VERSION=010
URL=https://www.kernel.org/pub/linux/utils/usb/usbutils/usbutils-010.tar.xz

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

./configure --prefix=/usr --datadir=/usr/share/hwdata &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
install -dm755 /usr/share/hwdata/ &&
wget http://www.linux-usb.org/usb.ids -O /usr/share/hwdata/usb.ids
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cat > /lib/systemd/system/update-usbids.service << "EOF" &&
<code class="literal">[Unit]
Description=Update usb.ids file
Documentation=man:lsusb(8)
DefaultDependencies=no
After=local-fs.target network-online.target
Before=shutdown.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/wget http://www.linux-usb.org/usb.ids -O /usr/share/hwdata/usb.ids</code>
EOF
cat > /lib/systemd/system/update-usbids.timer << "EOF" &&
<code class="literal">[Unit]
Description=Update usb.ids file weekly

[Timer]
OnCalendar=Sun 03:00:00
Persistent=true

[Install]
WantedBy=timers.target</code>
EOF
systemctl enable update-usbids.timer
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
