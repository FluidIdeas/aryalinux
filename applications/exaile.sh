#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="exaile"
VERSION="4.0.0beta1"

NAME="exaile"

#REQ:gst10-plugins-base
#REQ:gst10-plugins-good
#REQ:gst10-plugins-bad
#REQ:gst10-plugins-ugly
#REQ:gst10-libav
#REQ:mutagen
#REQ:python-modules#dbus-python

cd $SOURCE_DIR
URL=https://github.com/exaile/exaile/releases/download/4.0.0-beta1/exaile-4.0.0beta1.tar.gz
wget -nc $URL

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

sudo make PREFIX=/usr install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
