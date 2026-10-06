#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
	base-devel  \
	git         \
	go          \
	gtk3        \
	libxcursor  \
	libxi       \
	libxinerama \
	libxrandr   \
	libxxf86vm  \
	mesa        \
	pkgconf

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common

echo "Building erings..."
echo "---------------------------------------------------------------"
git clone https://github.com/user-none/erings.git ./erings
cd ./erings

# Build the latest stable tag, nightly builds are not used
if [ "${DEVEL_RELEASE-}" = 1 ]; then
	TAG=$(git rev-parse --short HEAD)
else
	git fetch --tags origin
	TAG=$(git tag --sort=-v:refname | grep -vi 'rc\|alpha\|beta' | head -1)
	git checkout "$TAG"
fi
echo "$TAG" > ~/version

make VERSION="$TAG"

install -Dm755 ./build/erings                              /usr/bin/erings
install -Dm644 ./packaging/erings.desktop                  /usr/share/applications/erings.desktop
install -Dm644 ./packaging/icon-512.png                    /usr/share/icons/hicolor/512x512/apps/erings.png
