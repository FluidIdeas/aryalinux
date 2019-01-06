#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:gtk3
#REQ:libgcrypt
#REQ:linux-pam
#REQ:pcre
#REC:gobject-introspection
#REC:libxklavier
#REC:vala
#OPT:at-spi2-core
#OPT:exo
#OPT:gtk-doc
#OPT:itstool
#OPT:qt5

cd $SOURCE_DIR

wget -nc https://github.com/CanonicalLtd/lightdm/releases/download/1.28.0/lightdm-1.28.0.tar.xz
wget -nc https://launchpad.net/lightdm-gtk-greeter/2.0/2.0.5/+download/lightdm-gtk-greeter-2.0.5.tar.gz

NAME=lightdm
VERSION=1.28.0
URL=https://github.com/CanonicalLtd/lightdm/releases/download/1.28.0/lightdm-1.28.0.tar.xz

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
groupadd -g 65 lightdm       &&
useradd  -c "Lightdm Daemon" \
         -d /var/lib/lightdm \
         -u 65 -g lightdm    \
         -s /bin/false lightdm
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

./configure                          \
       --prefix=/usr                 \
       --libexecdir=/usr/lib/lightdm \
       --localstatedir=/var          \
       --sbindir=/usr/bin            \
       --sysconfdir=/etc             \
       --disable-static              \
       --disable-tests               \
       --with-greeter-user=lightdm   \
       --with-greeter-session=lightdm-gtk-greeter \
       --docdir=/usr/share/doc/lightdm-1.28.0 &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install                                                  &&
cp tests/src/lightdm-session /usr/bin                         &&
sed -i '1 s/sh/bash --login/' /usr/bin/lightdm-session        &&
rm -rf /etc/init                                              &&
install -v -dm755 -o lightdm -g lightdm /var/lib/lightdm      &&
install -v -dm755 -o lightdm -g lightdm /var/lib/lightdm-data &&
install -v -dm755 -o lightdm -g lightdm /var/cache/lightdm    &&
install -v -dm770 -o lightdm -g lightdm /var/log/lightdm
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

tar -xf ../lightdm-gtk-greeter-2.0.5.tar.gz &&
cd lightdm-gtk-greeter-2.0.5 &&

./configure                      \
   --prefix=/usr                 \
   --libexecdir=/usr/lib/lightdm \
   --sbindir=/usr/bin            \
   --sysconfdir=/etc             \
   --with-libxklavier            \
   --enable-kill-on-sigterm      \
   --disable-libido              \
   --disable-libindicator        \
   --disable-static              \
   --docdir=/usr/share/doc/lightdm-gtk-greeter-2.0.5 &&

make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install-lightdm &&
systemctl enable lightdm
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
