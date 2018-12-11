#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Apache-Maven is a tool that can bebr3ak used for building and managing any Java-based project. Based on thebr3ak concept of a project object model (POM), Apache-Maven can manage a project's build,br3ak reporting and documentation from a central piece of information.br3ak"
SECTION="general"
VERSION=3.5.4
NAME="maven"

#REQ:java#java-bin
#REQ:openjdk


cd $SOURCE_DIR

URL=https://archive.apache.org/dist/maven/maven-3/3.5.4/source/apache-maven-3.5.4-src.tar.gz

if [ ! -z $URL ]
then
wget -nc https://archive.apache.org/dist/maven/maven-3/3.5.4/source/apache-maven-3.5.4-src.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/apache-maven/apache-maven-3.5.4-src.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/apache-maven/apache-maven-3.5.4-src.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/apache-maven/apache-maven-3.5.4-src.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/apache-maven/apache-maven-3.5.4-src.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/apache-maven/apache-maven-3.5.4-src.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/apache-maven/apache-maven-3.5.4-src.tar.gz
wget -nc https://archive.apache.org/dist/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/apache-maven/apache-maven-3.5.4-bin.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/apache-maven/apache-maven-3.5.4-bin.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/apache-maven/apache-maven-3.5.4-bin.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/apache-maven/apache-maven-3.5.4-bin.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/apache-maven/apache-maven-3.5.4-bin.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/apache-maven/apache-maven-3.5.4-bin.tar.gz

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

sed -e '/-surefire-/a<version>2.21.0</version>' \
    -e '/<commonsLang/s/3\.5/3.7/'              \
    -i pom.xml


install -vdm 755 ../apache-maven-bin     &&
tar -xf ../apache-maven-3.5.4-bin.tar.gz \
    --strip-components=1                 \
    --directory ../apache-maven-bin      &&
SAVEPATH=$PATH   &&
PATH=../apache-maven-bin/bin:$PATH &&
mvn -DdistributionTargetDir=build \
    package



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -vdm 755            /opt/maven-3.5.4 &&
cp -Rv apache-maven/build/* /opt/maven-3.5.4 &&
ln -sfvn maven-3.5.4 /opt/maven

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


PATH=$SAVEPATH &&
rm -rf ../apache-maven-bin



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/profile.d/maven.sh << "EOF"
# Begin /etc/profile.d/maven.sh
pathappend /opt/maven/bin
# End /etc/profile.d/maven.sh
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
