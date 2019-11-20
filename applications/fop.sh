#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:apache-ant


cd $SOURCE_DIR

wget -nc https://archive.apache.org/dist/xmlgraphics/fop/source/fop-2.4-src.tar.gz
wget -nc http://mirror.reverse.net/pub/apache/pdfbox/2.0.17/pdfbox-2.0.17.jar
wget -nc http://mirror.reverse.net/pub/apache/pdfbox/2.0.17/fontbox-2.0.17.jar
wget -nc https://downloads.sourceforge.net/offo/2.2/offo-hyphenation.zip


NAME=fop
VERSION=2.
URL=https://archive.apache.org/dist/xmlgraphics/fop/source/fop-2.4-src.tar.gz

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
sed -e 's/1\.6/1.7/' \
    -i fop/build.xml
cp ../{pdf,font}box-2.0.17.jar fop/lib
cd fop                    &&
export LC_ALL=en_US.UTF-8 &&
ant all javadocs          &&
mv build/javadocs .
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -d -m755 -o root -g root          /opt/fop-2.4 &&
cp -vR build conf examples fop* javadocs lib /opt/fop-2.4 &&
chmod a+x /opt/fop-2.4/fop                                &&
ln -v -sfn fop-2.4 /opt/fop
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

cat > ~/.foprc << "EOF"
FOP_OPTS="-Xmx<RAM_Installed>m"
FOP_HOME="/opt/fop"
EOF
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
cat > /etc/profile.d/fop.sh << "EOF"
# Begin /etc/profile.d/fop.sh

pathappend /opt/fop

# End /etc/profile.d/fop.sh
EOF
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

