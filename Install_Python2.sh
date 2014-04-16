#!/bin/bash
##########################################################
#   Install Python 2.7.6 on Beaglebone Debian 7
#
#   @date       17/04/2014
#   @copyright  PAWN International
#   @author     Mickael Germain 
#
#	@todo       
#	@bug        
#	
##########################################################

. utils.sh

#---------------------------------------------------------
# Python 2.7.6 :

# Download link for Python.
WEB_PYTHON2='http://www.python.org/ftp/python/2.7.6/Python-2.7.6.tar.xz'
WEB_PYTHON2_PATCH='http://www.linuxfromscratch.org/patches/blfs/svn/Python-2.7.6-readline_6_3-1.patch'
VER_PYTHON2='Python-2.7.6'

h1 "Installing $VER_PYTHON2"
h2 "Installing $VER_PYTHON2 dependencies"

echo 'Installing expat'
apt-get install install expat

echo 'Installing libffi'
./Install_libffi.sh

h2 "Downloading $VER_PYTHON2 sources"
wget --no-check-certificate "$WEB_PYTHON2" |  unxz 1> /dev/null
wget "$WEB_PYTHON2_PATCH"
h2 "Building $VER_PYTHON2"
cd "$VER_PYTHON2/"
patch -Np1 -i ../Python-2.7.6-readline_6_3-1.patch &&
./configure --prefix=/usr       \
            --enable-shared     \
            --with-system-expat \
            --with-system-ffi   \
            --enable-unicode=ucs4 &&
make
make install &&
chmod -v 755 /usr/lib/libpython2.7.so.1.0
cd ..
rm -r "$VER_PYTHON2"
rm Python-2.7.6-readline_6_3-1.patch

#---------------------------------------------------------
# End of File.