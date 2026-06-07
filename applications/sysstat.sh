#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

cd $SOURCE_DIR
NAME=sysstat
VERSION=12.7.9
URL=https://sysstat.github.io/sysstat-packages/sysstat-12.7.9.tar.xz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://sysstat.github.io/sysstat-packages/sysstat-12.7.9.tar.xz


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

sa_lib_dir=/usr/lib/sa    \
sa_dir=/var/log/sa        \
conf_dir=/etc/sysstat     \
./configure --prefix=/usr \
            --disable-file-attr
make
sed -i "/^Also=/d" /usr/lib/systemd/system/sysstat.service
systemctl enable sysstat


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
install -v -m644 sysstat.service /usr/lib/systemd/system/sysstat.service
install -v -m644 cron/sysstat-collect.service /usr/lib/systemd/system/sysstat-collect.service
install -v -m644 cron/sysstat-collect.timer /usr/lib/systemd/system/sysstat-collect.timer
install -v -m644 cron/sysstat-rotate.service /usr/lib/systemd/system/sysstat-rotate.service
install -v -m644 cron/sysstat-rotate.timer /usr/lib/systemd/system/sysstat-rotate.timer
install -v -m644 cron/sysstat-summary.service /usr/lib/systemd/system/sysstat-summary.service
install -v -m644 cron/sysstat-summary.timer /usr/lib/systemd/system/sysstat-summary.timer
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd