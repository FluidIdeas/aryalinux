#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The lxqt-l10n package providesbr3ak translations for all components of the LXQt desktop.br3ak"
SECTION="lxqt"
VERSION=0.12.0
NAME="lxqt-l10n"

#REQ:liblxqt


cd $SOURCE_DIR

URL=https://github.com/lxde/lxqt-l10n/releases/download/0.12.0/lxqt-l10n-0.12.0.tar.xz

if [ ! -z $URL ]
then
wget -nc https://github.com/lxde/lxqt-l10n/releases/download/0.12.0/lxqt-l10n-0.12.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lxqt-l10n/lxqt-l10n-0.12.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/lxqt-l10n/lxqt-l10n-0.12.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxqt-l10n/lxqt-l10n-0.12.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxqt-l10n/lxqt-l10n-0.12.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lxqt-l10n/lxqt-l10n-0.12.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lxqt-l10n/lxqt-l10n-0.12.0.tar.xz

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

mkdir -v build &&
cd       build &&
cmake -DCMAKE_BUILD_TYPE=Release          \
      -DCMAKE_INSTALL_PREFIX=$LXQT_PREFIX \
      ..       &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
