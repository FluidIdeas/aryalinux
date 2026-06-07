#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

cd $SOURCE_DIR
NAME=postgresql
VERSION=18.2
URL=https://ftp.postgresql.org/pub/source/v18.2/postgresql-18.2.tar.bz2
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://ftp.postgresql.org/pub/source/v18.2/postgresql-18.2.tar.bz2


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

sed -e '/DEFAULT_PGSOCKET_DIR/s@/tmp@/run/postgresql@' \
    -i src/include/pg_config_manual.h
./configure --prefix=/usr \
            --docdir=/usr/share/doc/postgresql-18.2
make
make DESTDIR=$(pwd)/DESTDIR install
pushd $(pwd)/DESTDIR/tmp
systemctl stop postgresql
su postgres -c "../usr/bin/initdb -D /srv/pgsql/newdata"
su postgres -c "../usr/bin/pg_upgrade \
                    -d /srv/pgsql/data    -b /usr/bin \
                    -D /srv/pgsql/newdata -B ../usr/bin"
popd
rm -rf /srv/pgsql/data
mv /srv/pgsql/newdata /srv/pgsql/data
make -C contrib/<SUBDIR-NAME> install
groupadd -g 41 postgres
useradd -c "PostgreSQL Server" -g postgres -d /srv/pgsql/data \
        -u 41 postgres
chown -Rv postgres:postgres /srv/pgsql /run/postgresql
su - postgres -c '/usr/bin/initdb -D /srv/pgsql/data'
su - postgres -c '/usr/bin/postgres -D /srv/pgsql/data > \
                  /srv/pgsql/data/logfile 2>&1 &'
su - postgres -c '/usr/bin/createdb test'
echo "create table t1 ( name varchar(20), state_province varchar(20) );" \
    | (su - postgres -c '/usr/bin/psql test ')
echo "insert into t1 values ('Billy', 'NewYork');" \
    | (su - postgres -c '/usr/bin/psql test ')
echo "insert into t1 values ('Evanidus', 'Quebec');" \
    | (su - postgres -c '/usr/bin/psql test ')
echo "insert into t1 values ('Jesse', 'Ontario');" \
    | (su - postgres -c '/usr/bin/psql test ')
echo "select * from t1;" | (su - postgres -c '/usr/bin/psql test')
su - postgres -c "/usr/bin/pg_ctl stop -D /srv/pgsql/data"


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -d -o postgres $(pwd)/DESTDIR/tmp
make install
make install-docs
install -v -dm700 /srv/pgsql/data
install -v -dm755 /run/postgresql
make install-postgresql
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd