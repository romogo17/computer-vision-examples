#!/usr/bin/env bash

# Script created by @romogo17

cecho () {
  local _color=$1; shift
  echo -e "$(tput bold)$(tput setaf $_color)$@$(tput sgr0)"
}

title() {
    cecho 6 "$@" >&2;
}

step() {
    cecho 5 "$@" >&2;
}

info() {
    cecho 2 "$@" >&2;
}

err () {
  cecho 1 "Error: $@" >&2;
}

pause (){
   read -p "$*"
}

help () {
    echo ""
    echo "usage: dlib_install_macos.sh [install prefix]"
    echo ""
    echo "This script is intended to install Dlib from source on Macos"
    echo ""
    echo "✔ - Locate your installation directory"
    echo ""
}

case $1 in
    -h|--help)
        help
        exit 0
        ;;
esac

# ======================================================================
#                           Script begining
# ======================================================================

title "\Dlib (latest) installation script for MacOS"

step "\n✔ - Setting up initial working directories"

# Needed variables
# - Current working directory
CWD=$(pwd)
# - Prefix installation directory
[ ! -z "$1" ] && PREFIX="$1" || PREFIX="$CWD"

echo "Current working directory: $CWD"

echo -n "Target installation directory: "
info $PREFIX

if [ ! -d "$PREFIX" ]; then
    err "Target directory does not exist or is a file"
    exit 1
fi

if [ ! -w "$PREFIX" ]; then
    err "Test for write access to directory failed"
    exit 1
fi

cd $PREFIX
rm -rf dlib-sources
mkdir dlib-sources
cd dlib-sources

# Clean build directories
rm -rf dlib/build

step '\n✔ - Cloning the Dlib repository'
echo "Sources will be saved in $PREFIX/dlib-sources"
echo ""

git clone https://github.com/davisking/dlib
cd dlib
git checkout master

mkdir build
cd build

step '\n✔ - Configuring the build with cmake'
echo ""
pause "Press [Enter] to continue..."

cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=$PREFIX \
    -D DLIB_NO_GUI_SUPPORT=ON \
    -D USE_SSE2_INSTRUCTIONS=ON \
    -D USE_SSE4_INSTRUCTIONS=ON \
    -D BUILD_SHARED_LIBS=1 ..


step '\n✔ - Building Dlib'
echo "This step may take some time"
echo ""
pause "Press [Enter] to continue..."
cmake --build . -- -j 4


step '\n✔ - Installing Dlib'
echo ""
pause "Press [Enter] to continue..."
cmake --build . --target install

echo ""
echo "If you want to uninstall Dlib run the following command from $(pwd):"
echo ""
echo "cat install_manifest.txt | xargs echo rm | sh"
echo ""

cd $CWD
exit 0