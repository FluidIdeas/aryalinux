#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

cd $SOURCE_DIR
NAME=gpm
VERSION=1.20.7
URL=https://anduin.linuxfromscratch.org/BLFS/gpm/gpm-1.20.7.tar.bz2
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://anduin.linuxfromscratch.org/BLFS/gpm/gpm-1.20.7.tar.bz2


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

patch -Np1 -i ../gpm-1.20.7-consolidated-1.patch
patch -Np1 -i ../gpm-1.20.7-gcc15_fixes-1.patch
./autogen.sh
./configure --prefix=/usr --sysconfdir=/etc ac_cv_path_emacs=no
make
make -C doc gpm.{dvi,ps}
dvipdfm doc/gpm.dvi -o doc/gpm.pdf
cat > /etc/systemd/system/gpm.service.d/99-user.conf << EOF
[Service]
ExecStart=
ExecStart=/usr/sbin/gpm <list of parameters>
EOF
install-info --dir-file=/usr/share/info/dir           \
             /usr/share/info/gpm.info
rm -fv /usr/lib/libgpm.a
ln -sfv libgpm.so.2.1.0 /usr/lib/libgpm.so


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -dm755 /etc/systemd/system/gpm.service.d
make install
install -v -m644 conf/gpm-root.conf /etc
install -v -m755 -d /usr/share/doc/gpm-1.20.7/support
install -v -m644    doc/support/*                     \
                    /usr/share/doc/gpm-1.20.7/support
install -v -m644    doc/{FAQ,HACK_GPM,README*}        \
                    /usr/share/doc/gpm-1.20.7
install -vm644 doc/gpm.{dvi,ps,pdf} /usr/share/doc/gpm-1.20.7
make install-gpm
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd