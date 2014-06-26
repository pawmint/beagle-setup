 
class gsmNetwork ($provider = 'UNSET', $pin = '1234') {
	package { 'wvdial' :
		ensure => installed,
	}

	File {
		require => Package['wvdial'],
		notify => Service['gsmNetwork.service'],
	}

	file { '/etc/ppp/peers/wvdial' :
		source => 'puppet:///modules/gsmNetwork/wvdial',
	}

	file { '/etc/wvdial.conf' :
		content => template('gsmNetwork/wvdial.conf.erb'),
	}

	file { '/etc/ppp/ip-up.local' :
		source => 'puppet:///modules/gsmNetwork/ip-up.local',
	}

	file { '/etc/ppp/ip-down.local' :
		source => 'puppet:///modules/gsmNetwork/ip-down.local',
	}

	file { '/lib/systemd/system/gsmNetwork.service' :
		content => template('gsmNetwork/gsmNetwork.service.erb'),
	}

	file { '/etc/udev/rules.d/91-usb-gsmmodem.rules' :
		source => 'puppet:///modules/91-usb-gsmmodem.rules',
	}
	
	service { 'gsmNetwork.service' :
		provider => systemd,
		enable => true,
		require => Package['wvdial'],
	}
}