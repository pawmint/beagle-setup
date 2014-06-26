 
class 3G ($provider='UNSET', $pin='1234') {
	package { 'wvdial' :
		ensure => installed,
	}

	File {
		require => Package['wvdial'],
		notify => Service['3GPin.service'],
		notify => Service['3GConnection.service'],
	}

	file { '/etc/ppp/peers/wvdial' :
		source => '3G/wvdial',
	}

	file { '/etc/wvdial.conf' :
		content => template('3G/wvdial.conf.erb'),
	}

	file { '/etc/ppp/ip-up.local' :
		source => '3G/ip-up.local',
	}

	file { '/etc/ppp/ip-down.local' :
		source => '3G/ip-down.local',
	}

	file { '/lib/systemd/system/3GDongle.service' :
		content => template('3G/3GDongle.service.erb'),
	}

	service { ['3GPin.service', 3GConnection.service'] :
		enable => true,
		require => Package['wvdial'],
	}
}