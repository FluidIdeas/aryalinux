#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

cd $SOURCE_DIR
NAME=python-dependencies
VERSION=1.0.0
URL=https://files.pythonhosted.org/packages/source/a/alabaster/alabaster-1.0.0.tar.gz
SECTION="Programming"
DESCRIPTION="Python modules listed in Python Modules have dependencies that are not referenced by other packages in BLFS. These dependencies are listed here."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://files.pythonhosted.org/packages/source/a/alabaster/alabaster-1.0.0.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/a/attrs/attrs-25.4.0.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/B/Babel/babel-2.18.0.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/c/certifi/certifi-2026.1.4.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/c/chardet/chardet-5.2.0.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/c/charset-normalizer/charset_normalizer-3.4.4.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/c/commonmark/commonmark-0.9.1.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/e/editables/editables-0.5.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/h/hatch-fancy-pypi-readme/hatch_fancy_pypi_readme-25.1.0.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/h/hatch-vcs/hatch_vcs-0.5.0.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/h/hatchling/hatchling-1.28.0.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/i/idna/idna-3.11.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/i/imagesize/imagesize-1.4.1.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/i/iniconfig/iniconfig-2.3.0.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/M/Markdown/markdown-3.10.2.tar.gz
wget -nc https://github.com/PyO3/maturin/archive/v1.12.3/maturin-1.12.3.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/m/meson_python/meson_python-0.19.0.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/m/msgpack/msgpack-1.1.2.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/p/pathspec/pathspec-1.0.4.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/p/pluggy/pluggy-1.6.0.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/p/pyproject-hooks/pyproject_hooks-1.2.0.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/p/pyproject-metadata/pyproject_metadata-0.11.0.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/p/pytz/pytz-2025.2.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/r/roman-numerals/roman_numerals-4.1.0.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/s/sphinxcontrib-applehelp/sphinxcontrib_applehelp-2.0.0.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/s/sphinxcontrib-devhelp/sphinxcontrib_devhelp-2.0.0.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/s/sphinxcontrib-htmlhelp/sphinxcontrib_htmlhelp-2.1.0.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/s/sphinxcontrib-jquery/sphinxcontrib-jquery-4.1.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/s/sphinxcontrib-jsmath/sphinxcontrib-jsmath-1.0.1.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/s/sphinxcontrib-qthelp/sphinxcontrib_qthelp-2.0.0.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/s/sphinxcontrib_serializinghtml/sphinxcontrib_serializinghtml-2.0.0.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/s/semantic_version/semantic_version-2.10.0.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/s/setuptools_rust/setuptools_rust-1.12.0.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/s/setuptools_scm/setuptools_scm-9.2.2.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/s/smartypants/smartypants-2.0.2.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/s/snowballstemmer/snowballstemmer-3.0.1.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/t/trove_classifiers/trove_classifiers-2026.1.14.14.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/t/typogrify/typogrify-2.1.0.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/u/urllib3/urllib3-2.6.3.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/u/uv_build/uv_build-0.10.2.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/w/webencodings/webencodings-0.5.1.tar.gz

wget -nc https://files.pythonhosted.org/packages/source/a/alabaster/alabaster-1.0.0.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/a/attrs/attrs-25.4.0.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/B/Babel/babel-2.18.0.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/c/certifi/certifi-2026.1.4.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/c/chardet/chardet-5.2.0.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/c/charset-normalizer/charset_normalizer-3.4.4.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/c/commonmark/commonmark-0.9.1.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/e/editables/editables-0.5.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/h/hatch-fancy-pypi-readme/hatch_fancy_pypi_readme-25.1.0.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/h/hatch-vcs/hatch_vcs-0.5.0.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/h/hatchling/hatchling-1.28.0.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/i/idna/idna-3.11.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/i/imagesize/imagesize-1.4.1.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/i/iniconfig/iniconfig-2.3.0.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/M/Markdown/markdown-3.10.2.tar.gz
wget -nc https://github.com/PyO3/maturin/archive/v1.12.3/maturin-1.12.3.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/m/meson_python/meson_python-0.19.0.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/m/msgpack/msgpack-1.1.2.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/p/pathspec/pathspec-1.0.4.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/p/pluggy/pluggy-1.6.0.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/p/pyproject-hooks/pyproject_hooks-1.2.0.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/p/pyproject-metadata/pyproject_metadata-0.11.0.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/p/pytz/pytz-2025.2.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/r/roman-numerals/roman_numerals-4.1.0.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/s/sphinxcontrib-applehelp/sphinxcontrib_applehelp-2.0.0.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/s/sphinxcontrib-devhelp/sphinxcontrib_devhelp-2.0.0.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/s/sphinxcontrib-htmlhelp/sphinxcontrib_htmlhelp-2.1.0.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/s/sphinxcontrib-jquery/sphinxcontrib-jquery-4.1.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/s/sphinxcontrib-jsmath/sphinxcontrib-jsmath-1.0.1.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/s/sphinxcontrib-qthelp/sphinxcontrib_qthelp-2.0.0.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/s/sphinxcontrib_serializinghtml/sphinxcontrib_serializinghtml-2.0.0.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/s/semantic_version/semantic_version-2.10.0.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/s/setuptools_rust/setuptools_rust-1.12.0.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/s/setuptools_scm/setuptools_scm-9.2.2.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/s/smartypants/smartypants-2.0.2.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/s/snowballstemmer/snowballstemmer-3.0.1.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/t/trove_classifiers/trove_classifiers-2026.1.14.14.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/t/typogrify/typogrify-2.1.0.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/u/urllib3/urllib3-2.6.3.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/u/uv_build/uv_build-0.10.2.tar.gz
wget -nc https://files.pythonhosted.org/packages/source/w/webencodings/webencodings-0.5.1.tar.gz

