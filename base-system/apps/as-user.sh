# Run a command as the build user. After essentials installs sudo, prefer it over
# su — PAM-enabled su may print "Authentication service cannot retrieve
# authentication info (Ignored)" when invoked by root after shadow is upgraded.
as_user() {
	local user="$1"
	shift
	local cmd="$*"

	if [ -x /usr/bin/sudo ]; then
		sudo -Hiu "$user" -- bash -lc "$cmd"
	else
		su - "$user" -c "$cmd"
	fi
}
