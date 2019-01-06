#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REC:popt

cd $SOURCE_DIR

wget -nc https://www.samba.org/ftp/rsync/src/rsync-3.1.3.tar.gz

NAME=rsync
VERSION=3.1.3
URL=https://www.samba.org/ftp/rsync/src/rsync-3.1.3.tar.gz

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
groupadd -g 48 rsyncd &&
useradd -c "rsyncd Daemon" -d /home/rsync -g rsyncd \
-s /bin/false -u 48 rsyncd
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

./configure --prefix=/usr --without-included-zlib &&
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
install -v -m755 -d /usr/share/doc/rsync-3.1.3/api &&
install -v -m644 dox/html/* /usr/share/doc/rsync-3.1.3/api
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cat > /etc/rsyncd.conf << "EOF"
<code class="literal"># This is a basic rsync configuration file
# It exports a single module without user authentication.

motd file = /home/rsync/welcome.msg
use chroot = yes

[localhost]
path = /home/rsync
comment = Default rsync module
read only = yes
list = yes
uid = rsyncd
gid = rsyncd
</code>
EOF
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install-rsyncd
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
systemctl stop rsyncd &&
systemctl disable rsyncd &&
systemctl enable rsyncd.socket &&
systemctl start rsyncd.socket
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
