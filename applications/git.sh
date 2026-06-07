#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:curl

cd $SOURCE_DIR
NAME=git
VERSION=2.53.0
URL=https://www.kernel.org/pub/software/scm/git/git-2.53.0.tar.xz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://www.kernel.org/pub/software/scm/git/git-2.53.0.tar.xz


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

./configure --prefix=/usr                   \
            --with-gitconfig=/etc/gitconfig \
            --with-python=python3           \
            --with-libpcre2
make
make html
make man
make perllibdir=/usr/lib/perl5/5.42/site_perl install
make htmldir=/usr/share/doc/git-2.53.0 install-html
tar -xf ../git-manpages-2.53.0.tar.xz \
    -C /usr/share/man --no-same-owner --no-overwrite-dir
mkdir -vp   /usr/share/doc/git-2.53.0
tar   -xf   ../git-htmldocs-2.53.0.tar.xz \
      -C    /usr/share/doc/git-2.53.0 --no-same-owner --no-overwrite-dir
find        /usr/share/doc/git-2.53.0 -type d -exec chmod 755 {} \;
find        /usr/share/doc/git-2.53.0 -type f -exec chmod 644 {} \;
mkdir -vp /usr/share/doc/git-2.53.0/man-pages/{html,text}
mv        /usr/share/doc/git-2.53.0/{git*.adoc,man-pages/text}
mv        /usr/share/doc/git-2.53.0/{git*.,index.,man-pages/}html
mkdir -vp /usr/share/doc/git-2.53.0/technical/{html,text}
mv        /usr/share/doc/git-2.53.0/technical/{*.adoc,text}
mv        /usr/share/doc/git-2.53.0/technical/{*.,}html
mkdir -vp /usr/share/doc/git-2.53.0/howto/{html,text}
mv        /usr/share/doc/git-2.53.0/howto/{*.adoc,text}
mv        /usr/share/doc/git-2.53.0/howto/{*.,}html
sed -i '/^<a href=/s|howto/|&html/|' /usr/share/doc/git-2.53.0/howto-index.html
sed -i '/^\* link:/s|howto/|&html/|' /usr/share/doc/git-2.53.0/howto-index.adoc


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install-man
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd