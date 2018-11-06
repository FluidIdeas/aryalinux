#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Graphite2 is a rendering enginebr3ak for graphite fonts. These are TrueType fonts with additional tablesbr3ak containing smart rendering information and were originallybr3ak developed to support complex non-Roman writing systems. They maybr3ak contain rules for e.g. ligatures, glyph substitution, kerning,br3ak justification - this can make them useful even on text written inbr3ak Roman writing systems such as English. Note that firefox by default provides an internal copybr3ak of the graphite engine and cannot use a system version (although itbr3ak can now be patched to use it), but it too should benefit from thebr3ak availability of graphite fonts.br3ak"
SECTION="general"
VERSION=1.3.12
NAME="graphite2"

#REQ:cmake
#OPT:freetype2
#OPT:python2
#OPT:harfbuzz


cd $SOURCE_DIR

URL=https://github.com/silnrsi/graphite/releases/download/1.3.12/graphite2-1.3.12.tgz

if [ ! -z $URL ]
then
wget -nc https://github.com/silnrsi/graphite/releases/download/1.3.12/graphite2-1.3.12.tgz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/graphite2/graphite2-1.3.12.tgz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/graphite2/graphite2-1.3.12.tgz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/graphite2/graphite2-1.3.12.tgz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/graphite2/graphite2-1.3.12.tgz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/graphite2/graphite2-1.3.12.tgz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/graphite2/graphite2-1.3.12.tgz

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

sed -i '/cmptest/d' tests/CMakeLists.txt


mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr .. &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
