#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

## Individual drivers starts from here... ##


# Start of driver installation #

#OPT:doxygen
#OPT:python2
#OPT:valgrind


cd $SOURCE_DIR

URL=https://www.freedesktop.org/software/libevdev/libevdev-1.5.9.tar.xz

wget -nc https://www.freedesktop.org/software/libevdev/libevdev-1.5.9.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static"

./configure $XORG_CONFIG &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

# End of driver installation #


# Start of driver installation #

#REQ:x7driver
#REQ:mtdev
#REQ:xorg-server


cd $SOURCE_DIR

URL=https://www.x.org/pub/individual/driver/xf86-input-evdev-2.10.6.tar.bz2

wget -nc https://www.x.org/pub/individual/driver/xf86-input-evdev-2.10.6.tar.bz2
wget -nc ftp://ftp.x.org/pub/individual/driver/xf86-input-evdev-2.10.6.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure $XORG_CONFIG &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

# End of driver installation #


# Start of driver installation #

#REQ:x7driver
#REQ:mtdev
#OPT:valgrind
#OPT:doxygen
#OPT:graphviz
#OPT:gtk3
#OPT:libwacom


cd $SOURCE_DIR

URL=https://www.freedesktop.org/software/libinput/libinput-1.12.1.tar.xz

wget -nc https://www.freedesktop.org/software/libinput/libinput-1.12.1.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

mkdir build &&
cd    build &&

meson --prefix=/usr \
      -Dudev-dir=/lib/udev  \
      -Ddebug-gui=false     \
      -Dtests=false         \
      -Ddocumentation=false \
      -Dlibwacom=false      \
      ..                    &&
