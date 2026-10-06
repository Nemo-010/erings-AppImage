#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm go

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME

# If the application needs to be manually built that has to be done down here
echo "Building erings..."
echo "---------------------------------------------------------------"
git clone https://github.com/user-none/erings.git ./erings && (
	cd ./erings

	git fetch --tags origin
	TAG=$(git tag --sort=-v:refname | grep -vi 'rc\|alpha\|beta' | head -1)
	git checkout "$TAG"
	make VERSION="$TAG"

	echo "$TAG" > ~/version
)

mkdir -p ./AppDir/bin
cp -v ./erings/build/erings             ./AppDir/bin
cp -v ./erings/packaging/erings.desktop ./AppDir
cp -v ./erings/packaging/icon-512.png   ./AppDir/erings.png
