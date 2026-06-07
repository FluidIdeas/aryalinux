#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:apache-ant
#REQ:libarchive

cd $SOURCE_DIR
NAME=fop
VERSION=2.11
URL=https://archive.apache.org/dist/xmlgraphics/fop/source/fop-2.11-src.tar.gz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://archive.apache.org/dist/xmlgraphics/fop/source/fop-2.11-src.tar.gz


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

unzip ../offo-hyphenation.zip
cp offo-hyphenation/hyph/* fop/hyph
rm -rf offo-hyphenation
tar -xf ../apache-maven-3.9.12-bin.tar.gz -C /tmp
sed -i '\@</javad@i\
<arg value="-Xdoclint:none"/>\
<arg value="--allow-script-in-comments"/>\
<arg value="--ignore-source-errors"/>' \
    fop/build.xml
cd fop
LC_ALL=en_US.UTF-8                     \
PATH=$PATH:/tmp/apache-maven-3.9.12/bin \
ant package javadocs
mv build/javadocs .
rm -rf /tmp/apache-maven-3.9.12
cat > ~/.foprc << "EOF"
FOP_OPTS="-Xmx<RAM_Installed>m"
FOP_HOME="/opt/fop"
EOF
cp -vR build conf examples fop* javadocs lib /opt/fop-2.11
chmod a+x /opt/fop-2.11/fop
ln -v -sfn fop-2.11 /opt/fop
cat > /etc/profile.d/fop.sh << "EOF"
# Begin /etc/profile.d/fop.sh

pathappend /opt/fop

# End /etc/profile.d/fop.sh
EOF


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -d -m755 -o root -g root          /opt/fop-2.11
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd