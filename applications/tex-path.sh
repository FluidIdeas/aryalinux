#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf


cd $SOURCE_DIR


NAME=tex-path
VERSION=""
URL=""

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
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
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
