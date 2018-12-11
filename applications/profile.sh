#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="%DESCRIPTION%"
SECTION="postlfs"
NAME="profile"



cd $SOURCE_DIR

URL=

if [ ! -z $URL ]
then

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/profile << "EOF"
# Begin /etc/profile
# Written for Beyond Linux From Scratch
# by James Robertson <jameswrobertson@earthlink.net>
# modifications by Dagmar d'Surreal <rivyqntzne@pbzpnfg.arg>
# System wide environment variables and startup programs.
# System wide aliases and functions should go in /etc/bashrc. Personal
# environment variables and startup programs should go into
# ~/.bash_profile. Personal aliases and functions should go into
# ~/.bashrc.
# Functions to help us manage paths. Second argument is the name of the
# path variable to be modified (default: PATH)
pathremove () {
 local IFS=':'
 local NEWPATH
 local DIR
 local PATHVARIABLE=${2:-PATH}
 for DIR in ${!PATHVARIABLE} ; do
 if [ "$DIR" != "$1" ] ; then
 NEWPATH=${NEWPATH:+$NEWPATH:}$DIR
 fi
 done
 export $PATHVARIABLE="$NEWPATH"
}
pathprepend () {
 pathremove $1 $2
 local PATHVARIABLE=${2:-PATH}
 export $PATHVARIABLE="$1${!PATHVARIABLE:+:${!PATHVARIABLE}}"
}
pathappend () {
 pathremove $1 $2
 local PATHVARIABLE=${2:-PATH}
 export $PATHVARIABLE="${!PATHVARIABLE:+${!PATHVARIABLE}:}$1"
}
export -f pathremove pathprepend pathappend
# Set the initial path
export PATH=/bin:/usr/bin
if [ $EUID -eq 0 ] ; then
 pathappend /sbin:/usr/sbin
 unset HISTFILE
fi
# Setup some environment variables.
export HISTSIZE=1000
export HISTIGNORE="&:[bf]g:exit"
# Set some defaults for graphical systems
export XDG_DATA_DIRS=${XDG_DATA_DIRS:-/usr/share/}
export XDG_CONFIG_DIRS=${XDG_CONFIG_DIRS:-/etc/xdg/}
export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-/tmp/xdg-$USER}
# Setup a red prompt for root and a green one for users.
NORMAL="\[\e[0m\]"
RED="\[\e[1;31m\]"
GREEN="\[\e[1;32m\]"
if [[ $EUID == 0 ]] ; then
 PS1="$RED\u [ $NORMAL\w$RED ]# $NORMAL"
else
 PS1="$GREEN\u [ $NORMAL\w$GREEN ]\$ $NORMAL"
