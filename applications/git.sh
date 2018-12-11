#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REC:curl
#REC:python2
#OPT:pcre2
#OPT:pcre
#OPT:subversion
#OPT:tk
#OPT:valgrind
#OPT:xmlto
#OPT:asciidoc

cd $SOURCE_DIR

wget -nc https://www.kernel.org/pub/software/scm/git/git-2.19.1.tar.xz
wget -nc https://www.kernel.org/pub/software/scm/git/git-manpages-2.19.1.tar.xz
wget -nc https://www.kernel.org/pub/software/scm/git/git-htmldocs-2.19.1.tar.xz

URL=https://www.kernel.org/pub/software/scm/git/git-2.19.1.tar.xz

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

./configure --prefix=/usr --with-gitconfig=/etc/gitconfig &&
make
make html
make man

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install-man
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make htmldir=/usr/share/doc/git-2.19.1 install-html
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
tar -xf ../git-manpages-2.19.1.tar.xz \
    -C /usr/share/man --no-same-owner --no-overwrite-dir
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
mkdir -vp   /usr/share/doc/git-2.19.1 &&
tar   -xf   ../git-htmldocs-2.19.1.tar.xz \
      -C    /usr/share/doc/git-2.19.1 --no-same-owner --no-overwrite-dir &&

find        /usr/share/doc/git-2.19.1 -type d -exec chmod 755 {} \; &&
find        /usr/share/doc/git-2.19.1 -type f -exec chmod 644 {} \;
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
mkdir -vp /usr/share/doc/git-2.19.1/man-pages/{html,text}         &&
mv        /usr/share/doc/git-2.19.1/{git*.txt,man-pages/text}     &&
mv        /usr/share/doc/git-2.19.1/{git*.,index.,man-pages/}html &&

mkdir -vp /usr/share/doc/git-2.19.1/technical/{html,text}         &&
mv        /usr/share/doc/git-2.19.1/technical/{*.txt,text}        &&
mv        /usr/share/doc/git-2.19.1/technical/{*.,}html           &&

mkdir -vp /usr/share/doc/git-2.19.1/howto/{html,text}             &&
mv        /usr/share/doc/git-2.19.1/howto/{*.txt,text}            &&
mv        /usr/share/doc/git-2.19.1/howto/{*.,}html               &&

sed -i '/^<a href=/s|howto/|&html/|' /usr/share/doc/git-2.19.1/howto-index.html &&
sed -i '/^\* link:/s|howto/|&html/|' /usr/share/doc/git-2.19.1/howto-index.txt
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
