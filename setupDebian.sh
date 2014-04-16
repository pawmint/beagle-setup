#!/bin/bash
##########################################################
#   Script for installation from scratch of UbiGATE 
#	on Beaglebone Debian 7
#   
#       - Default network configuration
#       - Package update
#       - NTP services
#       - Python 2.7.6 + Patch readline
#       - Python 3.4.0
#       - Mochad
#       - OpenXWave
#   
#   @date       17/04/2014
#   @copyright  PAWN International
#   @author     Mickael Germain 
#
#   @todo       Add options, transfer place request, switch to Angstrom install ?
#   @bug        
#   
##########################################################

. utils

#---------------------------------------------------------
# Setting up Network :
./Install_Network.sh
#---------------------------------------------------------
# Updating packages :
h1 'Updating packages'
apt-get update
#---------------------------------------------------------
# Setting up time :
./Install_NTP.sh
#---------------------------------------------------------
# Python 2 :
./Install_Python2.sh
#---------------------------------------------------------
# Python 3 :
./Install_Python3.sh
#---------------------------------------------------------
# Mochad :
./Install_Mochad.sh
#---------------------------------------------------------
# OpenXWave :
./Install_OpenXWave.sh
#---------------------------------------------------------
# End of File.