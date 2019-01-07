#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:java#java-bin
#REQ:openjdk

cd $SOURCE_DIR

wget -nc https://archive.apache.org/dist/maven/maven-3/3.5.4/source/apache-maven-3.5.4-src.tar.gz

NAME=maven
VERSION=3.5.4-src
URL=https://archive.apache.org/dist/maven/maven-3/3.5.4/source/apache-maven-3.5.4-src.tar.gz

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

sed -e '/-surefire-/a<version>2.21.0</version>' \
-e '/<commonsLang/s/3\.5/3.7/' \
-i pom.xml
install -vdm 755 ../apache-maven-bin &&
tar -xf ../apache-maven-3.5.4-bin.tar.gz \
--strip-components=1 \
--directory ../apache-maven-bin &&

SAVEPATH=$PATH &&
PATH=../apache-maven-bin/bin:$PATH &&

mvn -DdistributionTargetDir=build \
package

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -vdm 755 /opt/maven-3.5.4 &&
cp -Rv apache-maven/build/* /opt/maven-3.5.4 &&
ln -sfvn maven-3.5.4 /opt/maven
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

PATH=$SAVEPATH &&
rm -rf ../apache-maven-bin

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
cat > /etc/profile.d/maven.sh << "EOF"
# Begin /etc/profile.d/maven.sh

pathappend /opt/maven/bin

# End /etc/profile.d/maven.sh
EOF
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
