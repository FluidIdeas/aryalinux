#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

cd $SOURCE_DIR
NAME=tex-path
VERSION=0
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")


echo $USER > /tmp/currentuser

source /etc/profile
TEXARCH=$(uname -m | sed -e 's/i.86/i386/' -e 's/$/-linux/')
TEXLIVE_PREFIX=/opt/texlive/2025

cat > /etc/profile.d/texlive.sh << EOF
# Begin texlive setup
TEXLIVE_PREFIX=/opt/texlive/2025
export TEXLIVE_PREFIX

pathappend $TEXLIVE_PREFIX/texmf-dist/doc/info INFOPATH
pathappend $TEXLIVE_PREFIX/bin/$TEXARCH

TEXMFCNF=$TEXLIVE_PREFIX/texmf-dist/web2c
export TEXMFCNF

# End texlive setup
EOF

unset TEXARCH

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd