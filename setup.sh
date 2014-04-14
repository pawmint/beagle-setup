# !bin/bash
##########################################################
#	Script for installation from scratch of Beaglebone Black
#	
#		- Default network configuration
#		- wget
#		- Package update
#		- NTP services
#		- Python 2.7.6 + Patch readline
#       - Python 3.4.0
#	
#	@date		15/04/2014
#	@copyright 	PAWN International
#	@author		Mickael Germain	
#
#	@todo		Add mochad
#	@bug		/etc/resolv.conf is reset at reboot 
#				--> echo 'nameserver 8.8.8.8' >> /etc/resolv.conf
#	
##########################################################

# Function for loafer

function h1(){
   echo ''
   echo '---------------------------------------------------------'
   echo '$1'
   sleep 5
}

function h2(){
   echo ''
   echo '$1'
   sleep 2
}

#---------------------------------------------------------
# Setting up Network :
# Based on http://derekmolloy.ie/beaglebone/getting-started-usb-network-adapter-on-the-beaglebone/ .
# With tips to use the USB adapter under Windows.

# IP adress of the beaglebone black.
BBB_IP='192.168.7.2'
# Netmask.
NETMASK='255.255.255.0'
# IP adress of the gateway.
GATEWAY_IP='192.168.7.1'
# IP adress of the DNS.
DNS_IP='8.8.8.8' # Google DNS.

h1 'Setting up Network'
h2 'Disabling auto-configuration network'
# Disabling connman service (Network-manager).
systemctl disable connman
systemctl stop connman
# Disabling connman-applet.
mv /etc/xdg/autostart/connman-applet.desktop /etc/xdg/autostart/connman-applet.desktop.disable
# Disabling dhcp call when ubs0 is plug.
echo -e 'SUBSYSTEM=="net",ACTION=="add",KERNEL=="usb0",RUN+="/sbin/ifconfig usb0 '"$BBB_IP"' netmask '"$NETMASK"'"\nSUBSYSTEM=="net",ACTION=="remove",KERNEL=="usb0"' > /etc/udev/rules.d/udhcpd.rules
# Disabling dhcp call at bootload and set network informations.
sed -i "s;\(/sbin/ifconfig usb0 \)192.168.7.2\( netmask \)255.255.255.252.*;\1$BBB_IP\2$NETMASK;g" /usr/bin/g-ether-load.sh
sed -i "s;\(/usr/sbin/udhcpd -f -S /etc/udhcpd.conf\).*;# \1\n/sbin/route add default gw $GATEWAY_IP;g" /usr/bin/g-ether-load.sh

h2 'Setting up the default gateway'
/sbin/route add default gw "$GATEWAY_IP"

h2 'Updating the nameserver entry'
echo "nameserver $DNS_IP" >> /etc/resolv.conf

#---------------------------------------------------------
# Wget :
h1 'Updrading wget for https'
opkg install wget

#---------------------------------------------------------
# Updating packages :
h1 'Updating packages'
opkg update

#---------------------------------------------------------
# Setting up time :
# Based on http://derekmolloy.ie/automatically-setting-the-beaglebone-black-time-using-ntp/ .

# Country where BeagleBone is expected to function.
COUNTRY='fr' # fr or sg

h1 'Installing NTP'

opkg install ntp
h2 'Adding time server to ntp.conf'
# Against the malignant guy.
if [ "$COUNTRY" != 'sg' -a  "$COUNTRY" != 'fr' ]; then
	COUNTRY='fr'
fi
# For other time zones search on http://www.pool.ntp.org/ .
if [ $COUNTRY = 'fr' ]; then
	WEB_NTP='server 0.fr.pool.ntp.org\nserver 1.fr.pool.ntp.org\nserver 2.fr.pool.ntp.org\nserver 3.fr.pool.ntp.org'
	LOCALTIME_PATH='/usr/share/zoneinfo/Europe/Paris'
else
	WEB_NTP='server 2.sg.pool.ntp.org\nserver 1.asia.pool.ntp.org\nserver 2.asia.pool.ntp.org'
	LOCALTIME_PATH='/usr/share/zoneinfo/Etc/GMT+8'
fi
# Add NTP server address
sed -i "s;\(server time.server.example.com\).*;# \1\n$WEB_NTP;g" /etc/ntp.conf
# Avoid loopback
sed -i -e "s;\(server 127.127.1.0\).*;# \1;g" -e "s;\(fudge 127.127.1.0 stratum 14\).*;# \1;g" /etc/ntp.conf

h2 'Adding localtime file'
rm /etc/localtime
ln -s $LOCALTIME_PATH /etc/localtime

h2 'Enabling the NTP services'
systemctl enable ntpdate.service
systemctl enable ntpd.service
systemctl start ntpdate.service
systemctl start ntpd.service

h2 'Configuring NTP for BeagleBone Black'
EXEC_NTPD='ExecStart=/usr/bin/ntpd -q -g -x'
EXEC_RTC='ExecStart=/sbin/hwclock --systohc'
sed -i "s;ExecStart=/usr/bin/ntpdate-sync silent.*;$EXEC_NTPD\n$EXEC_RTC;g" /lib/systemd/system/ntpdate.service

#---------------------------------------------------------
# Python 2.7.6 :

# Download link for Python.
WEB_PYTHON2='http://www.python.org/ftp/python/2.7.6/Python-2.7.6.tar.xz'
WEB_PYTHON2_PATCH='http://www.linuxfromscratch.org/patches/blfs/svn/Python-2.7.6-readline_6_3-1.patch'
VER_PYTHON2='Python-2.7.6'

h1 "Installing $VER_PYTHON2"
h2 "Installing $VER_PYTHON2 dependencies"
# echo 'Installing expat (2.1.0)'
# opkg install libexpat1

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

h2 "Downloading $VER_PYTHON2 sources"
wget --no-check-certificate "$WEB_PYTHON2" |  unxz 1> /dev/null
wget "$WEB_PYTHON2_PATCH"
h2 "Building $VER_PYTHON2"
cd "$VER_PYTHON2/"
patch -Np1 -i ../Python-2.7.6-readline_6_3-1.patch &&
./configure --prefix=/usr       \
            --enable-shared     \
            --with-system-expat \
            --with-system-ffi   \
            --enable-unicode=ucs4 &&
make
make install &&
chmod -v 755 /usr/lib/libpython2.7.so.1.0
cd ..
rm -r "$VER_PYTHON2"
rm ./Python-2.7.6-readline_6_3-1.patch
#---------------------------------------------------------
# Python 3.4 :

# Download link for Python.
WEB_PYTHON3='https://www.python.org/ftp/python/3.4.0/Python-3.4.0.tgz'
VER_PYTHON3='Python-3.4.0'

h1 "Installing $VER_PYTHON3"
h2 "Downloading $VER_PYTHON3 sources"
wget --no-check-certificate -O - "$WEB_PYTHON3" |  tar -zxf - 1> /dev/null
h2 "Building $VER_PYTHON3"
cd "$VER_PYTHON3/"
CXX="/usr/bin/g++"              \
./configure --prefix=/usr       \
            --enable-shared     \
            --with-system-expat \
            --with-system-ffi   \
            --without-ensurepip &&
make
make install &&
chmod -v 755 /usr/lib/libpython3.4m.so &&
chmod -v 755 /usr/lib/libpython3.so
cd ..
rm -r "$VER_PYTHON3"
#---------------------------------------------------------
# End of File.
