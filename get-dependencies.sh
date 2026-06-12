#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm cups libgnome-keyring libnotify

if [ "$ARCH" = 'x86_64' ]; then
	pacman -Syu --noconfirm libva-intel-driver
fi

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano intel-media-driver-mini ffmpeg-mini

# Comment this out if you need an AUR package
make-aur-package brave-origin-bin

# If the application needs to be manually built that has to be done down here

mkdir -p ./AppDir/bin
cp -rv /opt/brave-origin-bin/* ./AppDir/bin

# remove libqt5_shim.so since we can only deploy qt6 or qt5
rm -f ./AppDir/bin/libqt5_shim.so
