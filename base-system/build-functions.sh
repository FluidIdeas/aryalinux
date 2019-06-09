function cleanup() {
	cd $SOURCE_DIR
	rm -rf $1
	rm -rf gcc-build
	rm -rf glibc-build
	rm -rf binutils-build
}

function log() {
	echo "$1" >> /sources/build-log
}
