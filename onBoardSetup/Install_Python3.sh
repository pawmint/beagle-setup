#!/bin/bash
##########################################################
#   Install Python 3.4 on Beaglebone Debian 7
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
# Python 3.4 :

# Download link for Python.
WEB_PYTHON3='https://www.python.org/ftp/python/3.4.0/Python-3.4.0.tgz'
VER_PYTHON3='Python-3.4.0'

h1 "Installing $VER_PYTHON3"

h2 "Installing $VER_PYTHON3 dependencies"
echo 'Installing expat'
apt-get install expat -y -q
if [ $? = 0 ]; then
    echook 'Installation of expat completed.'
else
	echofail 'Installation of expat has failed.'
	echofail "Installation of $VER_PYTHON3 has failed."
    echo "Leaving script $0 ..."
    exit 1
fi
h2 "Downloading $VER_PYTHON3 sources"
wget --no-check-certificate -O - "$WEB_PYTHON3" |  tar -zxf - 1> /dev/null
if [ $? = 0 ]; then
    echook 'Download completed.'
else
	echofail 'Download has failed.'
	echofail "Installation of $VER_PYTHON3 has failed."
    echo "Leaving script $0 ..."
    exit 1
fi

h2 "Building $VER_PYTHON3"
cd "$VER_PYTHON3/" &&
CXX="/usr/bin/g++"              \
./configure --prefix=/usr       \
            --enable-shared     \
            --with-system-expat \
            --with-system-ffi   \
            --without-ensurepip &&
make &&
make install &&
chmod -v 755 /usr/lib/libpython3.4m.so &&
chmod -v 755 /usr/lib/libpython3.so &&
cd ..
if [ $? = 0 ]; then
    echook "Installation of $VER_PYTHON3 completed."
else
    echofail "Installation of $VER_PYTHON3 has failed."
    echo "Leaving script $0 ..."
    exit 1
fi

h2 "Cleaning up..."
rm -r "$VER_PYTHON3" 

#---------------------------------------------------------
# End of File.