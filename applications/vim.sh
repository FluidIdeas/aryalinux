#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Vim package, which is anbr3ak abbreviation for VI IMproved, contains a <span class=\"command\"><strong>vi</strong> clone with extra features asbr3ak compared to the original <span class=\"command\"><strong>vi</strong>.br3ak"
SECTION="postlfs"
VERSION=8.0.586
NAME="vim"

#REC:gtk2
#REC:xorg-server
#OPT:gpm
#OPT:lua
#OPT:python2
#OPT:ruby
#OPT:tcl


cd $SOURCE_DIR

URL=http://ftp.vim.org/vim/unix/vim-8.0.586.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://ftp.vim.org/vim/unix/vim-8.0.586.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/vim/vim-8.0.586.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/vim/vim-8.0.586.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/vim/vim-8.0.586.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/vim/vim-8.0.586.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/vim/vim-8.0.586.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/vim/vim-8.0.586.tar.bz2

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

echo '#define SYS_VIMRC_FILE  "/etc/vimrc"' >>  src/feature.h &&
echo '#define SYS_GVIMRC_FILE "/etc/gvimrc"' >> src/feature.h &&
./configure --prefix=/usr \
            --with-features=huge \
            --with-tlib=ncursesw &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ln -snfv ../vim/vim80/doc /usr/share/doc/vim-8.0.586

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


rsync -avzcP --exclude="/dos/" --exclude="/spell/" \
    ftp.nluug.nl::Vim/runtime/ ./runtime/



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make -C src installruntime &&
vim -c ":helptags /usr/share/doc/vim-8.0.586" -c ":q"

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
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
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
