#!/bin/bash

set -e

. /sources/build-properties

# Building additional temp tools
for script in /sources/additional-temp-tools/*
do
	bash $script
done

# Building the final system
for script in /sources/final-system/*
do
	bash $script
done

# LFS 8.86 cleanup
rm -rf /tmp/{*,.*} 2>/dev/null || true
find /usr/lib /usr/libexec -name '*.la' -delete 2>/dev/null || true
find /usr -depth -name $(uname -m)-lfs-linux-gnu\* -exec rm -rf {} + 2>/dev/null || true
userdel -r tester 2>/dev/null || true
