##########################################################
#   Functions to cozy install the ubiGATE platform.
#
#   @date       17/04/2014
#   @copyright  PAWN International
#   @author     Mickael Germain 
#
#   @todo       log function
#   @bug        
#   
##########################################################

function h1 ()
{
    echo -e '\033[36m\033[1m'
    echo -e '----------------------------------------------------------'
    echo -e "$1"
    echo -e -n '\033[0m'
    sleep 5
}

function h2 ()
{
    echo -e '\033[34m'
    echo -e "$1"
    echo -e -n '\033[0m'
    sleep 2
}

function echook ()
{
    echo -e -n '[ \033[32mOK\033[0m ] '
    echo -e "$*"
}

function echofail ()
{
    echo -e -n '[\033[31m\033[1mFAIL\033[0m] '
    echo -e "$*"
}