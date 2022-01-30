#!/bin/sh
set -ex

topdir="$(pwd)"
chr=$HOME/chromium

if [ ! -d "$chr/depot_tools" ]; then
	echo FATAL: No depot_tools/ on $chr. Create cache before run.
	exit 1
fi
export PATH="$PATH:$chr/depot_tools"
cd $chr/src

./build/install-build-deps.sh
gclient runhooks

mkdir -p out/release
cp "$topdir"/build/GN_ARGS out/release/args.gn
gn gen out/release

autoninja -C out/release chrome_public_apk

