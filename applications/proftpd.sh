#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#OPT:libcap
#OPT:linux-pam
#OPT:mariadb
#OPT:pcre
#OPT:postgresql

cd $SOURCE_DIR

wget -nc ftp://ftp.proftpd.org/distrib/source/proftpd-1.3.6.tar.gz

NAME=proftpd
VERSION=1.3.6
URL=ftp://ftp.proftpd.org/distrib/source/proftpd-1.3.6.tar.gz

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


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
groupadd -g 46 proftpd                             &&
useradd -c proftpd -d /srv/ftp -g proftpd \
        -s /usr/bin/proftpdshell -u 46 proftpd     &&

install -v -d -m775 -o proftpd -g proftpd /srv/ftp &&
ln -v -s /bin/false /usr/bin/proftpdshell          &&
echo /usr/bin/proftpdshell >> /etc/shells
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var/run &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install                                   &&
install -d -m755 /usr/share/doc/proftpd-1.3.6 &&
cp -Rv doc/*     /usr/share/doc/proftpd-1.3.6
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cat > /etc/proftpd.conf << "EOF"
<code class="literal"># This is a basic ProFTPD configuration file # It establishes a single server and a single anonymous login. ServerName "ProFTPD Default Installation" ServerType standalone DefaultServer on # Port 21 is the standard FTP port. Port 21 # Umask 022 is a good standard umask to prevent new dirs and files # from being group and world writable. Umask 022 # To prevent DoS attacks, set the maximum number of child processes # to 30. If you need to allow more than 30 concurrent connections # at once, simply increase this value. Note that this ONLY works # in standalone mode, in inetd mode you should use an inetd server # that allows you to limit maximum number of processes per service MaxInstances 30 # Set the user and group that the server normally runs at. User proftpd Group proftpd # To cause every FTP user to be "jailed" (chrooted) into their home # directory, uncomment this line. #DefaultRoot ~ # Normally, files should be overwritable. <Directory /*> AllowOverwrite on </Directory> # A basic anonymous configuration, no upload directories. <Anonymous ~proftpd> User proftpd Group proftpd # Clients should be able to login with "anonymous" as well as "proftpd" UserAlias anonymous proftpd # Limit the maximum number of anonymous logins MaxClients 10 # 'welcome.msg' should be displayed at login, and '.message' displayed # in each newly chdired directory. DisplayLogin welcome.msg DisplayChdir .message # Limit WRITE everywhere in the anonymous chroot <Limit WRITE> DenyAll </Limit> </Anonymous></code>
EOF
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install-proftpd
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
