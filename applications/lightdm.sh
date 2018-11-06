#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The lightdm package contains abr3ak lightweight display manager based upon GTK.br3ak"
SECTION="x"
VERSION=1.28.0
NAME="lightdm"

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

URL=https://github.com/CanonicalLtd/lightdm/releases/download/1.28.0/lightdm-1.28.0.tar.xz

if [ ! -z $URL ]
then
wget -nc https://github.com/CanonicalLtd/lightdm/releases/download/1.28.0/lightdm-1.28.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lightdm/lightdm-1.28.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/lightdm/lightdm-1.28.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lightdm/lightdm-1.28.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lightdm/lightdm-1.28.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lightdm/lightdm-1.28.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lightdm/lightdm-1.28.0.tar.xz
wget -nc https://launchpad.net/lightdm-gtk-greeter/2.0/2.0.5/+download/lightdm-gtk-greeter-2.0.5.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lightdm/lightdm-gtk-greeter-2.0.5.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/lightdm/lightdm-gtk-greeter-2.0.5.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lightdm/lightdm-gtk-greeter-2.0.5.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lightdm/lightdm-gtk-greeter-2.0.5.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lightdm/lightdm-gtk-greeter-2.0.5.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lightdm/lightdm-gtk-greeter-2.0.5.tar.gz

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
groupadd -g 65 lightdm       &&
useradd  -c "Lightdm Daemon" \
         -d /var/lib/lightdm \
         -u 65 -g lightdm    \
         -s /bin/false lightdm

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


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
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install                                                  &&
cp tests/src/lightdm-session /usr/bin                         &&
sed -i '1 s/sh/bash --login/' /usr/bin/lightdm-session        &&
rm -rf /etc/init                                              &&
install -v -dm755 -o lightdm -g lightdm /var/lib/lightdm      &&
install -v -dm755 -o lightdm -g lightdm /var/lib/lightdm-data &&
install -v -dm755 -o lightdm -g lightdm /var/cache/lightdm    &&
install -v -dm770 -o lightdm -g lightdm /var/log/lightdm

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


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
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf

pushd $SOURCE_DIR
wget -nc http://www.linuxfromscratch.org/blfs/downloads/svn/blfs-systemd-units-20180105.tar.bz2
tar xf blfs-systemd-units-20180105.tar.bz2
cd blfs-systemd-units-20180105
make install-lightdm &&
systemctl enable lightdm

cd ..
rm -rf blfs-systemd-units-20180105
popd
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
