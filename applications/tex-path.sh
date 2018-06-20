#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="%DESCRIPTION%"
SECTION="pst"
NAME="tex-path"



cd $SOURCE_DIR

URL=

if [ ! -z $URL ]
then

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


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
export TEXARCH=$(uname -m | sed -e 's/i.86/i386/' -e 's/$/-linux/') &&
cat >> /etc/profile.d/extrapaths.sh << EOF

# Begin texlive addition
pathappend /opt/texlive/2018/texmf-dist/doc/man MANPATH
pathappend /opt/texlive/2018/texmf-dist/doc/info INFOPATH
pathappend /opt/texlive/2018/bin/$TEXARCH
# End texlive addition

EOF
unset TEXARCH

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
