##########################################################
#   Functions to cozy install the ubiGATE platform.
#
#   @date       17/04/2014
#   @copyright  PAWN International
#   @author     Mickael Germain 
#
#	@todo       log function
#	@bug        
#	
##########################################################

function h1 ( )
{
	echo -e '\033[33m'
	echo -e '----------------------------------------------------------'
	echo -e "$1"
	echo -e -n '\033[0m'
	sleep 3
}

function h2 ( )
{
	echo -e '\033[36m'
	echo -e "$1"
	echo -e -n '\033[0m'
	sleep 1
}
