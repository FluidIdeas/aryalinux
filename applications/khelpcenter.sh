#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:grantlee
#REQ:frameworks5
#REQ:libxml2
#REQ:xapian


cd $SOURCE_DIR
mkdir -pv $NAME
pushd $NAME

wget -nc https://download.kde.org/stable/release-service/20.12.2/src/khelpcenter-20.12.2.tar.xz


NAME=khelpcenter
VERSION=20.12.2
URL=https://download.kde.org/stable/release-service/20.12.2/src/khelpcenter-20.12.2.tar.xz
SECTION="KDE Frameworks 5 Based Applications"
DESCRIPTION="Khelpcenter is an application to show KDE Applications' documentation."

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


mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release         \
      -DBUILD_TESTING=OFF                \
      -Wno-dev .. &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install  &&

mv -v /usr/share/kde4/services/khelpcenter.desktop /usr/share/applications/ &&
rm -rv /usr/share/kde4
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd