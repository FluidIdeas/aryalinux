#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gtk3


cd $SOURCE_DIR

wget -nc http://github.com/vim/vim/archive/v8.2.0024/vim-8.2.0024.tar.gz


NAME=vim
VERSION=8.2.0024
URL=http://github.com/vim/vim/archive/v8.2.0024/vim-8.2.0024.tar.gz

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


echo '#define SYS_VIMRC_FILE  "/etc/vimrc"' >>  src/feature.h &&
echo '#define SYS_GVIMRC_FILE "/etc/gvimrc"' >> src/feature.h &&

./configure --prefix=/usr        \
            --with-features=huge \
            --enable-gui=gtk3    \
            --with-tlib=ncursesw &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ln -snfv ../vim/vim82/doc /usr/share/doc/vim-8.2.0024
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

rsync -avzcP --exclude="/dos/" --exclude="/spell/" \
    ftp.nluug.nl::Vim/runtime/ ./runtime/
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make -C src installruntime &&
vim -c ":helptags /usr/share/doc/vim-8.2.0024" -c ":q"
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
cat > /usr/share/applications/gvim.desktop << "EOF"
[Desktop Entry]
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
MimeType=text/plain;
EOF
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

