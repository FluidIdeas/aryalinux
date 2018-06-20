#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="mysql"
VERSION="5.6.27"

#REQ:cmake
#REQ:openssl
#REC:libevent
#OPT:boost
#OPT:libxml2
#OPT:linux-pam
#OPT:pcre
#OPT:ruby
#OPT:unixodbc
#OPT:valgrind
#REQ:libaio

cd $SOURCE_DIR

if [ `getent group mysql` ]
then
	sudo userdel -r mysql
fi
sudo groupadd -g 40 mysql &&
sudo useradd -c "MySQL Server" -d /srv/mysql -g mysql -s /bin/false -u 40 mysql

URL=http://pkgs.fedoraproject.org/repo/pkgs/community-mysql/mysql-5.6.27.tar.gz/7754df40bb5567b03b041ccb6b5ddffa/mysql-5.6.27.tar.gz
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

mkdir -pv build
cd build

cmake -DCMAKE_INSTALL_PREFIX=/usr -DBUILD_CONFIG=mysql_release .. &&
make "-j`nproc`"
sudo make install

chmod a+x scripts/mysql_install_db
sudo mkdir -pv /usr/scripts/
sudo cp scripts/mysql_install_db /usr/scripts

pushd /usr

sudo scripts/mysql_install_db --user=mysql
sudo chown -R mysql data

sudo mkdir -pv /var/mysqld
sudo chown -R mysql /var/mysqld

sudo tee /etc/my.cnf << "EOF"
# Begin /etc/my.cnf

# The following options will be passed to all MySQL clients
[client]
#password       = your_password
port            = 3306
socket          = /var/mysqld/mysqld.sock

# The MySQL server
[mysqld]
port            = 3306
socket          = /var/mysqld/mysqld.sock
datadir         = /usr/data
skip-external-locking
key_buffer_size = 16M
max_allowed_packet = 1M
sort_buffer_size = 512K
net_buffer_length = 16K
myisam_sort_buffer_size = 8M

# Don't listen on a TCP/IP port at all.
# skip-networking

# required unique id between 1 and 2^32 - 1
server-id       = 1

# Uncomment the following if you are using BDB tables
#bdb_cache_size = 4M
#bdb_max_lock = 10000

# Uncomment the following if you are using InnoDB tables
#innodb_data_home_dir = /usr/data
#innodb_data_file_path = ibdata1:10M:autoextend
#innodb_log_group_home_dir = /var/mysqld
# You can set .._buffer_pool_size up to 50 - 80 %
# of RAM but beware of setting memory usage too high
#innodb_buffer_pool_size = 16M
#innodb_additional_mem_pool_size = 2M
# Set .._log_file_size to 25 % of buffer pool size
#innodb_log_file_size = 5M
#innodb_log_buffer_size = 8M
#innodb_flush_log_at_trx_commit = 1
#innodb_lock_wait_timeout = 50

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

# End /etc/my.cnf
EOF

sudo bin/mysqld_safe --user=mysql &
sleep 5 &&
sudo bin/mysqladmin -u root password
sudo bin/mysqladmin -p shutdown

sudo tee /lib/systemd/system/mysqld.service <<"EOF"
[Unit]
Description=MySQL Server
After=network.target

[Service]
User=mysql
Group=mysql
ExecStart=/usr/bin/mysqld --pid-file=/var/mysqld/mysqld.pid
Restart=always
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable mysqld

popd

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
