#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:glib2
#REQ:libgcrypt
#REQ:libtasn1
#REQ:p11-kit
#REQ:gnupg
#REQ:gobject-introspection
#REQ:gtk3
#REQ:libxslt
#REQ:vala
#REQ:make-ca
#REQ:libsoup
#REQ:libarchive
#REQ:libxml2
#REQ:pcre2
#REQ:gnutls
#REQ:itstool
#REQ:dbus-glib
#REQ:polkit
#REQ:json-glib
#REQ:cairo
#REQ:dbus
#REQ:js60
#REQ:iso-codes
#REQ:libseccomp
#REQ:xkeyboard-config
#REQ:bubblewrap
#REQ:webkitgtk
#REQ:clutter
#REQ:clutter-gtk
#REQ:sqlite
#REQ:git
#REQ:x7lib
#REQ:python-modules#pygobject3
#REQ:startup-notification
#REQ:db
#REQ:libical
#REQ:nss
#REQ:icu
#REQ:libcanberra
#REQ:python-modules#python-dbusmock
#REQ:telepathy-glib
#REQ:bluez
#REQ:networkmanager
#REQ:upower
#REQ:gst10-plugins-base
#REQ:exempi
#REQ:ffmpeg
#REQ:flac
#REQ:giflib
#REQ:libexif
#REQ:libgrss
#REQ:libgxps
#REQ:poppler
#REQ:libusb
#REQ:libcdio
#REQ:libgudev
#REQ:systemd
#REQ:udisks2
#REQ:exiv2
#REQ:libnotify
#REQ:desktop-file-utils
#REQ:adwaita-icon-theme
#REQ:linux-pam
#REQ:openssh
#REQ:colord
#REQ:fontconfig
#REQ:geoclue2
#REQ:lcms2
#REQ:librsvg
#REQ:libwacom
#REQ:pulseaudio
#REQ:xorg-wacom-driver
#REQ:alsa
#REQ:cups
#REQ:wayland
#REQ:accountsservice
#REQ:colord-gtk
#REQ:libpwquality
#REQ:mitkrb
#REQ:shared-mime-info
#REQ:samba
#REQ:ibus
#REQ:libhandy
#REQ:modemmanager
#REQ:libxkbcommon
#REQ:pipewire
#REQ:libinput
#REQ:wayland-protocols
#REQ:xorg-server
#REQ:libcroco
#REQ:sassc
#REQ:asciidoc
#REQ:telepathy-mission-control
#REQ:mesa
#REQ:keyutils
#REQ:libdaemon
#REQ:libburn
#REQ:libisoburn
#REQ:libisofs
#REQ:dvd-rw-tools
#REQ:clutter-gst
#REQ:gst10-plugins-bad
#REQ:gst10-plugins-good
#REQ:v4l-utils
#REQ:libjpeg
#REQ:openjpeg2
#REQ:bogofilter
#REQ:enchant
#REQ:gspell
#REQ:highlight
#REQ:openldap
#REQ:cpio
#REQ:gtksourceview4
#REQ:libdvdread
#REQ:gtkmm3
#REQ:sound-theme-freedesktop
#REQ:unzip
#REQ:wget
#REQ:gpgme
#REQ:gtk-vnc

cd $SOURCE_DIR

NAME="gnome-desktop-meta"
VERSION="3.36"
DESCRIPTION="GNOME is a free and open-source desktop environment for Unix-like operating systems. GNOME was originally an acronym for GNU Network Object Model Environment, but the acronym was dropped because it no longer reflected the vision of the GNOME project."

