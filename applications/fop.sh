#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:apache-ant


cd $SOURCE_DIR

wget -nc https://archive.apache.org/dist/xmlgraphics/fop/source/fop-2.6-src.tar.gz
wget -nc http://archive.apache.org/dist/pdfbox/2.0.22/pdfbox-2.0.22.jar
wget -nc http://archive.apache.org/dist/pdfbox/2.0.22/fontbox-2.0.22.jar
wget -nc http://archive.apache.org/dist/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
wget -nc https://downloads.sourceforge.net/offo/2.2/offo-hyphenation.zip


NAME=fop
VERSION=2.
URL=https://archive.apache.org/dist/xmlgraphics/fop/source/fop-2.6-src.tar.gz
SECTION="PostScript"
DESCRIPTION="The FOP (Formatting Objects Processor) package contains a print formatter driven by XSL formatting objects (XSL-FO). It is a Java application that reads a formatting object tree and renders the resulting pages to a specified output. Output formats currently supported include PDF, PCL, PostScript, SVG, XML (area tree representation), print, AWT, MIF and ASCII text. The primary output target is PDF."

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
tar -xf ../apache-maven-3.6.3-bin.tar.gz -C /tmp
sed -i '\@</javad@i\
<arg value="-Xdoclint:none"/>\
<arg value="--allow-script-in-comments"/>\
<arg value="--ignore-source-errors"/>' \
    fop/build.xml
cp ../{pdf,font}box-2.0.22.jar fop/lib
cd fop &&

LC_ALL=en_US.UTF-8                     \
PATH=$PATH:/tmp/apache-maven-3.6.3/bin \
ant all javadocs &&

mv build/javadocs .
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -d -m755 -o root -g root          /opt/fop-2.6 &&
cp -vR build conf examples fop* javadocs lib /opt/fop-2.6 &&
chmod a+x /opt/fop-2.6/fop                                &&
ln -v -sfn fop-2.6 /opt/fop
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

rm -rf /tmp/apache-maven-3.6.3
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

