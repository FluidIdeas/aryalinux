#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:libnftnl


cd $SOURCE_DIR

wget -nc https://netfilter.org/projects/nftables/files/nftables-0.9.2.tar.bz2


NAME=nftables
VERSION=0.9.2
URL=https://netfilter.org/projects/nftables/files/nftables-0.9.2.tar.bz2

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


./configure --prefix=/usr     \
            --sbindir=/sbin   \
            --sysconfdir=/etc \
            --with-python-bin=/usr/bin/python3 &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install                   &&
mv /usr/lib/libnftables.so.* /lib &&
ln -sfv ../../lib/$(readlink /usr/lib/libnftables.so) /usr/lib/libnftables.so
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
cat > /etc/nftables/nftables.conf << "EOF"
#!/sbin/nft -f

# You're using the example configuration for a setup of a firewall
# from Beyond Linux From Scratch.
#
# This example is far from being complete, it is only meant
# to be a reference.
#
# Firewall security is a complex issue, that exceeds the scope
# of the configuration rules below.
#
# You can find additional information
# about firewalls in Chapter 4 of the BLFS book.
# http://www.linuxfromscratch.org/blfs

# Drop all existing rules
flush ruleset

# Filter for both ip4 and ip6 (inet)
table inet filter {

        # filter incomming packets
        chain input {

                # Drop everything that doesn't match policy
                type filter hook input priority 0; policy drop;

                # accept packets for established connections
                ct state { established, related } accept

                # Drop packets that have a connection state of invalid
                ct state invalid drop

                # Allow connections to the loopback adapter
                iifname "lo" accept

                # Allow connections to the LAN1 interface
                iifname "LAN1" accept

                # Accept icmp requests
                ip protocol icmp accept

                # Allow ssh connections on LAN1
                iifname "LAN1" tcp dport ssh accept

                # Drop everything else
                drop
        }

        # Allow forwarding for external connections to WAN1
        chain forward {

                # Drop if it doesn't match policy
                type filter hook forward priority 0; policy drop;

                # Accept connections on WAN1
                oifname "WAN1" accept

                # Allow forwarding to another host via this interface
                # Uncomment the following line to allow connections
                # ip daddr 192.168.0.2 ct status dnat accept

                # Allow established and related connections
                iifname "WAN1" ct state { established, related } accept
        }

        # Filter output traffic
        chain output {

                # Allow everything outbound
                type filter hook output priority 0; policy accept;
        }
}

# Allow NAT for ip protocol (both ip4 and ip6)
table ip nat {

        chain prerouting {

                # Accept on inbound interface for policy match
                type nat hook prerouting priority 0; policy accept;

                # Accept http and https on 192.168.0.2
                # Uncomment the following line to allow http and https
                #iifname "WAN1" tcp dport { http, https } dnat to 192.168.0.2
        }

        chain postrouting {

                # accept outbound
                type nat hook postrouting priority 0; policy accept;

                # Masquerade on WAN1 outbound
                oifname "WAN1" masquerade
        }
}
EOF
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

pushd $SOURCE_DIR
wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20191026.tar.xz
tar xf blfs-systemd-units-20191026.tar.xz
cd blfs-systemd-units-20191026
sudo make install-nftables
popd
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

