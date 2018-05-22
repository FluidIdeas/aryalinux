#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak PostgreSQL is an advancedbr3ak object-relational database management system (ORDBMS), derived frombr3ak the Berkeley Postgres database management system.br3ak"
SECTION="server"
VERSION=10.3
NAME="postgresql"

#OPT:python2
#OPT:tcl
#OPT:libxml2
#OPT:libxslt
#OPT:openldap
#OPT:linux-pam
#OPT:mitkrb
#OPT:sgml-dtd
#OPT:docbook-dsssl
#OPT:openjade
#OPT:perl-modules#perl-sgmlspm


cd $SOURCE_DIR

URL=http://ftp.postgresql.org/pub/source/v10.3/postgresql-10.3.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://ftp.postgresql.org/pub/source/v10.3/postgresql-10.3.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/postgresql/postgresql-10.3.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/postgresql/postgresql-10.3.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/postgresql/postgresql-10.3.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/postgresql/postgresql-10.3.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/postgresql/postgresql-10.3.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/postgresql/postgresql-10.3.tar.bz2 || wget -nc ftp://ftp.postgresql.org/pub/source/v10.3/postgresql-10.3.tar.bz2

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


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
getent group postgres || groupadd -g 41 postgres &&
getent passwd postgres || useradd -c "PostgreSQL Server" -g postgres -d /srv/pgsql/data \
        -u 41 postgres
rm -rf /srv/pgsql/data/*
rm -rf /srv/pgsql/data/.config
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


sed -i '/DEFAULT_PGSOCKET_DIR/s@/tmp@/run/postgresql@' src/include/pg_config_manual.h &&
./configure --prefix=/usr          \
            --enable-thread-safety \
            --docdir=/usr/share/doc/postgresql-10.3 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
make install-docs
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"

install -v -dm700 /srv/pgsql/data &&
install -v -dm755 /run/postgresql &&
chown -Rv postgres:postgres /srv/pgsql /run/postgresql
su postgres -c '/usr/bin/initdb -D /srv/pgsql/data'

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf

pushd $SOURCE_DIR
wget -nc http://www.linuxfromscratch.org/blfs/downloads/svn/blfs-systemd-units-20180105.tar.bz2
tar xf blfs-systemd-units-20180105.tar.bz2
cd blfs-systemd-units-20180105
make install-postgresql

cd ..
rm -rf blfs-systemd-units-20180105
popd
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
