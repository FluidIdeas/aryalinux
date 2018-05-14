#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak While systemd was installed whenbr3ak building LFS, there are many features provided by the package thatbr3ak were not included in the initial installation because Linux-PAM was not yet installed. Thebr3ak systemd package needs to bebr3ak rebuilt to provide a working <span class=\"command\"><strong>systemd-logind</strong> service, whichbr3ak provides many additional features for dependent packages.br3ak"
SECTION="general"
VERSION=238
NAME="systemd"

#REQ:linux-pam
#REC:polkit
#OPT:make-ca
#OPT:curl
#OPT:gnutls
#OPT:iptables
#OPT:libgcrypt
#OPT:libidn2
#OPT:libseccomp
#OPT:libxkbcommon
#OPT:qemu
#OPT:valgrind
#OPT:zsh
#OPT:docbook
#OPT:docbook-xsl
#OPT:libxslt


cd $SOURCE_DIR

URL=https://github.com/systemd/systemd/archive/v238/systemd-238.tar.gz

if [ ! -z $URL ]
then
wget -nc https://github.com/systemd/systemd/archive/v238/systemd-238.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/systemd/systemd-238.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/systemd/systemd-238.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/systemd/systemd-238.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/systemd/systemd-238.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/systemd/systemd-238.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/systemd/systemd-238.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/systemd-238-upstream_fixes-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/systemd/systemd-238-upstream_fixes-1.patch
wget -nc  https://raw.githubusercontent.com/FluidIdeas/patches/1.0/238-libmount-include.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

patch -Np1 -i ../systemd-238-upstream_fixes-1.patch
patch -Np1 -i ../238-libmount-include.patch

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



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ninja install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
rm -rfv /usr/lib/rpm

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/pam.d/system-session << "EOF"
# Begin Systemd addition
 
session required pam_loginuid.so
session optional pam_systemd.so
# End Systemd addition
EOF
cat > /etc/pam.d/systemd-user << "EOF"
# Begin /etc/pam.d/systemd-user
account required pam_access.so
account include system-account
session required pam_env.so
session required pam_limits.so
session include system-session
auth required pam_deny.so
password required pam_deny.so
# End /etc/pam.d/systemd-user
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
