#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:mail
#OPT:linux-pam

cd $SOURCE_DIR

wget -nc http://ftp.debian.org/debian/pool/main/a/at/at_3.1.23.orig.tar.gz

NAME=at
VERSION=""
URL=http://ftp.debian.org/debian/pool/main/a/at/at_3.1.23.orig.tar.gz

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
groupadd -g 17 atd &&
useradd -d /dev/null -c "atd daemon" -g atd -s /bin/false -u 17 atd &&
mkdir -p /var/spool/cron
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sed -i '/docdir/s/=.*/= @docdir@/' Makefile.in
autoreconf
./configure --with-daemon_username=atd \
--with-daemon_groupname=atd \
SENDMAIL=/usr/sbin/sendmail \
--with-systemdsystemunitdir=/lib/systemd/system &&

make -j1

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install \
docdir=/usr/share/doc/at-3.1.23 \
atdocdir=/usr/share/doc/at-3.1.23
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
systemctl enable atd
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
