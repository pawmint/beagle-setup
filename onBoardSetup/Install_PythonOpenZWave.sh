#!/bin/bash
##########################################################
#   Install python-openzwave on Beaglebone Debian 7
#   
#   @date       29/04/2014
#   @copyright  PAWN International
#   @author     Mickael Germain 
#
#   @todo       
#   @bug        Not tested yet.
#   
##########################################################

. utils.sh

#---------------------------------------------------------
# OpenZWave :

WEB_PY_ZWAVE='https://code.google.com/p/python-openzwave/'

h1 'Installing python-openzwave'

h2 'Installing python-openzwave dependencies'
apt-get install mercurial subversion python-pip python-dev -y -q &&
pip install cython==0.14 &&
apt-get install python-dev python-setuptools python-louie -y -q &&
apt-get install python-sphinx make -y -q && # Documentation
pip install sphinxcontrib-blockdiag sphinxcontrib-actdiag && # Documentation
pip install sphinxcontrib-nwdiag sphinxcontrib-seqdiag && # Documentation
apt-get install build-essential libudev-dev g++ -y -q
if [ $? = 0 ]; then
    echook 'Installation of dependencies completed.'
else
    echofail 'Installation of dependencies has failed.'
    echofail 'Installation of python-openzwave has failed.'
    echo "Leaving script $0 ..."
    exit 1
fi

h2 'Downloading python-openzwave sources'
hg clone "$WEB_PY_ZWAVE"
if [ $? = 0 ]; then
    echook 'Download completed.'
else
	echofail 'Download has failed.'
    echofail 'Installation of python-openzwave has failed.'
    echo "Leaving script $0 ..."
    exit 1
fi

h2 'Building python-openzwave'
cd python-openzwave &&
./update.sh &&
./compile.sh &&
cd ..
if [ $? = 0 ]; then
    echook 'Installation of python-openzwave completed.'
else
    echofail 'Installation of python-openzwave has failed.'
    echo "Leaving script $0 ..."
    exit 1
fi

#h2 'Cleaning up...''

#---------------------------------------------------------
# End of File.