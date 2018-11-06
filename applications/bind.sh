#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The BIND package provides a DNSbr3ak server and client utilities. If you are only interested in thebr3ak utilities, refer to the <a class=\"xref\" href=\"../basicnet/bind-utils.html\" title=\"BIND Utilities-9.12.3\">BINDbr3ak Utilities-9.12.3</a>.br3ak"
SECTION="server"
VERSION=9.12.3
NAME="bind"

#OPT:libcap
#OPT:libidn2
#OPT:libxml2
#OPT:mitkrb
#OPT:db
#OPT:mariadb
#OPT:openldap
#OPT:postgresql
#OPT:unixodbc
#OPT:perl-modules#perl-net-dns
#OPT:doxygen
#OPT:libxslt
#OPT:texlive
#OPT:tl-installer


cd $SOURCE_DIR

URL=ftp://ftp.isc.org/isc/bind9/9.12.3/bind-9.12.3.tar.gz

if [ ! -z $URL ]
then
wget -nc ftp://ftp.isc.org/isc/bind9/9.12.3/bind-9.12.3.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/bind/bind-9.12.3.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/bind/bind-9.12.3.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/bind/bind-9.12.3.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/bind/bind-9.12.3.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/bind/bind-9.12.3.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/bind/bind-9.12.3.tar.gz

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

./configure --prefix=/usr           \
            --sysconfdir=/etc       \
            --localstatedir=/var    \
            --mandir=/usr/share/man \
            --enable-threads        \
            --with-libtool          \
            --disable-static        &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
bin/tests/system/ifconfig.sh up

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


