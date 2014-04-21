#!/bin/bash
##########################################################
#	
#	@date		18/04/2014
#	@copyright 	PAWN International
#	@author		Mickael Germain
#	@todo
#	@bug		Not tested Yet
#	
##########################################################

. beagle-setup/utils.sh

LOG="${0%.*}_`who -m | cut -d ' ' -f 1`_`date +%F-%T`.log"
h2 "Looking for Beaglebone black..."
ping -c 1 192.168.7.2 1>/dev/null 2>> "$LOG" &&
echook 'Beaglebone black board found on the network.' ||
echofail 'Beaglebone black board is unreacheable.'

h2 "Copying data on Beaglebone black"
scp -r beagle-setup root@192.168.7.2:~/ 1>/dev/null 2>> "$LOG" &&
echook 'Data copied successfully.' ||
echofail 'A problem happened during transfer.'

h2 "Setting up Beaglebone black."
ssh root@192.168.7.2 beagle-setup/setupBeagleboneDebian7.sh 2>> "$LOG" &&
echook 'Setting up completed.' ||
echofail 'Setting up aborted before ending.'
echo ''
echo "Error messages have been stored on $LOG file."

#---------------------------------------------------------
# End of File.

