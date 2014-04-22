#!/bin/bash
##########################################################
#	
#	@date		18/04/2014
#	@copyright 	PAWN International
#	@author		Mickael Germain
#	@todo
#	@bug		
#	
##########################################################

. onBoardSetup/utils.sh

LOG="${0%.*}_`who -m | cut -d ' ' -f 1`_`date +%F-%T`.log"
touch "$LOG"
xterm -T 'Log file' -e tail -f -s 1 "$LOG" &
h1 "Setting up Beaglebone Black remotely"

h2 "Configure IP forwarding on HOST"
iptables -A POSTROUTING -t nat -j MASQUERADE  2>>"$LOG" &&
echo '1' > /proc/sys/net/ipv4/ip_forward  2>>"$LOG"
if [ $? = 0 ]; then
	echook 'IP forwarding enabled.'
else
	echofail 'Beaglebone black board is unreacheable.'
	echo "Error messages have been stored on $LOG file."
	echo "Leaving script $0 ..."
	exit 1
fi

h2 "Looking for Beaglebone black..."
ping -c 1 192.168.7.2 1>/dev/null 2>>"$LOG"
if [ $? = 0 ]; then
	echook 'Beaglebone black board found on the network.'
else
	echofail 'Beaglebone black board is unreacheable.'
	echo "Error messages have been stored on $LOG file."
	echo "Leaving script $0 ..."
	exit 1
fi

h2 "Copying data on Beaglebone black"
scp -r onBoardSetup root@192.168.7.2:~/ 1>/dev/null 2>>"$LOG"
if [ $? = 0 ]; then
	echook 'Data copied successfully.'
else
	echofail 'A problem happened during transfer.'
	echo "Error messages have been stored on $LOG file."
	echo "Leaving script $0 ..."
	exit 1
fi

h2 "Setting up Beaglebone black."
ssh root@192.168.7.2 "cd onBoardSetup; ./setupBeagleboneDebian7.sh" 2>>"$LOG"
if [ $? = 0 ]; then
	echook 'Setting up completed.'
else
	echofail 'Setting up aborted before ending.'
	echo "Error messages have been stored on $LOG file."
	echo "Leaving script $0 ..."
	exit 1
fi

echo ''
echo "Error messages have been stored on $LOG file."

#---------------------------------------------------------
# End of File.