make -k check



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
bin/tests/system/ifconfig.sh down

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/doc/bind-9.12.3/{arm,misc} &&
install -v -m644    doc/arm/*.html \
                    /usr/share/doc/bind-9.12.3/arm &&
install -v -m644    doc/misc/{dnssec,ipv6,migrat*,options,rfc-compliance,roadmap,sdb} \
                    /usr/share/doc/bind-9.12.3/misc

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -g 20 named &&
useradd -c "BIND Owner" -g named -s /bin/false -u 20 named &&
install -d -m770 -o named -g named /srv/named

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mkdir -p /srv/named &&
cd       /srv/named &&
mkdir -p dev etc/namedb/{slave,pz} usr/lib/engines var/run/named &&
mknod /srv/named/dev/null c 1 3 &&
mknod /srv/named/dev/urandom c 1 9 &&
chmod 666 /srv/named/dev/{null,urandom} &&
cp /etc/localtime etc &&
touch /srv/named/managed-keys.bind

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
rndc-confgen -r /dev/urandom -b 512 > /etc/rndc.conf &&
sed '/conf/d;/^#/!d;s:^# ::' /etc/rndc.conf > /srv/named/etc/named.conf

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /srv/named/etc/named.conf << "EOF"
options {
 directory "/etc/namedb";
 pid-file "/var/run/named.pid";
 statistics-file "/var/run/named.stats";
};
zone "." {
 type hint;
 file "root.hints";
};
zone "0.0.127.in-addr.arpa" {
 type master;
 file "pz/127.0.0";
};
// Bind 9 now logs by default through syslog (except debug).
// These are the default logging rules.
logging {
 category default { default_syslog; default_debug; };
 category unmatched { null; };
 channel default_syslog {
 syslog daemon; // send to syslog's daemon
 // facility
 severity info; // only send priority info
 // and higher
 };
 channel default_debug {
 file "named.run"; // write to named.run in
 // the working directory
 // Note: stderr is used instead
 // of "named.run"
 // if the server is started
 // with the '-f' option.
 severity dynamic; // log at the server's
 // current debug level
 };
 channel default_stderr {
 stderr; // writes to stderr
 severity info; // only send priority info
 // and higher
 };
 channel null {
 null; // toss anything sent to
 // this channel
 };
};
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /srv/named/etc/namedb/pz/127.0.0 << "EOF"
$TTL 3D
@ IN SOA ns.local.domain. hostmaster.local.domain. (
 1 ; Serial
 8H ; Refresh
 2H ; Retry
 4W ; Expire
 1D) ; Minimum TTL
 NS ns.local.domain.
1 PTR localhost.
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /srv/named/etc/namedb/root.hints << "EOF"
. 6D IN NS A.ROOT-SERVERS.NET.
. 6D IN NS B.ROOT-SERVERS.NET.
. 6D IN NS C.ROOT-SERVERS.NET.
. 6D IN NS D.ROOT-SERVERS.NET.
. 6D IN NS E.ROOT-SERVERS.NET.
. 6D IN NS F.ROOT-SERVERS.NET.
. 6D IN NS G.ROOT-SERVERS.NET.
. 6D IN NS H.ROOT-SERVERS.NET.
. 6D IN NS I.ROOT-SERVERS.NET.
. 6D IN NS J.ROOT-SERVERS.NET.
. 6D IN NS K.ROOT-SERVERS.NET.
. 6D IN NS L.ROOT-SERVERS.NET.
. 6D IN NS M.ROOT-SERVERS.NET.
A.ROOT-SERVERS.NET. 6D IN A 198.41.0.4
A.ROOT-SERVERS.NET. 6D IN AAAA 2001:503:ba3e::2:30
B.ROOT-SERVERS.NET. 6D IN A 192.228.79.201
B.ROOT-SERVERS.NET. 6D IN AAAA 2001:500:200::b
C.ROOT-SERVERS.NET. 6D IN A 192.33.4.12
C.ROOT-SERVERS.NET. 6D IN AAAA 2001:500:2::c
D.ROOT-SERVERS.NET. 6D IN A 199.7.91.13
D.ROOT-SERVERS.NET. 6D IN AAAA 2001:500:2d::d
E.ROOT-SERVERS.NET. 6D IN A 192.203.230.10
E.ROOT-SERVERS.NET. 6D IN AAAA 2001:500:a8::e
F.ROOT-SERVERS.NET. 6D IN A 192.5.5.241
F.ROOT-SERVERS.NET. 6D IN AAAA 2001:500:2f::f
G.ROOT-SERVERS.NET. 6D IN A 192.112.36.4
G.ROOT-SERVERS.NET. 6D IN AAAA 2001:500:12::d0d
H.ROOT-SERVERS.NET. 6D IN A 198.97.190.53
H.ROOT-SERVERS.NET. 6D IN AAAA 2001:500:1::53
I.ROOT-SERVERS.NET. 6D IN A 192.36.148.17
I.ROOT-SERVERS.NET. 6D IN AAAA 2001:7fe::53
J.ROOT-SERVERS.NET. 6D IN A 192.58.128.30
J.ROOT-SERVERS.NET. 6D IN AAAA 2001:503:c27::2:30
K.ROOT-SERVERS.NET. 6D IN A 193.0.14.129
K.ROOT-SERVERS.NET. 6D IN AAAA 2001:7fd::1
L.ROOT-SERVERS.NET. 6D IN A 199.7.83.42
L.ROOT-SERVERS.NET. 6D IN AAAA 2001:500:9f::42
M.ROOT-SERVERS.NET. 6D IN A 202.12.27.33
M.ROOT-SERVERS.NET. 6D IN AAAA 2001:dc3::35
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cp /etc/resolv.conf /etc/resolv.conf.bak &&
cat > /etc/resolv.conf << "EOF"
search <em class="replaceable"><code><yourdomain.com></em>
nameserver 127.0.0.1
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
chown -R named:named /srv/named

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
make install-named

cd ..
rm -rf blfs-systemd-units-20180105
popd
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl start named

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


dig -x 127.0.0.1


dig www.linuxfromscratch.org &&
dig www.linuxfromscratch.org




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
