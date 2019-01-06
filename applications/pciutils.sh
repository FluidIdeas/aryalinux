#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REC:curl
#REC:wget
#REC:lynx

cd $SOURCE_DIR

wget -nc https://www.kernel.org/pub/software/utils/pciutils/pciutils-3.6.2.tar.xz

NAME=pciutils
VERSION=3.6.2
URL=https://www.kernel.org/pub/software/utils/pciutils/pciutils-3.6.2.tar.xz

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

make PREFIX=/usr \
SHAREDIR=/usr/share/hwdata \
SHARED=yes

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make PREFIX=/usr \
SHAREDIR=/usr/share/hwdata \
SHARED=yes \
install install-lib &&

chmod -v 755 /usr/lib/libpci.so
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cat > /lib/systemd/system/update-pciids.service << "EOF" &&
<code class="literal">[Unit]
Description=Update pci.ids file
Documentation=man:update-pciids(8)
DefaultDependencies=no
After=local-fs.target network-online.target
Before=shutdown.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/sbin/update-pciids</code>
EOF
cat > /lib/systemd/system/update-pciids.timer << "EOF" &&
<code class="literal">[Unit]
Description=Update pci.ids file weekly

[Timer]
OnCalendar=Sun 02:30:00
Persistent=true

[Install]
WantedBy=timers.target</code>
EOF
systemctl enable update-pciids.timer
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