urls="http://ftp.gnome.org/pub/gnome/sources/gcr/3.36/gcr-3.36.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/gsettings-desktop-schemas/3.36/gsettings-desktop-schemas-3.36.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/libsecret/0.20/libsecret-0.20.2.tar.xz
http://ftp.gnome.org/pub/gnome/sources/rest/0.8/rest-0.8.1.tar.xz
http://ftp.gnome.org/pub/gnome/sources/totem-pl-parser/3.26/totem-pl-parser-3.26.5.tar.xz
http://ftp.gnome.org/pub/gnome/sources/vte/0.60/vte-0.60.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/yelp-xsl/3.36/yelp-xsl-3.36.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/GConf/3.2/GConf-3.2.6.tar.xz
http://ftp.gnome.org/pub/gnome/sources/geocode-glib/3.26/geocode-glib-3.26.2.tar.xz
http://ftp.gnome.org/pub/gnome/sources/gjs/1.64/gjs-1.64.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/gnome-autoar/0.2/gnome-autoar-0.2.4.tar.xz
http://ftp.gnome.org/pub/gnome/sources/gnome-desktop/3.36/gnome-desktop-3.36.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/gnome-menus/3.36/gnome-menus-3.36.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/gnome-video-effects/0.5/gnome-video-effects-0.5.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/gnome-online-accounts/3.36/gnome-online-accounts-3.36.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/grilo/0.3/grilo-0.3.12.tar.xz
http://ftp.gnome.org/pub/gnome/sources/libchamplain/0.12/libchamplain-0.12.20.tar.xz
http://ftp.gnome.org/pub/gnome/sources/libgdata/0.17/libgdata-0.17.12.tar.xz
http://ftp.gnome.org/pub/gnome/sources/libgee/0.20/libgee-0.20.3.tar.xz
http://ftp.gnome.org/pub/gnome/sources/libgtop/2.40/libgtop-2.40.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/libgweather/3.36/libgweather-3.36.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/libpeas/1.26/libpeas-1.26.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/libwnck/3.32/libwnck-3.32.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/evolution-data-server/3.36/evolution-data-server-3.36.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/folks/0.14/folks-0.14.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/gfbgraph/0.2/gfbgraph-0.2.3.tar.xz
http://ftp.gnome.org/pub/gnome/sources/tracker/2.3/tracker-2.3.4.tar.xz
http://ftp.gnome.org/pub/gnome/sources/tracker-miners/2.3/tracker-miners-2.3.3.tar.xz
http://ftp.gnome.org/pub/gnome/sources/gsound/1.0/gsound-1.0.2.tar.xz
http://ftp.gnome.org/pub/gnome/sources/dconf/0.36/dconf-0.36.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/dconf-editor/3.36/dconf-editor-3.36.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/gnome-backgrounds/3.36/gnome-backgrounds-3.36.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/gvfs/1.44/gvfs-1.44.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/gexiv2/0.12/gexiv2-0.12.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/nautilus/3.36/nautilus-3.36.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/zenity/3.32/zenity-3.32.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/gnome-bluetooth/3.34/gnome-bluetooth-3.34.1.tar.xz
http://ftp.gnome.org/pub/gnome/sources/gnome-keyring/3.36/gnome-keyring-3.36.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/gnome-settings-daemon/3.36/gnome-settings-daemon-3.36.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/gnome-control-center/3.36/gnome-control-center-3.36.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/mutter/3.36/mutter-3.36.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/gnome-shell/3.36/gnome-shell-3.36.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/gnome-shell-extensions/3.36/gnome-shell-extensions-3.36.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/gnome-session/3.36/gnome-session-3.36.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/gdm/3.34/gdm-3.34.1.tar.xz
http://ftp.gnome.org/pub/gnome/sources/gnome-user-docs/3.36/gnome-user-docs-3.36.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/yelp/3.36/yelp-3.36.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/notification-daemon/3.20/notification-daemon-3.20.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/polkit-gnome/0.105/polkit-gnome-0.105.tar.xz
http://ftp.gnome.org/pub/gnome/sources/baobab/3.34/baobab-3.34.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/brasero/3.12/brasero-3.12.2.tar.xz
http://ftp.gnome.org/pub/gnome/sources/cheese/3.34/cheese-3.34.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/eog/3.36/eog-3.36.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/evince/3.36/evince-3.36.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/evolution/3.36/evolution-3.36.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/file-roller/3.36/file-roller-3.36.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/gnome-calculator/3.36/gnome-calculator-3.36.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/gnome-color-manager/3.35/gnome-color-manager-3.35.90.tar.xz
http://ftp.gnome.org/pub/gnome/sources/gnome-disk-utility/3.36/gnome-disk-utility-3.36.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/gnome-logs/3.34/gnome-logs-3.34.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/gnome-maps/3.36/gnome-maps-3.36.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/gnome-nettool/3.8/gnome-nettool-3.8.1.tar.xz
http://ftp.gnome.org/pub/gnome/sources/gnome-power-manager/3.32/gnome-power-manager-3.32.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/gnome-screenshot/3.36/gnome-screenshot-3.36.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/gnome-system-monitor/3.36/gnome-system-monitor-3.36.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/gnome-terminal/3.36/gnome-terminal-3.36.0.1.tar.xz
http://ftp.gnome.org/pub/gnome/sources/gnome-tweaks/3.34/gnome-tweaks-3.34.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/gnome-weather/3.34/gnome-weather-3.34.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/gucharmap/12.0/gucharmap-12.0.1.tar.xz
http://ftp.gnome.org/pub/gnome/sources/network-manager-applet/1.16/network-manager-applet-1.16.0.tar.xz
http://ftp.gnome.org/pub/gnome/sources/seahorse/3.36/seahorse-3.36.tar.xz
http://ftp.gnome.org/pub/gnome/sources/vinagre/3.22/vinagre-3.22.0.tar.xz"

logfile=$(mktemp)
for url in $(echo $urls); do
	package_name=$(echo $url | cut -d/ -f7)
	if grep $package_name $logfile &> /dev/null; then
		continue
	fi
	pushd $SOURCE_DIR
	wget $url
	tarball=$(echo $url | rev | cut -d/ -f1 | rev)
	directory=$(tar tf $tarball | cut -d/ -f1 | uniq)
	tar xf $tarball
	cd $directory
	if [ -f autogen.sh ]; then
		./autogen.sh --prefix=/usr --sysconfdir=/etc
		make
		make DESTDIR=/var/cache/alps/binaries/gnome install
	elif [ -f configure ]; then
		./configure --prefix=/usr --sysconfdir=/etc
		make
		make DESTDIR=/var/cache/alps/binaries/gnome install
	elif [ -f CMakeLists.txt ]; then
		mkdir -pv build_dir
		cd build_dir
		cmake -DCMAKE_INSTALL_PREFIX=/usr ..
		make
		make DESTDIR=/var/cache/alps/binaries/gnome install
	elif [ -f meson_options.txt ]; then
		mkdir -pv build_dir
		cd build_dir
		meson --prefix=/usr
		ninja
		DESTDIR=/var/cache/alps/binaries/gnome ninja install
	fi
	popd
	echo "$package_name" | tee -a $logfile
done

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

