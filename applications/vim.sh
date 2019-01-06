#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REC:installing
#REC:gtk2
#OPT:gpm
#OPT:lua
#OPT:python2
#OPT:ruby
#OPT:tcl

cd $SOURCE_DIR

wget -nc http://ftp.vim.org/vim/unix/vim-8.1.tar.bz2

NAME=vim
VERSION=8.1.
URL=http://ftp.vim.org/vim/unix/vim-8.1.tar.bz2

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

echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h &&
echo '#define SYS_GVIMRC_FILE "/etc/gvimrc"' >> src/feature.h &&

./configure --prefix=/usr \
--with-features=huge \
--with-tlib=ncursesw &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
ln -snfv ../vim/vim80/doc /usr/share/doc/vim-8.1
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

rsync -avzcP --exclude="/dos/" --exclude="/spell/" \
ftp.nluug.nl::Vim/runtime/ ./runtime/

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make -C src installruntime &&
vim -c ":helptags /usr/share/doc/vim-8.1" -c ":q"
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cat > /usr/share/applications/gvim.desktop << "EOF"
<code class="literal">[Desktop Entry]
Name=GVim Text Editor
Comment=Edit text files
Comment[pt_BR]=Edite arquivos de texto
TryExec=gvim
Exec=gvim -f %F
Terminal=false
Type=Application
Icon=gvim.png
Categories=Utility;TextEditor;
StartupNotify=true
MimeType=text/plain;</code>
EOF
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
