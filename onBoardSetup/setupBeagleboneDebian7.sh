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
./Install_Network.sh
#---------------------------------------------------------
# Updating packages :
h1 'Updating packages'
apt-get update -y -q
#---------------------------------------------------------
# Setting up time :
./Install_NTP.sh 'fr'
#---------------------------------------------------------
# Reverse Proxy :
./Install_SSH.sh
#---------------------------------------------------------
h2 'Please enter the id number of the house to deploy: '
read -p "Enter your house code: House" house

# Reverse Proxy :
./Install_ReverseProxy.sh $house
#---------------------------------------------------------
# Python 2 :
#./Install_Python2.sh
#---------------------------------------------------------
# Python 3 :
#./Install_Python3.sh
#---------------------------------------------------------
# Mochad :
./Install_Mochad.sh ||
exit
#---------------------------------------------------------
# OpenZWave :
#./Install_OpenZWave.sh
#---------------------------------------------------------
# python-openzwave :
# ./Install_PythonOpenZWave.sh
#---------------------------------------------------------
# UbiGATE :
./Install_marmitek.sh $house ||
exit
# Zigbee-gw :
./Install_zigbee.sh $house ||
exit
#---------------------------------------------------------
# 3G dongle :
./Install_3G.sh
#---------------------------------------------------------
# Wifi :
./Install_wifi.sh
#---------------------------------------------------------
reboot
#---------------------------------------------------------
# End of File.
