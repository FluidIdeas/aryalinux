#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:maven

cd $SOURCE_DIR

wget -nc https://github.com/junit-team/junit4/archive/r4.12/junit4-r4.12.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/junit4-r4.12-simplify_NoExitSecurityManager-1.patch

NAME=junit
VERSION=""
URL=https://github.com/junit-team/junit4/archive/r4.12/junit4-r4.12.tar.gz

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

sed -e '/MethodsSorted/i @Ignore' \
-i src/test/java/org/junit/runners/model/TestClassTest.java
patch -Np1 -i ../junit4-r4.12-simplify_NoExitSecurityManager-1.patch
mvn -DjdkVersion=1.6 install
mvn site

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
install -v -m755 -d /usr/share/java/junit-4.12 &&
cp -v target/junit-4.12.jar /usr/share/java/junit-4.12 &&
cp -v lib/hamcrest-core-1.3.jar /usr/share/java/junit-4.12
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
install -v -m755 -d /usr/share/doc/junit-4.12 &&
cp -v -R target/site/* /usr/share/doc/junit-4.12
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
