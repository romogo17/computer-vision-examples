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
    echo "usage: opencv_install_macos.sh [install prefix]"
    echo ""
    echo "This script is intended to install OpenCV from source on Macos"
    echo "including support for Qt5 and the Python 3 library on a"
    echo "virtual environment"
    echo ""
    echo "✔ - Locate your installation directory"
    echo "✔ - Install Qt5 using homebrew (brew install qt5)"
    echo "✔ - Create a Python 3 environment with numpy"
    echo "✔ - Activate said environment before calling this script"
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

title "\nOpenCV (latest) installation script for MacOS (requires homebrew)"

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
rm -rf opencv-sources
mkdir opencv-sources
cd opencv-sources

# Clean build directories
rm -rf opencv/build
rm -rf opencv_contrib/build

step '\n✔ - Cloning the OpenCV and OpenCV Contrib repositories'
echo "Sources will be saved in $PREFIX/opencv-sources"
echo ""

git clone https://github.com/opencv/opencv.git
cd opencv
git checkout master
cd ..

git clone https://github.com/opencv/opencv_contrib.git
cd opencv_contrib
git checkout master
cd ..

cd opencv
mkdir build
cd build

step '\n✔ - Setting up the build variables'

# - QT Path
QT5=$(brew --cellar qt5)/$(brew list --versions qt5 | tr ' ' '\n' | tail -1)
if [ $QT5 == "/" ]; then
    err 'Could not find the QT5 installation directory'
    exit 1
fi
echo -n "Qt5 installation directory: "
info $QT5

PY3_DEFAULT=$(which python3)
PY3_EXECUTABLE=$(python3 -c "import sys; print(sys.executable)")
PY3_INCLUDEDIR=$(python3 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())")
PY3_LIBRARY=$(python3 -c "import distutils.sysconfig as sysconfig; import os; print(os.path.join(sysconfig.get_config_var('LIBDIR'), sysconfig.get_config_var('LDLIBRARY')))")
PY3_PACKAGES=$(python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())")
PY3_NUMPYINCLUDEDIR=$(python3 -c "import numpy as np; print(np.get_include())")

echo -n "Python3 default executable: "
info $PY3_DEFAULT
echo -n "Python3 executable: "
info $PY3_EXECUTABLE
echo -n "Python3 include directory: "
info $PY3_INCLUDEDIR
echo -n "Python3 library: "
info $PY3_LIBRARY
echo -n "Python3 packages path: "
info $PY3_PACKAGES
echo -n "Numpy include directory: "
info $PY3_NUMPYINCLUDEDIR

step '\n✔ - Configuring the build with cmake'
echo "Make sure both Python Executable and Python Library are defined correctly in the previous step"
echo ""
pause "Press [Enter] to continue..."

cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=$PREFIX \
    -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
    -D CMAKE_PREFIX_PATH=$QT5 \
    -D CMAKE_MODULE_PATH=$QT5/lib/cmake \
    -D WITH_QT=ON \
    -D WITH_CUDA=OFF \
    -D BUILD_opencv_java=OFF \
    -D WITH_OPENGL=ON \
    -D BUILD_PYTHON_SUPPORT=ON \
    -D BUILD_NEW_PYTHON_SUPPORT=ON \
    -D BUILD_opencv_python2=OFF \
    -D BUILD_opencv_python3=ON \
    -D PYTHON_DEFAULT_EXECUTABLE=$PY3_DEFAULT\
    -D PYTHON3_EXECUTABLE=$PY3_EXECUTABLE \
    -D PYTHON3_INCLUDE_DIR=$PY3_INCLUDEDIR \
    -D PYTHON3_LIBRARY=$PY3_LIBRARY \
    -D PYTHON3_NUMPY_INCLUDE_DIRS=$PY3_NUMPYINCLUDEDIR \
    -D PYTHON3_PACKAGES_PATH=$PY3_PACKAGES \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D INSTALL_C_EXAMPLES=ON \
    -D OPENCV_ENABLE_NONFREE=ON \
    -D BUILD_EXAMPLES=ON ..


step '\n✔ - Building OpenCV'
echo "This step may take some time"
echo ""
pause "Press [Enter] to continue..."
cmake --build . -- -j 4


step '\n✔ - Installing OpenCV'
echo ""
pause "Press [Enter] to continue..."
cmake --build . --target install

echo ""
echo "If you want to uninstall OpenCV run the following command from $(pwd):"
echo ""
echo "cmake --build . --target uninstall"
echo ""

cd $CWD
exit 0