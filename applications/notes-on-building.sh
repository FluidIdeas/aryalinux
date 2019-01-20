#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions


cd $SOURCE_DIR


NAME=notes-on-building
VERSION=""
URL=""

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

tar -xvf filename.tar.gz
tar -xvf filename.tgz
tar -xvf filename.tar.Z
tar -xvf filename.tar.bz2
bzcat filename.tar.bz2 | tar -xv
gunzip -v patchname.gz
bunzip2 -v patchname.bz2
md5sum -c file.md5sum
md5sum <em class="replaceable"><code><name_of_downloaded_file></code></em>
( <em class="replaceable"><code><command></code></em> 2>&1 | tee compile.log && exit $PIPESTATUS )
export MAKEFLAGS='-j2'
make -j2
make check < ../cups-1.1.23-testsuite_parms
cat > blfs-yes-test1 << "EOF"
#!/bin/bash

echo -n -e "\n\nPlease type something (or nothing) and press Enter ---> "

read A_STRING

if test "$A_STRING" = ""; then A_STRING="Just the Enter key was pressed"
else A_STRING="You entered '$A_STRING'"
fi

echo -e "\n\n$A_STRING\n\n"
EOF
chmod 755 blfs-yes-test1
yes | ./blfs-yes-test1
yes 'This is some text' | ./blfs-yes-test1
yes '' | ./blfs-yes-test1
ls -l /usr/bin | more
ls -l /usr/bin | more > redirect_test.log 2>&1
cat > blfs-yes-test2 << "EOF"
#!/bin/bash

ls -l /usr/bin | more

echo -n -e "\n\nDid you enjoy reading this? (y,n) "

read A_STRING

if test "$A_STRING" = "y"; then A_STRING="You entered the 'y' key"
else A_STRING="You did NOT enter the 'y' key"
fi

echo -e "\n\n$A_STRING\n\n"
EOF
chmod 755 blfs-yes-test2
yes | ./blfs-yes-test2 > blfs-yes-test2.log 2>&1
find /{,usr/}{bin,lib,sbin} -type f -exec strip --strip-unneeded {} \;

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
