#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf


cd $SOURCE_DIR


NAME=la-files
VERSION=""
URL=""

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


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
cat > /usr/sbin/remove-la-files.sh << "EOF"
#!/bin/bash

# /usr/sbin/remove-la-files.sh
# Written for Beyond Linux From Scratch
# by Bruce Dubbs <bdubbs@linuxfromscratch.org>

# Make sure we are running with root privs
if test "${EUID}" -ne 0; then
echo "Error: $(basename ${0}) must be run as the root user! Exiting..."
exit 1
fi

# Make sure PKG_CONFIG_PATH is set if discarded by sudo
source /etc/profile

OLD_LA_DIR=/var/local/la-files

mkdir -p $OLD_LA_DIR

# Only search directories in /opt, but not symlinks to directories
OPTDIRS=$(find /opt -mindepth 1 -maxdepth 1 -type d)

# Move any found .la files to a directory out of the way
find /usr/lib $OPTDIRS -name "*.la" ! -path "/usr/lib/ImageMagick*" \
-exec mv -fv {} $OLD_LA_DIR \;
###############

# Fix any .pc files that may have .la references

STD_PC_PATH='/usr/lib/pkgconfig 
/usr/share/pkgconfig 
/usr/local/lib/pkgconfig 
/usr/local/share/pkgconfig'

# For each directory that can have .pc files
for d in $(echo $PKG_CONFIG_PATH | tr : ' ') $STD_PC_PATH; do

# For each pc file
for pc in $d/*.pc ; do
if [ $pc == "$d/*.pc" ]; then continue; fi

# Check each word in a line with a .la reference
for word in $(grep '\.la' $pc); do
if $(echo $word | grep -q '.la$' ); then
mkdir -p $d/la-backup
cp -fv $pc $d/la-backup

basename=$(basename $word )
libref=$(echo $basename|sed -e 's/^lib/-l/' -e 's/\.la$//')

# Fix the .pc file
sed -i "s:$word:$libref:" $pc
fi
done
done
done

EOF

chmod +x /usr/sbin/remove-la-files.sh
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
