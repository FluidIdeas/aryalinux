#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:dbus
#REQ:glib2
#REQ:python-modules#pygobject3
#REQ:cairo
#REQ:glib2
#REQ:python-modules#pycairo
#REQ:gobject-introspection
#REQ:python-modules#pycairo
#REQ:python-modules#pygobject2
#REQ:atk
#REQ:pango
#REQ:python-modules#pycairo
#REQ:pango
#REQ:python-modules#pycairo
#REQ:gtk2
#REQ:python-modules#pycairo
#REQ:libglade
#REQ:libxml2
#REQ:python2
#REQ:libxslt
#REQ:python-modules#MarkupSafe
#REQ:python-modules#Beaker
#REQ:python-modules#MarkupSafe
#REQ:yaml
#REC:python2
#REC:at-spi2-core
#REC:python2
#OPT:python2
#OPT:python-modules#docutils
#OPT:python2
#OPT:python2
#OPT:gobject-introspection
#OPT:libxslt
#OPT:libxslt
#OPT:python2
#OPT:python-modules#funcsigs
#OPT:gdb
#OPT:valgrind
#OPT:python2
#OPT:python-modules#six
#OPT:python2

cd $SOURCE_DIR

wget -nc https://dbus.freedesktop.org/releases/dbus-python/dbus-python-1.2.8.tar.gz
wget -nc http://downloads.sourceforge.net/docutils/docutils-0.14.tar.gz
wget -nc http://ftp.gnome.org/pub/gnome/sources/pyatspi/2.30/pyatspi-2.30.0.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/pyatspi/2.30/pyatspi-2.30.0.tar.xz
wget -nc https://github.com/pygobject/pycairo/releases/download/v1.17.1/pycairo-1.17.1.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/p/pycrypto/pycrypto-2.6.1.tar.gz
wget -nc http://ftp.gnome.org/pub/gnome/sources/pygobject/2.28/pygobject-2.28.7.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/pygobject/2.28/pygobject-2.28.7.tar.xz
wget -nc http://ftp.gnome.org/pub/gnome/sources/pygobject/3.30/pygobject-3.30.1.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/pygobject/3.30/pygobject-3.30.1.tar.xz
wget -nc http://ftp.gnome.org/pub/gnome/sources/pygtk/2.24/pygtk-2.24.0.tar.bz2
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/pygtk/2.24/pygtk-2.24.0.tar.bz2
wget -nc https://people.freedesktop.org/~takluyver/pyxdg-0.25.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/f/funcsigs/funcsigs-1.0.2.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/B/Beaker/Beaker-1.10.0.tar.gz
wget -nc http://xmlsoft.org/sources/libxml2-2.9.8.tar.gz
wget -nc ftp://xmlsoft.org/libxml2/libxml2-2.9.8.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/l/lxml/lxml-4.2.5.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/M/MarkupSafe/MarkupSafe-1.0.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/J/Jinja2/Jinja2-2.10.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/M/Mako/Mako-1.0.7.tar.gz
wget -nc http://pyyaml.org/download/pyyaml/PyYAML-3.13.tar.gz
wget -nc https://github.com/scour-project/scour/archive/v0.37/scour-0.37.tar.gz
wget -nc https://pypi.io/packages/source/s/six/six-1.11.0.tar.gz

URL=https://dbus.freedesktop.org/releases/dbus-python/dbus-python-1.2.8.tar.gz

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

mkdir python2 &&
pushd python2 &&
PYTHON=/usr/bin/python     \
../configure --prefix=/usr --docdir=/usr/share/doc/dbus-python-1.2.8 &&
make &&
popd
mkdir python3 &&
pushd python3 &&
PYTHON=/usr/bin/python3    \
../configure --prefix=/usr --docdir=/usr/share/doc/dbus-python-1.2.8 &&
make &&
popd

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make -C python2 install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make -C python3 install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

python setup.py build

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
python setup.py install --optimize=1 &&

for f in /usr/bin/rst*.py; do
  ln -svf $(basename $f) /usr/bin/$(basename $f .py)
done
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

mkdir python2 &&
pushd python2 &&
../configure --prefix=/usr --with-python=/usr/bin/python &&
popd
mkdir python3 &&
pushd python3 &&
../configure --prefix=/usr --with-python=/usr/bin/python3 &&
popd

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make -C python2 install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make -C python3 install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

python2 setup.py build

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
python2 setup.py install --optimize=1   &&
python2 setup.py install_pycairo_header &&
python2 setup.py install_pkgconfig
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

python3 setup.py build

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
python3 setup.py install --optimize=1   &&
python3 setup.py install_pycairo_header &&
python3 setup.py install_pkgconfig
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

python setup.py build

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
python setup.py install --optimize=1
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

python3 setup.py build

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
python3 setup.py install --optimize=1
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

./configure --prefix=/usr --disable-introspection &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

mkdir python2 &&
pushd python2 &&
meson --prefix=/usr -Dpython=python2 .. &&
ninja &&
popd
mkdir python3 &&
pushd python3 &&
meson --prefix=/usr -Dpython=python3 &&
ninja &&
popd

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
ninja -C python2 install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
ninja -C python3 install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

./configure --prefix=/usr &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
python setup.py install --optimize=1
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
python3 setup.py install --optimize=1
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
python setup.py install --optimize=1
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
python setup.py install --optimize=1
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
python3 setup.py install --optimize=1
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

cd python             &&
python setup.py build

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
python setup.py install --optimize=1
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

python setup.py build

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
python setup.py install --optimize=1
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

python3 setup.py clean &&
python3 setup.py build

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
python3 setup.py install --optimize=1
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

python setup.py build

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
python setup.py install --optimize=1
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

python3 setup.py build

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
python3 setup.py install --optimize=1
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
python setup.py install --optimize=1
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
python3 setup.py install --optimize=1
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
python setup.py install --optimize=1
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
sed -i "s:mako-render:&3:g" setup.py &&
python3 setup.py install --optimize=1
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

python setup.py build

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
python setup.py install --optimize=1
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

python3 setup.py build

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
python3 setup.py install --optimize=1
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

python setup.py build

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
python setup.py install --optimize=1
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

python2 setup.py build

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
python2 setup.py install --optimize=1
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

python3 setup.py build

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
python3 setup.py install --optimize=1
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
