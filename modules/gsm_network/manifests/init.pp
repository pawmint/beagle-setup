 
class gsm_network ($provider = 'UNSET', $pin = '1234') {
	package { 'wvdial' :
		ensure => installed,
	}

	File {
		require => Package['wvdial'],
		notify => Service['gsm_network.service'],
	}

	file { '/etc/ppp/peers/wvdial' :
		source => 'puppet:///modules/gsm_network/wvdial',
	}

	file { '/etc/wvdial.conf' :
		content => template('gsm_network/wvdial.conf.erb'),
	}

	file { '/etc/ppp/ip-up.local' :
		source => 'puppet:///modules/gsm_network/ip-up.local',
	}

	file { '/etc/ppp/ip-down.local' :
		source => 'puppet:///modules/gsm_network/ip-down.local',
	}

	file { '/lib/systemd/system/gsm_network.service' :
		content => template('gsm_network/gsm_network.service.erb'),
	}

	file { '/etc/udev/rules.d/91-usb-gsmmodem.rules' :
		source => 'puppet:///modules/gsm_network/91-usb-gsmmodem.rules',
	}
	
	service { 'gsm_network.service' :
		provider => systemd,
		enable => true,
		require => Package['wvdial'],
	}
}