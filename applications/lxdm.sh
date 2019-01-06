#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:gtk2
#REQ:iso-codes
#REQ:librsvg
#REC:linux-pam
#OPT:gtk3

cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/lxdm/lxdm-0.5.3.tar.xz

NAME=lxdm
VERSION=0.5.3
URL=https://downloads.sourceforge.net/lxdm/lxdm-0.5.3.tar.xz

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

cat > pam/lxdm << "EOF"
<code class="literal"># Begin /etc/pam.d/lxdm auth requisite pam_nologin.so auth required pam_env.so auth include system-auth account include system-account password include system-password session required pam_limits.so session include system-session # End /etc/pam.d/lxdm</code>
EOF

sed -i 's:sysconfig/i18n:profile.d/i18n.sh:g' data/lxdm.in &&
sed -i 's:/etc/xprofile:/etc/profile:g' data/Xsession &&
sed -e 's/^bg/#&/'        \
    -e '/reset=1/ s/# //' \
    -e 's/logou$/logout/' \
    -e "/arg=/a arg=$XORG_PREFIX/bin/X" \
    -i data/lxdm.conf.in
./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --with-pam        \
            --with-systemdsystemunitdir=/lib/systemd/system &&
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
systemctl enable lxdm
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
