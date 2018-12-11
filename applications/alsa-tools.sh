#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The ALSA Tools package containsbr3ak advanced tools for certain sound cards.br3ak"
SECTION="multimedia"
VERSION=1.1.6
NAME="alsa-tools"

#REQ:alsa-lib
#OPT:gtk2
#OPT:gtk3
#OPT:fltk


cd $SOURCE_DIR

URL=ftp://ftp.alsa-project.org/pub/tools/alsa-tools-1.1.6.tar.bz2

if [ ! -z $URL ]
then
wget -nc ftp://ftp.alsa-project.org/pub/tools/alsa-tools-1.1.6.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/alsa-tools/alsa-tools-1.1.6.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/alsa-tools/alsa-tools-1.1.6.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/alsa-tools/alsa-tools-1.1.6.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/alsa-tools/alsa-tools-1.1.6.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/alsa-tools/alsa-tools-1.1.6.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/alsa-tools/alsa-tools-1.1.6.tar.bz2

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

as_root()
{
  if   [ $EUID = 0 ];        then $*
  elif [ -x /usr/bin/sudo ]; then sudo $*
  else                            su -c \\"$*\\"
  fi
}
export -f as_root


rm -rf qlo10k1 Makefile gitcompile


for tool in *
do
  case $tool in
    seq )
      tool_dir=seq/sbiload
    ;;
    * )
      tool_dir=$tool
    ;;
  esac
  pushd $tool_dir
    ./configure --prefix=/usr
    make "-j`nproc`" || make
    as_root make install
    as_root /sbin/ldconfig
  popd
done
unset tool tool_dir




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
