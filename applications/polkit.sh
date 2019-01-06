#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:glib2
#REQ:js52
#REQ:systemd
#REC:linux-pam
#OPT:gobject-introspection
#OPT:docbook
#OPT:docbook-xsl
#OPT:gtk-doc
#OPT:libxslt

cd $SOURCE_DIR

wget -nc https://www.freedesktop.org/software/polkit/releases/polkit-0.115.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/polkit-0.115-security_patch-2.patch

NAME=polkit
VERSION=0.115
URL=https://www.freedesktop.org/software/polkit/releases/polkit-0.115.tar.gz

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
groupadd -fg 27 polkitd &&
useradd -c "PolicyKit Daemon Owner" -d /etc/polkit-1 -u 27 \
        -g polkitd -s /bin/false polkitd
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

sed -i "s:/sys/fs/cgroup/systemd/:/sys:g" configure
patch -Np1 -i ../polkit-0.115-security_patch-2.patch
./configure --prefix=/usr                    \
            --sysconfdir=/etc                \
            --localstatedir=/var             \
            --disable-static                 &&
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
cat > /etc/pam.d/polkit-1 << "EOF"
<code class="literal"># Begin /etc/pam.d/polkit-1 auth include system-auth account include system-account password include system-password session include system-session # End /etc/pam.d/polkit-1</code>
EOF
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