fi
for script in /etc/profile.d/*.sh ; do
 if [ -r $script ] ; then
 . $script
 fi
done
unset script RED GREEN NORMAL
# End /etc/profile
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install --directory --mode=0755 --owner=root --group=root /etc/profile.d

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/profile.d/bash_completion.sh << "EOF"
# Begin /etc/profile.d/bash_completion.sh
# Import bash completion scripts
for script in /etc/bash_completion.d/*.sh ; do
 if [ -r $script ] ; then
 . $script
 fi
done
# End /etc/profile.d/bash_completion.sh
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install --directory --mode=0755 --owner=root --group=root /etc/bash_completion.d

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/profile.d/dircolors.sh << "EOF"
# Setup for /bin/ls and /bin/grep to support color, the alias is in /etc/bashrc.
if [ -f "/etc/dircolors" ] ; then
 eval $(dircolors -b /etc/dircolors)
fi
if [ -f "$HOME/.dircolors" ] ; then
 eval $(dircolors -b $HOME/.dircolors)
fi
alias ls='ls --color=auto'
alias grep='grep --color=auto'
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/profile.d/extrapaths.sh << "EOF"
if [ -d /usr/local/lib/pkgconfig ] ; then
 pathappend /usr/local/lib/pkgconfig PKG_CONFIG_PATH
fi
if [ -d /usr/local/bin ]; then
 pathprepend /usr/local/bin
fi
if [ -d /usr/local/sbin -a $EUID -eq 0 ]; then
 pathprepend /usr/local/sbin
fi
# Set some defaults before other applications add to these paths.
pathappend /usr/share/man MANPATH
pathappend /usr/share/info INFOPATH
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/profile.d/readline.sh << "EOF"
# Setup the INPUTRC environment variable.
if [ -z "$INPUTRC" -a ! -f "$HOME/.inputrc" ] ; then
 INPUTRC=/etc/inputrc
fi
export INPUTRC
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/profile.d/umask.sh << "EOF"
# By default, the umask should be set.
if [ "$(id -gn)" = "$(id -un)" -a $EUID -gt 99 ] ; then
 umask 002
else
 umask 022
fi
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/bashrc << "EOF"
# Begin /etc/bashrc
# Written for Beyond Linux From Scratch
# by James Robertson <jameswrobertson@earthlink.net>
# updated by Bruce Dubbs <bdubbs@linuxfromscratch.org>
# System wide aliases and functions.
# System wide environment variables and startup programs should go into
# /etc/profile. Personal environment variables and startup programs
# should go into ~/.bash_profile. Personal aliases and functions should
# go into ~/.bashrc
# Provides colored /bin/ls and /bin/grep commands. Used in conjunction
# with code in /etc/profile.
alias ls='ls --color=auto'
alias grep='grep --color=auto'
# Provides prompt for non-login shells, specifically shells started
# in the X environment. [Review the LFS archive thread titled
# PS1 Environment Variable for a great case study behind this script
# addendum.]
NORMAL="\[\e[0m\]"
RED="\[\e[1;31m\]"
GREEN="\[\e[1;32m\]"
if [[ $EUID == 0 ]] ; then
 PS1="$RED\u [ $NORMAL\w$RED ]# $NORMAL"
else
 PS1="$GREEN\u [ $NORMAL\w$GREEN ]\$ $NORMAL"
fi
unset RED GREEN NORMAL
# End /etc/bashrc
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cat > ~/.bash_profile << "EOF"
# Begin ~/.bash_profile
# Written for Beyond Linux From Scratch
# by James Robertson <jameswrobertson@earthlink.net>
# updated by Bruce Dubbs <bdubbs@linuxfromscratch.org>
# Personal environment variables and startup programs.
# Personal aliases and functions should go in ~/.bashrc. System wide
# environment variables and startup programs are in /etc/profile.
# System wide aliases and functions are in /etc/bashrc.
if [ -f "$HOME/.bashrc" ] ; then
 source $HOME/.bashrc
fi
if [ -d "$HOME/bin" ] ; then
 pathprepend $HOME/bin
fi
# Having . in the PATH is dangerous
#if [ $EUID -gt 99 ]; then
# pathappend .
#fi
# End ~/.bash_profile
EOF


cat > ~/.profile << "EOF"
# Begin ~/.profile
# Personal environment variables and startup programs.
if [ -d "$HOME/bin" ] ; then
 pathprepend $HOME/bin
fi
# Set up user specific i18n variables
#export LANG=<em class="replaceable"><code><ll></em>_<em class="replaceable"><code><CC></em>.<em class="replaceable"><code><charmap></em><em class="replaceable"><code><@modifiers></em>
# End ~/.profile
EOF


cat > ~/.bashrc << "EOF"
# Begin ~/.bashrc
# Written for Beyond Linux From Scratch
# by James Robertson <jameswrobertson@earthlink.net>
# Personal aliases and functions.
# Personal environment variables and startup programs should go in
# ~/.bash_profile. System wide environment variables and startup
# programs are in /etc/profile. System wide aliases and functions are
# in /etc/bashrc.
if [ -f "/etc/bashrc" ] ; then
 source /etc/bashrc
fi
# Set up user specific i18n variables
#export LANG=<em class="replaceable"><code><ll></em>_<em class="replaceable"><code><CC></em>.<em class="replaceable"><code><charmap></em><em class="replaceable"><code><@modifiers></em>
# End ~/.bashrc
EOF


cat > ~/.bash_logout << "EOF"
# Begin ~/.bash_logout
# Written for Beyond Linux From Scratch
# by James Robertson <jameswrobertson@earthlink.net>
# Personal items to perform on logout.
# End ~/.bash_logout
EOF



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
dircolors -p > /etc/dircolors

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/profile.d/i18n.sh << EOF
# Set up i18n variables
export LANG=$LANG
EOF
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mkdir -pv /etc/skel
cp -v ~/.bash* /etc/skel/
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