ninja


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -dm755 /usr/share/doc/libinput-1.12.1 &&
cp -rv html/*     /usr/share/doc/libinput-1.12.1
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

# End of driver installation #


# Start of driver installation #

#REQ:x7driver
#REQ:xorg-server


cd $SOURCE_DIR

URL=https://www.x.org/pub/individual/driver/xf86-input-libinput-0.28.1.tar.bz2

wget -nc https://www.x.org/pub/individual/driver/xf86-input-libinput-0.28.1.tar.bz2
wget -nc ftp://ftp.x.org/pub/individual/driver/xf86-input-libinput-0.28.1.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure $XORG_CONFIG &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

# End of driver installation #


# Start of driver installation #

#REQ:x7driver
#REQ:xorg-server


cd $SOURCE_DIR

URL=https://www.x.org/pub/individual/driver/xf86-input-synaptics-1.9.1.tar.bz2

wget -nc https://www.x.org/pub/individual/driver/xf86-input-synaptics-1.9.1.tar.bz2
wget -nc ftp://ftp.x.org/pub/individual/driver/xf86-input-synaptics-1.9.1.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure $XORG_CONFIG &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

# End of driver installation #


# Start of driver installation #

#REQ:xorg-server


cd $SOURCE_DIR

URL=https://www.x.org/pub/individual/driver/xf86-input-vmmouse-13.1.0.tar.bz2

wget -nc https://www.x.org/pub/individual/driver/xf86-input-vmmouse-13.1.0.tar.bz2
wget -nc ftp://ftp.x.org/pub/individual/driver/xf86-input-vmmouse-13.1.0.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure $XORG_CONFIG               \
            --without-hal-fdi-dir      \
            --without-hal-callouts-dir \
            --with-udev-rules-dir=/lib/udev/rules.d &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

# End of driver installation #


# Start of driver installation #

#REQ:xorg-server
#OPT:doxygen
#OPT:graphviz


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/linuxwacom/xf86-input-wacom-0.36.0.tar.bz2

wget -nc https://downloads.sourceforge.net/linuxwacom/xf86-input-wacom-0.36.0.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure $XORG_CONFIG \
            --with-udev-rules-dir=/lib/udev/rules.d \
            --with-systemd-unit-dir=/lib/systemd/system &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

# End of driver installation #


# Start of driver installation #

#REQ:xorg-server


cd $SOURCE_DIR

URL=https://www.x.org/pub/individual/driver/xf86-video-amdgpu-18.1.0.tar.bz2

wget -nc https://www.x.org/pub/individual/driver/xf86-video-amdgpu-18.1.0.tar.bz2
wget -nc ftp://ftp.x.org/pub/individual/driver/xf86-video-amdgpu-18.1.0.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure $XORG_CONFIG &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

# End of driver installation #


# Start of driver installation #

#REQ:xorg-server


cd $SOURCE_DIR

URL=https://www.x.org/pub/individual/driver/xf86-video-ati-18.1.0.tar.bz2

wget -nc https://www.x.org/pub/individual/driver/xf86-video-ati-18.1.0.tar.bz2
wget -nc ftp://ftp.x.org/pub/individual/driver/xf86-video-ati-18.1.0.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure $XORG_CONFIG &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

# End of driver installation #


# Start of driver installation #

#REQ:xorg-server


cd $SOURCE_DIR

URL=https://www.x.org/pub/individual/driver/xf86-video-fbdev-0.5.0.tar.bz2

wget -nc https://www.x.org/pub/individual/driver/xf86-video-fbdev-0.5.0.tar.bz2
wget -nc ftp://ftp.x.org/pub/individual/driver/xf86-video-fbdev-0.5.0.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure $XORG_CONFIG &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

# End of driver installation #


# Start of driver installation #

#REQ:xcb-util
#REQ:xorg-server


cd $SOURCE_DIR

URL=http://anduin.linuxfromscratch.org/BLFS/xf86-video-intel/xf86-video-intel-20180223.tar.xz

wget -nc http://anduin.linuxfromscratch.org/BLFS/xf86-video-intel/xf86-video-intel-20180223.tar.xz
wget -nc ftp://anduin.linuxfromscratch.org/BLFS/xf86-video-intel/xf86-video-intel-20180223.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./autogen.sh $XORG_CONFIG     \
            --enable-kms-only \
            --enable-uxa      \
            --mandir=/usr/share/man &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
      
mv -v /usr/share/man/man4/intel-virtual-output.4 \
      /usr/share/man/man1/intel-virtual-output.1 &&
      
sed -i '/\.TH/s/4/1/' /usr/share/man/man1/intel-virtual-output.1
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/X11/xorg.conf.d/20-intel.conf << "EOF"
Section "Device"
 Identifier "Intel Graphics"
 Driver "intel"
 #Option "DRI" "2" # DRI3 is default
 #Option "AccelMethod" "sna" # default
 #Option "AccelMethod" "uxa" # fallback
EndSection
EOF
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

# End of driver installation #


# Start of driver installation #

#REQ:xorg-server


cd $SOURCE_DIR

URL=https://www.x.org/pub/individual/driver/xf86-video-nouveau-1.0.15.tar.bz2

wget -nc https://www.x.org/pub/individual/driver/xf86-video-nouveau-1.0.15.tar.bz2
wget -nc ftp://ftp.x.org/pub/individual/driver/xf86-video-nouveau-1.0.15.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure $XORG_CONFIG &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/X11/xorg.conf.d/nvidia.conf << "EOF"
Section "Device"
 Identifier "nvidia"
 Driver "nouveau"
 Option "AccelMethod" "glamor"
EndSection
EOF
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

# End of driver installation #


# Start of driver installation #

#REQ:xorg-server


cd $SOURCE_DIR

URL=https://www.x.org/pub/individual/driver/xf86-video-vmware-13.3.0.tar.bz2

wget -nc https://www.x.org/pub/individual/driver/xf86-video-vmware-13.3.0.tar.bz2
wget -nc ftp://ftp.x.org/pub/individual/driver/xf86-video-vmware-13.3.0.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure $XORG_CONFIG &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

# End of driver installation #


# Start of driver installation #

#REQ:libdrm
#REC:mesa
#OPT:doxygen
#OPT:wayland


cd $SOURCE_DIR

URL=https://github.com/intel/libva/releases/download/2.2.0/libva-2.2.0.tar.bz2

wget -nc https://github.com/intel/libva/releases/download/2.2.0/libva-2.2.0.tar.bz2
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libva/libva-2.2.0.tar.bz2
wget -nc https://github.com/intel/intel-vaapi-driver/releases/download/2.2.0/intel-vaapi-driver-2.2.0.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure $XORG_CONFIG &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


./configure $XORG_CONFIG &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

# End of driver installation #


# Start of driver installation #

#REQ:x7lib
#OPT:doxygen
#OPT:graphviz
#OPT:texlive
#OPT:tl-installer
#OPT:mesa


cd $SOURCE_DIR

URL=https://people.freedesktop.org/~aplattner/vdpau/libvdpau-1.1.1.tar.bz2

wget -nc https://people.freedesktop.org/~aplattner/vdpau/libvdpau-1.1.1.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure $XORG_CONFIG \
            --docdir=/usr/share/doc/libvdpau-1.1.1 &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

# End of driver installation #


# Start of driver installation #

#REQ:cmake
#REQ:ffmpeg
#REQ:x7driver
#OPT:doxygen
#OPT:graphviz
#OPT:texlive
#OPT:tl-installer
#OPT:mesa


cd $SOURCE_DIR

URL=https://github.com/i-rinat/libvdpau-va-gl/archive/v0.4.0/libvdpau-va-gl-0.4.0.tar.gz

wget -nc https://github.com/i-rinat/libvdpau-va-gl/archive/v0.4.0/libvdpau-va-gl-0.4.0.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

mkdir build &&
cd    build &&

cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr .. &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
echo "export VDPAU_DRIVER=va_gl" >> /etc/profile.d/xorg.sh
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

# End of driver installation #

echo "x7driver=>`date`" | sudo tee -a $INSTALLED_LIST

