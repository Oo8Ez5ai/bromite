#!/bin/sh
set -e

topdir="$(pwd)"

git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git $HOME/depot_tools
export PATH="$PATH:$HOME/depot_tools"
mkdir chromium && cd chromium

fetch --nohooks android --no-history
cd src
ver="$(cat build/RELEASE)"
git fetch https://chromium.googlesource.com/chromium/src.git +refs/tags/"$ver":chromium_"$ver"
git checkout chromium_"$ver"
gclient sync

while read file; do
    patch -p 1 -i "$topdir"/build/patches/"$file"
done < "$topdir"/build/bromite_patches_list.txt

./build/install-build-deps.sh
gclient runhooks

mkdir -p out/release
cp "$topdir"/build/GN_ARGS out/release/args.gn
gn gen out/release

autoninja -C out/release chrome_public_apk

