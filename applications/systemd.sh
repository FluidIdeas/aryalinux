#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:linux-pam


cd $SOURCE_DIR

wget -nc https://github.com/systemd/systemd/archive/v247/systemd-247.tar.gz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/4.0/systemd-247-upstream_fixes-1.patch


NAME=systemd
VERSION=247
URL=https://github.com/systemd/systemd/archive/v247/systemd-247.tar.gz
SECTION="System Utilities"
DESCRIPTION="While systemd was installed when building LFS, there are many features provided by the package that were not included in the initial installation because Linux-PAM was not yet installed. The systemd package needs to be rebuilt to provide a working systemd-logind service, which provides many additional features for dependent packages."

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


patch -Np1 -i ../systemd-247-upstream_fixes-1.patch
sed -i 's/GROUP="render"/GROUP="video"/' rules.d/50-udev-default.rules.in
mkdir build &&
cd    build &&

meson --prefix=/usr                 \
      -Dblkid=true                  \
      -Dbuildtype=release           \
      -Ddefault-dnssec=no           \
      -Dfirstboot=false             \
      -Dinstall-tests=false         \
      -Dldconfig=false              \
      -Dman=auto                    \
      -Drootprefix=                 \
      -Drootlibdir=/lib             \
      -Dsplit-usr=true              \
      -Dsysusers=false              \
      -Drpmmacrosdir=no             \
      -Db_lto=false                 \
      -Dhomed=false                 \
      -Duserdb=false                \
      -Dmode=release                \
      -Dpamconfdir=/etc/pam.d       \
      -Ddocdir=/usr/share/doc/systemd-247 \
      ..                            &&

ninja
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
cat >> /etc/pam.d/system-session << "EOF"
# Begin Systemd addition
    
session  required    pam_loginuid.so
session  optional    pam_systemd.so

# End Systemd addition
EOF

cat > /etc/pam.d/systemd-user << "EOF"
# Begin /etc/pam.d/systemd-user

account  required    pam_access.so
account  include     system-account

session  required    pam_env.so
session  required    pam_limits.so
session  required    pam_unix.so
session  required    pam_loginuid.so
session  optional    pam_keyinit.so force revoke
session  optional    pam_systemd.so

auth     required    pam_deny.so
password required    pam_deny.so

# End /etc/pam.d/systemd-user
EOF
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

