#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Midori is a lightweight webbr3ak browser that uses WebKitGTK+.br3ak"
SECTION="xsoft"
VERSION=0.5.11
NAME="midori"

#REQ:cmake
#REQ:gcr
#REQ:libnotify
#REQ:webkitgtk
#REQ:vala
#REC:librsvg
#OPT:gtk-doc
#OPT:libzeitgeist


cd $SOURCE_DIR

URL=http://www.midori-browser.org/downloads/midori_0.5.11_all_.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://www.midori-browser.org/downloads/midori_0.5.11_all_.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/midori/midori_0.5.11_all_.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/midori/midori_0.5.11_all_.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/midori/midori_0.5.11_all_.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/midori/midori_0.5.11_all_.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/midori/midori_0.5.11_all_.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/midori/midori_0.5.11_all_.tar.bz2

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

sed -e 's/protected Tally/public Tally/g'  \
    -i midori/midori-notebook.vala         &&
sed -e 's/%d other files/%u other files/g' \
    -i extensions/transfers.vala           &&
for f in transfers adblock/widgets apps history-list notes; do
    sed -e 's/.remove (iter/.remove (ref iter/g' \
        -i "extensions/$f.vala"
done        &&
mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release  \
      -DUSE_ZEITGEIST=OFF         \
      -DHALF_BRO_INCOM_WEBKIT2=ON \
      -DUSE_GTK3=1                \
      -DCMAKE_INSTALL_DOCDIR=/usr/share/doc/midori-0.5.11 \
      ..  &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
