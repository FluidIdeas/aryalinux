#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:exo
#REQ:libgcrypt
#REQ:linux-pam
#REQ:glib2
#REQ:libxklavier

cd $SOURCE_DIR
NAME=lightdm
VERSION=1.32.0
URL=https://github.com/CanonicalLtd/lightdm/releases/download/1.32.0/lightdm-1.32.0.tar.xz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://github.com/CanonicalLtd/lightdm/releases/download/1.32.0/lightdm-1.32.0.tar.xz


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

./configure --prefix=/usr                 \
            --libexecdir=/usr/lib/lightdm \
            --localstatedir=/var          \
            --sbindir=/usr/bin            \
            --sysconfdir=/etc             \
            --disable-static              \
            --disable-tests               \
            --with-greeter-user=lightdm   \
            --with-greeter-session=lightdm-gtk-greeter \
            --docdir=/usr/share/doc/lightdm-1.32.0
make
tar -xf ../lightdm-gtk-greeter-2.0.9.tar.gz
cd lightdm-gtk-greeter-2.0.9
./configure --prefix=/usr                 \
            --libexecdir=/usr/lib/lightdm \
            --sbindir=/usr/bin            \
            --sysconfdir=/etc             \
            --with-libxklavier            \
            --enable-kill-on-sigterm      \
            --disable-libido              \
            --disable-libindicator        \
            --disable-static              \
            --disable-maintainer-mode     \
            --docdir=/usr/share/doc/lightdm-gtk-greeter-2.0.9
make
ln -sf /opt/xorg/bin/Xorg /usr/bin/X
groupadd -g 65 lightdm
useradd  -c "Lightdm Daemon" \
         -d /var/lib/lightdm \
         -u 65 -g lightdm    \
         -s /bin/false lightdm
cp tests/src/lightdm-session /usr/bin
sed -i '1 s/sh/bash --login/' /usr/bin/lightdm-session
rm -rf /etc/init


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
install -v -dm755 -o lightdm -g lightdm /var/lib/lightdm
install -v -dm755 -o lightdm -g lightdm /var/lib/lightdm-data
install -v -dm755 -o lightdm -g lightdm /var/cache/lightdm
install -v -dm770 -o lightdm -g lightdm /var/log/lightdm
make install
make install-lightdm
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd