#!/bin/bash

. /var/lib/alps/functions
. /etc/alps/alps.conf

NAME=vmware-services
VERSION=1.0

if [ -f /etc/init.d/vmware ]; then

sudo tee /etc/systemd/system/vmware.service << "EOF"
[Unit]
Description=VMware daemon
Requires=vmware-usbarbitrator.service
Before=vmware-usbarbitrator.service
After=network.target

[Service]
ExecStart=/etc/init.d/vmware start
ExecStop=/etc/init.d/vmware stop
PIDFile=/var/lock/subsys/vmware
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable vmware.service
status='1'

fi

if [ -x /usr/bin/vmware-usbarbitrator ]; then

sudo tee /etc/systemd/system/vmware-usbarbitrator.service << "EOF"
[Unit]
Description=VMware USB Arbitrator
Requires=vmware.service
After=vmware.service

[Service]
ExecStart=/usr/bin/vmware-usbarbitrator
ExecStop=/usr/bin/vmware-usbarbitrator --kill
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable vmware-usbarbitrator.service
status='1'

fi

if [ -f /etc/init.d/vmware-workstation-server ]; then

sudo tee /etc/systemd/system/vmware-workstation-server.service << "EOF"
[Unit]
Description=VMware Workstation Server
Requires=vmware.service
After=vmware.service

[Service]
ExecStart=/etc/init.d/vmware-workstation-server start
ExecStop=/etc/init.d/vmware-workstation-server stop
PIDFile=/var/lock/subsys/vmware-workstation-server
RemainAfterExit=yes

[Install]
EOF

sudo systemctl enable vmware-workstation-server.service
status='1'

fi

if [ "x$status" != "x1" ]; then
	echo "VMWare products are not installed. Please install first and then retry."
	exit
fi

echo "$NAME=>$(date)" | sudo tee -a /etc/alps/installed-list
echo "$NAME:$VERSION" | sudo tee -a /etc/alps/versions
