#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak This package provides a library for learning linear classifiers forbr3ak large scale applications. It supports Support Vector Machines (SVM)br3ak with L2 and L1 loss, logistic regression, multi classbr3ak classification and also Linear Programming Machines (L1-regularizedbr3ak SVMs). Its computational complexity scales linearly with the numberbr3ak of training examples making it one of the fastest SVM solversbr3ak around.br3ak"
SECTION="general"
VERSION=221
NAME="liblinear"



cd $SOURCE_DIR

URL=https://github.com/cjlin1/liblinear/archive/v221/liblinear-221.tar.gz

if [ ! -z $URL ]
then
wget -nc https://github.com/cjlin1/liblinear/archive/v221/liblinear-221.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/liblinear/liblinear-221.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/liblinear/liblinear-221.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/liblinear/liblinear-221.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/liblinear/liblinear-221.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/liblinear/liblinear-221.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/liblinear/liblinear-221.tar.gz

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

make lib



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -vm644 linear.h /usr/include &&
install -vm755 liblinear.so.3 /usr/lib &&
ln -sfv liblinear.so.3 /usr/lib/liblinear.so

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
