#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak MariaDB is a community-developedbr3ak fork and a drop-in replacement for the MySQL relational database management system.br3ak"
SECTION="server"
VERSION=10.2.14
NAME="mariadb"

#REQ:cmake
#REC:libevent
#OPT:boost
#OPT:libxml2
#OPT:linux-pam
#OPT:mitkrb
#OPT:pcre
#OPT:ruby
#OPT:unixodbc
#OPT:valgrind


cd $SOURCE_DIR

URL=https://downloads.mariadb.org/interstitial/mariadb-10.2.14/source/mariadb-10.2.14.tar.gz

if [ ! -z $URL ]
then
wget -nc https://downloads.mariadb.org/interstitial/mariadb-10.2.14/source/mariadb-10.2.14.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/mariadb/mariadb-10.2.14.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/mariadb/mariadb-10.2.14.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/mariadb/mariadb-10.2.14.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/mariadb/mariadb-10.2.14.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/mariadb/mariadb-10.2.14.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/mariadb/mariadb-10.2.14.tar.gz || wget -nc ftp://mirrors.fe.up.pt/pub/mariadb/mariadb-10.2.14/source/mariadb-10.2.14.tar.gz

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
groupadd -g 40 mysql &&
useradd -c "MySQL Server" -d /srv/mysql -g mysql -s /bin/false -u 40 mysql

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


sed -i "s@data/test@\${INSTALL_MYSQLTESTDIR}@g" sql/CMakeLists.txt &&
mkdir build &&
cd build    &&
cmake -DCMAKE_BUILD_TYPE=Release                      \
      -DCMAKE_INSTALL_PREFIX=/usr                     \
      -DINSTALL_DOCDIR=share/doc/mariadb-10.2.14       \
      -DINSTALL_DOCREADMEDIR=share/doc/mariadb-10.2.14 \
      -DINSTALL_MANDIR=share/man                      \
      -DINSTALL_MYSQLSHAREDIR=share/mysql             \
      -DINSTALL_MYSQLTESTDIR=share/mysql/test         \
      -DINSTALL_PLUGINDIR=lib/mysql/plugin            \
      -DINSTALL_SBINDIR=sbin                          \
      -DINSTALL_SCRIPTDIR=bin                         \
      -DINSTALL_SQLBENCHDIR=share/mysql/bench         \
      -DINSTALL_SUPPORTFILESDIR=share/mysql           \
      -DMYSQL_DATADIR=/srv/mysql                      \
      -DMYSQL_UNIX_ADDR=/run/mysqld/mysqld.sock       \
      -DWITH_EXTRA_CHARSETS=complex                   \
      -DWITH_EMBEDDED_SERVER=ON                       \
      -DSKIP_TESTS=ON                                 \
      -DTOKUDB_OK=0                                   \
      .. &&
make "-j`nproc`" || make


pushd mysql-test
./mtr --parallel <N> --mem --force
popd



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -dm 755 /etc/mysql &&
cat > /etc/mysql/my.cnf << "EOF"
# Begin /etc/mysql/my.cnf
# The following options will be passed to all MySQL clients
[client]
#password = your_password
port = 3306
socket = /run/mysqld/mysqld.sock
# The MySQL server
[mysqld]
port = 3306
socket = /run/mysqld/mysqld.sock
datadir = /srv/mysql
skip-external-locking
key_buffer_size = 16M
max_allowed_packet = 1M
sort_buffer_size = 512K
net_buffer_length = 16K
myisam_sort_buffer_size = 8M
# Don't listen on a TCP/IP port at all.
skip-networking
# required unique id between 1 and 2^32 - 1
server-id = 1
# Uncomment the following if you are using BDB tables
#bdb_cache_size = 4M
#bdb_max_lock = 10000
# InnoDB tables are now used by default
innodb_data_home_dir = /srv/mysql
innodb_log_group_home_dir = /srv/mysql
# All the innodb_xxx values below are the default ones:
innodb_data_file_path = ibdata1:12M:autoextend
# You can set .._buffer_pool_size up to 50 - 80 %
# of RAM but beware of setting memory usage too high
innodb_buffer_pool_size = 128M
innodb_log_file_size = 48M
innodb_log_buffer_size = 16M
innodb_flush_log_at_trx_commit = 1
innodb_lock_wait_timeout = 50
[mysqldump]
quick
max_allowed_packet = 16M
[mysql]
no-auto-rehash
# Remove the next comment character if you are not familiar with SQL
#safe-updates
[isamchk]
key_buffer = 20M
sort_buffer_size = 20M
read_buffer = 2M
write_buffer = 2M
[myisamchk]
key_buffer_size = 20M
sort_buffer_size = 20M
read_buffer = 2M
write_buffer = 2M
[mysqlhotcopy]
interactive-timeout
# End /etc/mysql/my.cnf
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mysql_install_db --basedir=/usr --datadir=/srv/mysql --user=mysql &&
chown -R mysql:mysql /srv/mysql

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m755 -o mysql -g mysql -d /run/mysqld &&
mysqld_safe --user=mysql 2>&1 >/dev/null &

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


sleep 5
clear



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mysqladmin -u root password

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mysqladmin -p shutdown

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
make install-mysqld

cd ..
rm -rf blfs-systemd-units-20180105
popd
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
