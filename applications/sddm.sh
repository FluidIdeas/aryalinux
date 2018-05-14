#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The SDDM package contains abr3ak lightweight display manager based upon Qt and QML.br3ak"
SECTION="x"
VERSION=0.15.0
NAME="sddm"

#REQ:cmake
#REQ:extra-cmake-modules
#REQ:qt5
#REC:linux-pam
#REC:upower


cd $SOURCE_DIR

URL=https://github.com/sddm/sddm/releases/download/v0.15.0/sddm-0.15.0.tar.xz

if [ ! -z $URL ]
then
wget -nc https://github.com/sddm/sddm/releases/download/v0.15.0/sddm-0.15.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/sddm/sddm-0.15.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/sddm/sddm-0.15.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/sddm/sddm-0.15.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/sddm/sddm-0.15.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/sddm/sddm-0.15.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/sddm/sddm-0.15.0.tar.xz

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


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -g 64 sddm &&
useradd  -c "SDDM Daemon" \
         -d /var/lib/sddm \
         -u 64 -g sddm    \
         -s /bin/false sddm

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release  \
      -Wno-dev .. &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -dm755 -o sddm -g sddm /var/lib/sddm

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


sddm --example-config > sddm.example.conf



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cp -v sddm.example.conf /etc/sddm.conf

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
sed -e '/ServerPath/ s|usr|opt/xorg|' \
    -i.orig /etc/sddm.conf

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
sed -e 's/-nolisten tcp//'\
    -i /etc/sddm.conf

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
sed -e 's/\"none\"/\"on\"/' \
    -i /etc/sddm.conf

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl enable sddm

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/pam.d/sddm << "EOF" &&
# Begin /etc/pam.d/sddm
auth requisite pam_nologin.so
auth required pam_env.so
auth required pam_succeed_if.so uid >= 1000 quiet
auth include system-auth
account include system-account
password include system-password
session required pam_limits.so
session include system-session
# End /etc/pam.d/sddm
EOF
cat > /etc/pam.d/sddm-autologin << "EOF" &&
# Begin /etc/pam.d/sddm-autologin
auth requisite pam_nologin.so
auth required pam_env.so
auth required pam_succeed_if.so uid >= 1000 quiet
auth required pam_permit.so
account include system-account
password required pam_deny.so
session required pam_limits.so
session include system-session
# End /etc/pam.d/sddm-autologin
EOF
cat > /etc/pam.d/sddm-greeter << "EOF"
# Begin /etc/pam.d/sddm-greeter
auth required pam_env.so
auth required pam_permit.so
account required pam_permit.so
password required pam_deny.so
session required pam_unix.so
-session optional pam_systemd.so
# End /etc/pam.d/sddm-greeter
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


sddm-greeter --test-mode --theme <em class="replaceable"><code><theme path></em>



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
echo 'setxkbmap <em class="replaceable"><code>"<your keyboard comma separated list>"</em>' >> \
     /usr/share/sddm/scripts/Xsetup

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
echo "source /etc/profile.d/dircolors.sh" >> /etc/bashrc

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
