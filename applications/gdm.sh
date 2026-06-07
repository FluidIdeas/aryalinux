#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:accountsservice
#REQ:dconf
#REQ:libcanberra
#REQ:gtk3
#REQ:linux-pam

cd $SOURCE_DIR
NAME=gdm
VERSION=49.2
URL=https://download.gnome.org/sources/gdm/49/gdm-49.2.tar.xz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/gdm/49/gdm-49.2.tar.xz


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

mkdir build
cd    build
meson setup ..             \
      --prefix=/usr        \
      --buildtype=release  \
      -D gdm-xsession=true \
      -D run-dir=/run/gdm
ninja
ln -s /dev/null /etc/udev/rules.d/61-gdm.rules
su gdm -s /bin/bash                                                \
       -c "dbus-run-session                                        \
             gsettings set org.gnome.settings-daemon.plugins.power \
                           sleep-inactive-ac-type                  \
                           nothing"
groupadd -g 21 gdm
useradd -c "GDM Daemon Owner" -d /var/lib/gdm -u 21 \
        -g gdm -s /bin/false gdm
passwd -ql gdm
systemctl enable gdm


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd