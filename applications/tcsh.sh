#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Tcsh package containsbr3ak “<span class=\"quote\">an enhanced but completely compatiblebr3ak version of the Berkeley Unix C shell (<span class=\"command\"><strong>csh</strong>)”. This isbr3ak useful as an alternative shell for those who prefer C syntax tobr3ak that of the <span class=\"command\"><strong>bash</strong>br3ak shell, and also because some programs require the C shell in orderbr3ak to perform installation tasks.br3ak"
SECTION="postlfs"
VERSION=6.20.00
NAME="tcsh"



cd $SOURCE_DIR

URL=http://fossies.org/linux/misc/tcsh-6.20.00.tar.gz

if [ ! -z $URL ]
then
wget -nc http://fossies.org/linux/misc/tcsh-6.20.00.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/tcsh/tcsh-6.20.00.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/tcsh/tcsh-6.20.00.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/tcsh/tcsh-6.20.00.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/tcsh/tcsh-6.20.00.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/tcsh/tcsh-6.20.00.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/tcsh/tcsh-6.20.00.tar.gz || wget -nc ftp://ftp.astron.com/pub/tcsh/tcsh-6.20.00.tar.gz

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

sed -i 's|SVID_SOURCE|DEFAULT_SOURCE|g' config/linux  &&
sed -i 's|BSD_SOURCE|DEFAULT_SOURCE|g'  config/linux


./configure --prefix=/usr --bindir=/bin &&
make &&
sh ./tcsh.man2html



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install install.man &&
ln -v -sf tcsh   /bin/csh &&
ln -v -sf tcsh.1 /usr/share/man/man1/csh.1 &&
install -v -m755 -d          /usr/share/doc/tcsh-6.20.00/html &&
install -v -m644 tcsh.html/* /usr/share/doc/tcsh-6.20.00/html &&
install -v -m644 FAQ         /usr/share/doc/tcsh-6.20.00

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/shells << "EOF"
/bin/tcsh
/bin/csh
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cat > ~/.cshrc << "EOF"
# Original at:
# https://www.cs.umd.edu/~srhuang/teaching/code_snippets/prompt_color.tcsh.html
# Modified by the BLFS Development Team.
# Add these lines to your ~/.cshrc (or to /etc/csh.cshrc).
# Colors!
set red="%{\033[1;31m%}"
set green="%{\033[0;32m%}"
set yellow="%{\033[1;33m%}"
set blue="%{\033[1;34m%}"
set magenta="%{\033[1;35m%}"
set cyan="%{\033[1;36m%}"
set white="%{\033[0;37m%}"
set end="%{\033[0m%}" # This is needed at the end...
# Setting the actual prompt. Two separate versions for you to try, pick
# whichever one you like better, and change the colors as you want.
# Just don't mess with the ${end} guy in either line... Comment out or
# delete the prompt you don't use.
set prompt="${green}%n${blue}@%m ${white}%~ ${green}%%${end} "
set prompt="[${green}%n${blue}@%m ${white}%~ ]${end} "
# This was not in the original URL above
# Provides coloured ls
alias ls ls --color=always
# Clean up after ourselves...
unset red green yellow blue magenta cyan yellow white end
EOF




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
