#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q brave-origin-bin | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook:fix-namespaces.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/256x256/apps/brave-origin.png
export DESKTOP=/usr/share/applications/brave-origin.desktop
export DEPLOY_OPENGL=1
export DEPLOY_VULKAN=1
export DEPLOY_PIPEWIRE=1
export DEPLOY_QT=1
export DEPLOY_P11KIT=1
export URUNTIME_PRELOAD=1 # really needed here

# Deploy dependencies
quick-sharun \
	./AppDir/bin/* \
	/usr/lib/libgtk-3.so*

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage --no-sandbox
