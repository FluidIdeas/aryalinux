#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:mercurial
#REQ:graphicsmagick
#REQ:liblqr
#REQ:libraw
#REQ:qt5
#REQ:exiv2
#REQ:lensfun
#REQ:libfftw3
#REQ:libpng12-0
#REQ:libtiff
#REQ:lcms2
#REQ:gimp


cd $SOURCE_DIR

wget -nc https://storage.googleapis.com/google-code-archive-source/v2/code.google.com/photivo/source-archive.zip
unzip source-archive.zip
DIRECTORY=photivo
cd $DIRECTORY

sed -i "s@lensfun.h@lensfun/lensfun.h@g" Sources/ptConstants.h
sed -i "s@lensfun.h@lensfun/lensfun.h@g" Sources/filters/imagespot/../../ptImage.h
sed -i "s@lensfun.h@lensfun/lensfun.h@g" Sources/ptImage_Lensfun.cpp
sed -i "s@lensfun.h@lensfun/lensfun.h@g" Sources/ptLensfun.h
qmake photivo.pro
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
