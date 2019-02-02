#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:python3

cd $SOURCE_DIR

wget -nc https://github.com/ninja-build/ninja/archive/v1.8.2/ninja-1.8.2.tar.gz

NAME=ninja
VERSION=1.8.2
URL=https://github.com/ninja-build/ninja/archive/v1.8.2/ninja-1.8.2.tar.gz

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

python3 configure.py --bootstrap
emacs -Q --batch -f batch-byte-compile misc/ninja-mode.el
python3 configure.py &&
./ninja ninja_test &&
./ninja_test --gtest_filter=-SubprocessTest.SetWithLots

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -vm755 ninja /usr/bin/ &&
install -vDm644 misc/ninja.vim \
/usr/share/vim/vim80/syntax/ninja.vim &&
install -vDm644 misc/bash-completion \
/usr/share/bash-completion/completions/ninja &&
install -vDm644 misc/zsh-completion \
/usr/share/zsh/site-functions/_ninja
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -vDm644 misc/ninja-mode.el \
/usr/share/emacs/site-lisp/ninja-mode.el
install -vDm644 misc/ninja-mode.elc \
/usr/share/emacs/site-lisp/ninja-mode.elc
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja manual &&
install -vDm644 doc/manual.html /usr/share/doc/ninja-1.8.2/manual.html
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja doxygen &&
install -vDm644 -t /usr/share/doc/ninja-1.8.2/ doc/doxygen/html/*
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
