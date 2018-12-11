#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Sshfs package contains abr3ak filesystem client based on the SSH File Transfer Protocol. This isbr3ak useful for mounting a remote computer that you have ssh access tobr3ak as a local filesystem. This allows you to drag and drop files orbr3ak run shell commands on the remote files as if they were on yourbr3ak local computer.br3ak"
SECTION="postlfs"
VERSION=3.5.0
NAME="sshfs"

#REQ:fuse
#REQ:glib2
#REQ:openssh
#OPT:python-modules#docutils


cd $SOURCE_DIR

URL=https://github.com/libfuse/sshfs/releases/download/sshfs-3.5.0/sshfs-3.5.0.tar.xz

if [ ! -z $URL ]
then
wget -nc https://github.com/libfuse/sshfs/releases/download/sshfs-3.5.0/sshfs-3.5.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/sshfs/sshfs-3.5.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/sshfs/sshfs-3.5.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/sshfs/sshfs-3.5.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/sshfs/sshfs-3.5.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/sshfs/sshfs-3.5.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/sshfs/sshfs-3.5.0.tar.xz

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

if [ $(uname -m) = "i686" ]; then
  export CFLAGS+="-D_FILE_OFFSET_BITS=64";
fi


mkdir build &&
cd    build &&
          
meson --prefix=/usr .. &&
ninja



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ninja install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


sshfs example.com:/home/userid ~/examplepath


fusermount3 -u ~/example




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
