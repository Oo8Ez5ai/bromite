#!/bin/sh
set -ex

topdir="$(pwd)"
chr=$HOME/chromium

git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git $chr/depot_tools --depth 1
export PATH="$PATH:$chr/depot_tools"
mkdir $chr && cd $chr

fetch --no-history --nohooks android
cd src
ver="$(cat $topdir/build/RELEASE)"
git fetch https://chromium.googlesource.com/chromium/src.git +refs/tags/"$ver":chromium_"$ver"
git checkout chromium_"$ver"
gclient sync

while read file; do
    patch -p 1 -i "$topdir"/build/patches/"$file"
done < "$topdir"/build/bromite_patches_list.txt

