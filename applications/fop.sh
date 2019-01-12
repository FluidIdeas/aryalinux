#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:apache-ant
#OPT:junit
#OPT:maven

cd $SOURCE_DIR

wget -nc https://archive.apache.org/dist/xmlgraphics/fop/source/fop-2.3-src.tar.gz
wget -nc https://downloads.sourceforge.net/offo/2.2/offo-hyphenation.zip

NAME=fop
VERSION=src
URL=https://archive.apache.org/dist/xmlgraphics/fop/source/fop-2.3-src.tar.gz

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

unzip ../offo-hyphenation.zip &&
cp offo-hyphenation/hyph/* fop/hyph &&
rm -rf offo-hyphenation
sed -i '\@</javad@i\
<arg value="-Xdoclint:none"/>\
<arg value="--allow-script-in-comments"/>\
<arg value="--ignore-source-errors"/>' \
fop/build.xml
sed -e '/hyph\.stack/s/512k/1M/' \
-i fop/build.xml
cp ../{pdf,font}box-2.0.11.jar fop/lib
cd fop &&
export LC_ALL=en_US.UTF-8 &&
ant all javadocs &&
mv build/javadocs .

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -d -m755 -o root -g root /opt/fop-2.3 &&
cp -vR build conf examples fop* javadocs lib /opt/fop-2.3 &&
chmod a+x /opt/fop-2.3/fop &&
ln -v -sfn fop-2.3 /opt/fop
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

cat > ~/.foprc << "EOF"
FOP_OPTS="-Xmx<em class="replaceable"><code><RAM_Installed></em>m"
FOP_HOME="/opt/fop"
EOF

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
