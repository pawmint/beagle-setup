#!/bin/bash
##########################################################
#   Install libffi 3.0.13 on Beaglebone Debian 7
#
#   @date       17/04/2014
#   @copyright  PAWN International
#   @author     Mickael Germain 
#
#   @todo       
#   @bug        
#   
##########################################################

source utils.sh

#---------------------------------------------------------
# libffi-3.0.13 :

WEB_LIBFFI='ftp://sourceware.org/pub/libffi/libffi-3.0.13.tar.gz'
WEB_LIBFFI_PATCH='http://www.linuxfromscratch.org/patches/blfs/svn/libffi-3.0.13-includedir-1.patch'
VER_LIBFFI='libffi-3.0.13'

# I choosed to keep old version because of the numbers of dependent packages.
wget -O - "$WEB_LIBFFI" | tar -zxf - 1> /dev/null
wget "$WEB_LIBFFI_PATCH"
cd "$VER_LIBFFI"
# Patch for this specific version
patch -Np1 -i ../libffi-3.0.13-includedir-1.patch &&
./configure --prefix=/usr --disable-static &&
make
make install
cd ..
rm -r "$VER_LIBFFI"
rm ./libffi-3.0.13-includedir-1.patch

#---------------------------------------------------------
# End of File.