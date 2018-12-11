#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Traceroute package contains abr3ak program which is used to display the network route that packetsbr3ak take to reach a specified host. This is a standard networkbr3ak troubleshooting tool. If you find yourself unable to connect tobr3ak another system, traceroute can help pinpoint the problem.br3ak"
SECTION="basicnet"
VERSION=2.1.0
NAME="traceroute"



cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/traceroute/traceroute-2.1.0.tar.gz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/traceroute/traceroute-2.1.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/traceroute/traceroute-2.1.0.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/traceroute/traceroute-2.1.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/traceroute/traceroute-2.1.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/traceroute/traceroute-2.1.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/traceroute/traceroute-2.1.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/traceroute/traceroute-2.1.0.tar.gz

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

make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make prefix=/usr install                                 &&
mv /usr/bin/traceroute /bin                              &&
ln -sv -f traceroute /bin/traceroute6                    &&
ln -sv -f traceroute.8 /usr/share/man/man8/traceroute6.8 &&
rm -fv /usr/share/man/man1/traceroute.1

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
