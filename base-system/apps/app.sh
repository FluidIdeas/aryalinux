#!/bin/bash

set -e
set +h

PACKAGE="$2"

make-ca -g -f

# alps install writes to / and must run as root in the chroot (no sudo/PAM).
alps -ni install $PACKAGE
if [ ! -f "/var/lib/alps/installed/${PACKAGE}.json" ]
then
	echo "Application installation incomplete ($PACKAGE). Aborting..."
	exit 1
fi
