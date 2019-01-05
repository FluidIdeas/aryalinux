#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:linux-pam
#REC:polkit
#OPT:curl
#OPT:cryptsetup
#OPT:git
#OPT:gnutls
#OPT:iptables
#OPT:libgcrypt
#OPT:libidn2
#OPT:libseccomp
#OPT:libxkbcommon
#OPT:make-ca
#OPT:qemu
#OPT:valgrind
#OPT:zsh
#OPT:docbook
#OPT:docbook-xsl
#OPT:libxslt

cd $SOURCE_DIR

wget -nc https://github.com/systemd/systemd/archive/v240/systemd-240.tar.gz

NAME=systemd
VERSION=240
URL=https://github.com/systemd/systemd/archive/v240/systemd-240.tar.gz

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

sed -i 's/GROUP="render", //' rules/50-udev-default.rules.in
mkdir build &&
cd    build &&

meson --prefix=/usr         \
      --sysconfdir=/etc     \
      --localstatedir=/var  \
      -Dblkid=true          \
      -Dbuildtype=release   \
      -Ddefault-dnssec=no   \
      -Dfirstboot=false     \
      -Dinstall-tests=false \
      -Dldconfig=false      \
      -Drootprefix=         \
      -Drootlibdir=/lib     \
      -Dsplit-usr=true      \
      -Dsysusers=false      \
      -Db_lto=false         \
      ..                    &&

ninja

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
systemctl start rescue.target
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
ninja install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
rm -rfv /usr/lib/rpm
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cat >> /etc/pam.d/system-session << "EOF"
<code class="literal"># Begin Systemd addition session required pam_loginuid.so session optional pam_systemd.so # End Systemd addition</code>
EOF

cat > /etc/pam.d/systemd-user << "EOF"
<code class="literal"># Begin /etc/pam.d/systemd-user account required pam_access.so account include system-account session required pam_env.so session required pam_limits.so session required pam_unix.so session required pam_loginuid.so session optional pam_keyinit.so force revoke session optional pam_systemd.so auth required pam_deny.so password required pam_deny.so # End /etc/pam.d/systemd-user</code>
EOF
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
systemctl daemon-reload
systemctl start multi-user.target
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