echo $USER > /tmp/currentuser

echo $USER > /tmp/currentuser

# --- alabaster ---
TARBALL=alabaster-1.0.0.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
sudo rm -rf $DIRECTORY
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-user alabaster
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

# --- attrs ---
TARBALL=attrs-25.4.0.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
sudo rm -rf $DIRECTORY
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
python3 -m venv --system-site-packages testenv
testenv/bin/pip3 install --group mypy
PATH=$PWD/testenv/bin:$PATH testenv/bin/python -m pytest
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-user attrs
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

# --- babel ---
TARBALL=babel-2.18.0.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
sudo rm -rf $DIRECTORY
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
python3 -m venv --system-site-packages testenv
source testenv/bin/activate
pip3 install pytest-cov freezegun
python3 /usr/bin/pytest
deactivate
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-user Babel
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

# --- certifi ---
TARBALL=certifi-2026.1.4.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
sudo rm -rf $DIRECTORY
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-user certifi
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

# --- chardet ---
TARBALL=chardet-5.2.0.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
sudo rm -rf $DIRECTORY
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-user chardet
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

# --- charset-normalizer ---
TARBALL=charset_normalizer-3.4.4.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
sudo rm -rf $DIRECTORY
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
python3 -m venv --system-site-packages testenv
source testenv/bin/activate
pip3 install pytest-cov
python3 /usr/bin/pytest
deactivate
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-user charset-normalizer
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

# --- commonmark ---
TARBALL=commonmark-0.9.1.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
sudo rm -rf $DIRECTORY
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
python3 -m venv --system-site-packages testenv
source testenv/bin/activate
pip3 install hypothesis
python3 /usr/bin/pytest commonmark/tests/unit_tests.py
python3 commonmark/tests/run_spec_tests.py
deactivate
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-user commonmark
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

# --- editables ---
TARBALL=editables-0.5.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
sudo rm -rf $DIRECTORY
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-user editables
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

# --- hatch-fancy-pypi-readme ---
TARBALL=hatch_fancy_pypi_readme-25.1.0.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
sudo rm -rf $DIRECTORY
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-user hatch-fancy-pypi-readme
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

# --- hatch-vcs ---
TARBALL=hatch_vcs-0.5.0.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
sudo rm -rf $DIRECTORY
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-user hatch_vcs
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

# --- hatchling ---
TARBALL=hatchling-1.28.0.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
sudo rm -rf $DIRECTORY
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-user hatchling
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

# --- idna ---
TARBALL=idna-3.11.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
sudo rm -rf $DIRECTORY
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-user idna
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

# --- imagesize ---
TARBALL=imagesize-1.4.1.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
sudo rm -rf $DIRECTORY
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-user imagesize
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

# --- iniconfig ---
TARBALL=iniconfig-2.3.0.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
sudo rm -rf $DIRECTORY
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-user iniconfig
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

# --- markdown ---
TARBALL=markdown-3.10.2.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
sudo rm -rf $DIRECTORY
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
python3 -m venv --system-site-packages testenv
source testenv/bin/activate
pip3 install coverage
python3 /usr/bin/pytest --ignore=tests/test_syntax/extensions/test_md_in_html.py
deactivate
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-user Markdown
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

# --- maturin ---
TARBALL=maturin-1.12.3.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
sudo rm -rf $DIRECTORY
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
python3 -m venv --system-site-packages testenv
testenv/bin/pip3 install cffi pycparser virtualenv
PATH=$PWD/testenv/bin:$PATH cargo test
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-user maturin
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

# --- meson_python ---
TARBALL=meson_python-0.19.0.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
sudo rm -rf $DIRECTORY
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
python3 -m venv --system-site-packages testenv
testenv/bin/pip3 install --group=test
HOME= testenv/bin/python -m pytest
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-user meson_python
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

# --- msgpack ---
TARBALL=msgpack-1.1.2.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
sudo rm -rf $DIRECTORY
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-user msgpack
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

