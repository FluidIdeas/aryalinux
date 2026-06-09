# Run a command as the build user. Prefer sudo/runuser over su after PAM shadow.
as_user() {
	local user="$1"
	shift
	local cmd="$*"

	if [ -x /usr/bin/sudo ]; then
		sudo -Hiu "$user" -- bash -lc "$cmd"
	elif [ -x /usr/bin/runuser ]; then
		runuser -u "$user" -- bash -lc "$cmd"
	else
		su - "$user" -c "$cmd"
	fi
}
