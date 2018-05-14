#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The GPM (General Purpose Mousebr3ak daemon) package contains a mouse server for the console andbr3ak <span class=\"command\"><strong>xterm</strong>. It not onlybr3ak provides cut and paste support generally, but its library componentbr3ak is used by various software such as Links to provide mouse support to thebr3ak application. It is useful on desktops, especially if followingbr3ak (Beyond) Linux From Scratch instructions; it's often much easierbr3ak (and less error prone) to cut and paste between two console windowsbr3ak than to type everything by hand!br3ak"
SECTION="general"
VERSION=1.20.7
NAME="gpm"



cd $SOURCE_DIR

URL=http://anduin.linuxfromscratch.org/BLFS/gpm/gpm-1.20.7.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://anduin.linuxfromscratch.org/BLFS/gpm/gpm-1.20.7.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gpm/gpm-1.20.7.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gpm/gpm-1.20.7.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gpm/gpm-1.20.7.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gpm/gpm-1.20.7.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gpm/gpm-1.20.7.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gpm/gpm-1.20.7.tar.bz2 || wget -nc ftp://anduin.linuxfromscratch.org/BLFS/gpm/gpm-1.20.7.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/gpm-1.20.7-glibc_2.26-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/gpm/gpm-1.20.7-glibc_2.26-1.patch

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

sed -i -e 's:<gpm.h>:"headers/gpm.h":' src/prog/{display-buttons,display-coords,get-versions}.c &&
patch -Np1 -i ../gpm-1.20.7-glibc_2.26-1.patch &&
./autogen.sh                                &&
./configure --prefix=/usr --sysconfdir=/etc &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install                                          &&
install-info --dir-file=/usr/share/info/dir           \
             /usr/share/info/gpm.info                 &&
ln -sfv libgpm.so.2.1.0 /usr/lib/libgpm.so            &&
install -v -m644 conf/gpm-root.conf /etc              &&
install -v -m755 -d /usr/share/doc/gpm-1.20.7/support &&
install -v -m644    doc/support/*                     \
                    /usr/share/doc/gpm-1.20.7/support &&
install -v -m644    doc/{FAQ,HACK_GPM,README*}        \
                    /usr/share/doc/gpm-1.20.7

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
make install-gpm

cd ..
rm -rf blfs-systemd-units-20180105
popd
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -dm755 /etc/systemd/system/gpm.service.d
echo "ExecStart=/usr/sbin/gpm <list of parameters>" > /etc/systemd/system/gpm.service.d/99-user.conf

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
