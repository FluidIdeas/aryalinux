#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:apr-util
#REQ:pcre


cd $SOURCE_DIR

wget -nc https://archive.apache.org/dist/httpd/httpd-2.4.41.tar.bz2
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/2.0/httpd-2.4.41-blfs_layout-1.patch


NAME=apache
VERSION=2.4.41
URL=https://archive.apache.org/dist/httpd/httpd-2.4.41.tar.bz2

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


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
groupadd -g 25 apache &&
useradd -c "Apache Server" -d /srv/www -g apache \
        -s /bin/false -u 25 apache
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

patch -Np1 -i ../httpd-2.4.41-blfs_layout-1.patch             &&

sed '/dir.*CFG_PREFIX/s@^@#@' -i support/apxs.in              &&

./configure --enable-authnz-fcgi                              \
            --enable-layout=BLFS                              \
            --enable-mods-shared="all cgi"                    \
            --enable-mpms-shared=all                          \
            --enable-suexec=shared                            \
            --with-apr=/usr/bin/apr-1-config                  \
            --with-apr-util=/usr/bin/apu-1-config             \
            --with-suexec-bin=/usr/lib/httpd/suexec           \
            --with-suexec-caller=apache                       \
            --with-suexec-docroot=/srv/www                    \
            --with-suexec-logfile=/var/log/httpd/suexec.log   \
            --with-suexec-uidmin=100                          \
            --with-suexec-userdir=public_html                 &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install  &&

mv -v /usr/sbin/suexec /usr/lib/httpd/suexec &&
chgrp apache           /usr/lib/httpd/suexec &&
chmod 4754             /usr/lib/httpd/suexec &&

chown -v -R apache:apache /srv/www
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

pushd $SOURCE_DIR
wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20191026.tar.xz
tar xf blfs-systemd-units-20191026.tar.xz
cd blfs-systemd-units-20191026
sudo make install-httpd
popd
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