# --- pathspec ---
TARBALL=pathspec-1.0.4.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
sudo rm -rf $DIRECTORY
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-user pathspec
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

# --- pluggy ---
TARBALL=pluggy-1.6.0.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
sudo rm -rf $DIRECTORY
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-user pluggy
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

# --- pyproject-hooks ---
TARBALL=pyproject_hooks-1.2.0.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
sudo rm -rf $DIRECTORY
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
python3 -m venv --system-site-packages testenv
source testenv/bin/activate
pip3 install testpath
python3 -m pytest
deactivate
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-user pyproject_hooks
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

# --- pyproject-metadata ---
TARBALL=pyproject_metadata-0.11.0.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
sudo rm -rf $DIRECTORY
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
python3 -m venv --system-site-packages testenv
testenv/bin/pip3 install exceptiongroup
testenv/bin/python3 -m pytest
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-user pyproject-metadata
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

# --- pytz ---
TARBALL=pytz-2025.2.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
sudo rm -rf $DIRECTORY
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-user pytz
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

# --- roman-numerals ---
TARBALL=roman_numerals-4.1.0.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
sudo rm -rf $DIRECTORY
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-user roman-numerals
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

# --- sc-applehelp ---
TARBALL=sphinxcontrib_applehelp-2.0.0.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
sudo rm -rf $DIRECTORY
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-user sphinxcontrib-applehelp
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

# --- sc-devhelp ---
TARBALL=sphinxcontrib_devhelp-2.0.0.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
sudo rm -rf $DIRECTORY
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-user sphinxcontrib-devhelp
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

# --- sc-htmlhelp ---
TARBALL=sphinxcontrib_htmlhelp-2.1.0.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
sudo rm -rf $DIRECTORY
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
sed -i 's/keyword/pair: keyword;/' tests/roots/test-chm/index.rst
pytest
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-user sphinxcontrib-htmlhelp
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

# --- sc-jquery ---
TARBALL=sphinxcontrib-jquery-4.1.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
sudo rm -rf $DIRECTORY
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-user sphinxcontrib-jquery
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

# --- sc-jsmath ---
TARBALL=sphinxcontrib-jsmath-1.0.1.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
sudo rm -rf $DIRECTORY
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

patch -Np1 -i ../sphinxcontrib-jsmath-1.0.1-sphinx9_fixes-1.patch
pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
pytest
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-user sphinxcontrib-jsmath
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

# --- sc-qthelp ---
TARBALL=sphinxcontrib_qthelp-2.0.0.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
sudo rm -rf $DIRECTORY
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
python3 -m venv --system-site-packages testenv
testenv/bin/pip3 install defusedxml
testenv/bin/python -m pytest
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-user sphinxcontrib-qthelp
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

# --- sc-serializinghtml ---
TARBALL=sphinxcontrib_serializinghtml-2.0.0.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
sudo rm -rf $DIRECTORY
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-user sphinxcontrib-serializinghtml
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

# --- semantic_version ---
TARBALL=semantic_version-2.10.0.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
sudo rm -rf $DIRECTORY
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-user semantic_version
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

# --- setuptools_rust ---
TARBALL=setuptools_rust-1.12.0.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
sudo rm -rf $DIRECTORY
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-user setuptools_rust
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

# --- setuptools_scm ---
TARBALL=setuptools_scm-9.2.2.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
sudo rm -rf $DIRECTORY
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
python3 -m venv --system-site-packages testenv
testenv/bin/pip3 install --group test
TZ=UTC HOME= testenv/bin/python3 -m pytest
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-user setuptools_scm
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

# --- smartypants ---
TARBALL=smartypants-2.0.2.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
sudo rm -rf $DIRECTORY
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
cp /usr/bin/smartypants .
pytest
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-user smartypants
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

# --- snowballstemmer ---
TARBALL=snowballstemmer-3.0.1.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
sudo rm -rf $DIRECTORY
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-user snowballstemmer
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

# --- trove-classifiers ---
TARBALL=trove_classifiers-2026.1.14.14.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
sudo rm -rf $DIRECTORY
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

sed -i '/calver/s/^/#/;$iversion="2026.1.14.14"' setup.py
pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-user trove-classifiers
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

# --- typogrify ---
TARBALL=typogrify-2.1.0.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
sudo rm -rf $DIRECTORY
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-user typogrify
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

# --- urllib3 ---
TARBALL=urllib3-2.6.3.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
sudo rm -rf $DIRECTORY
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
python3 -m venv --system-site-packages testenv
source testenv/bin/activate
pip3 install --group dev
python3 /usr/bin/pytest --timeout 10
deactivate
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-user urllib3
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

# --- uv_build ---
TARBALL=uv_build-0.10.2.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
sudo rm -rf $DIRECTORY
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-user uv_build
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

# --- webencodings ---
TARBALL=webencodings-0.5.1.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
sudo rm -rf $DIRECTORY
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-user webencodings
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd