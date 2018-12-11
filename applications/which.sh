#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The first option is to install the actual GNU which package.br3ak"
SECTION="general"
VERSION=2.21
NAME="general_which"



cd $SOURCE_DIR

URL=https://ftp.gnu.org/gnu/which/which-2.21.tar.gz

if [ ! -z $URL ]
then
wget -nc https://ftp.gnu.org/gnu/which/which-2.21.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/which/which-2.21.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/which/which-2.21.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/which/which-2.21.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/which/which-2.21.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/which/which-2.21.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/which/which-2.21.tar.gz || wget -nc ftp://ftp.gnu.org/gnu/which/which-2.21.tar.gz

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

./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /usr/bin/which << "EOF"
#!/bin/bash
type -pa "$@" | head -n 1 ; exit ${PIPESTATUS[0]}
EOF
chmod -v 755 /usr/bin/which
chown -v root:root /usr/bin/which

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
