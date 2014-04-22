#!/bin/bash
##########################################################
#   Script for installation from scratch of UbiGATE 
#   on Beaglebone Debian 7
#   
#   Performing :
#       - Default network configuration
#       - Package update
#       - NTP services
#       - Python 2.7.6 + Patch readline
#       - Python 3.4.0
#       - Mochad
#       - OpenZWave
#       - UbiGATE
#   
#   @date       18/04/2014
#   @copyright  PAWN International
#   @author     Mickael Germain
#
#   @todo       Add options, transfer place request, switch to Angstrom install ?
#   @bug        
#   
##########################################################

. utils.sh

#---------------------------------------------------------
# Setting up Network :
./Install_Network.sh || exit
#---------------------------------------------------------
# Updating packages :
h1 'Updating packages'
apt-get update -y -q || exit
#---------------------------------------------------------
# Setting up time :
./Install_NTP.sh 'fr' || exit
#---------------------------------------------------------
# Python 2 :
./Install_Python2.sh || exit
#---------------------------------------------------------
# Python 3 :
#./Install_Python3.sh
#---------------------------------------------------------
# Mochad :
./Install_Mochad.sh || exit
#---------------------------------------------------------
# OpenZWave :
./Install_OpenZWave.sh || exit
#---------------------------------------------------------
# UbiGATE :
./Install_UbiGATE.sh || exit
#---------------------------------------------------------
reboot
#---------------------------------------------------------
# End of File.
