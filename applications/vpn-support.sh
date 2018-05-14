#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="vpn-support"
VERSION="N.A."
META=y

#REQ:vpnc
#REQ:network-manager-vpnc
#REQ:pptp-linux
#REQ:network-manager-pptp
#REQ:openconnect
#REQ:network-manager-openconnect
#REQ:openvpn
#REQ:network-manager-openvpn

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
