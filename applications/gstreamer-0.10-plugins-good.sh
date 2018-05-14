#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="gstreamer-0.10-plugins-good"
VERSION="0.10.31"

#REQ:gstreamer-0.10

cd $SOURCE_DIR
URL="http://archive.ubuntu.com/ubuntu/pool/universe/g/gst-plugins-good0.10/gst-plugins-good0.10_0.10.31.orig.tar.gz"
wget -nc $URL
wget -nc https://raw.githubusercontent.com/openembedded/meta-openembedded/master/meta-multimedia/recipes-multimedia/gstreamer-0.10/gst-plugins-good-0.10.31/0001-v4l2-fix-build-with-recent-kernels-the-v4l2_buffer-i.patch
wget -nc https://raw.githubusercontent.com/openembedded/meta-openembedded/master/meta-multimedia/recipes-multimedia/gstreamer-0.10/gst-plugins-good-0.10.31/0001-v4l2_calls-define-V4L2_CID_HCENTER-and-V4L2_CID_VCEN.patch
wget https://raw.githubusercontent.com/openembedded/meta-openembedded/master/meta-multimedia/recipes-multimedia/gstreamer-0.10/gst-plugins-good-0.10.31/0407-mulawdec-fix-integer-overrun.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

patch -Np1 -i ../0001-v4l2-fix-build-with-recent-kernels-the-v4l2_buffer-i.patch
patch -Np1 -i ../0001-v4l2_calls-define-V4L2_CID_HCENTER-and-V4L2_CID_VCEN.patch
patch -Np1 -i ../0407-mulawdec-fix-integer-overrun.patch

./configure --prefix=/usr
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
