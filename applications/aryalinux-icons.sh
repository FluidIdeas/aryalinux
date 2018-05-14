#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="aryalinux-icons"
DESCRIPTION="Icons collection for AryaLinux XFCE and Mate Desktops"
VERSION="2016.08"

#REQ:numix-icons

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
