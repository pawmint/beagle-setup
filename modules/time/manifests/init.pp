 
class time {
	package { 'tzdata' :
		require Class['::ntp'],
		ensure => installed,
	}

	class { '::ntp':
		servers => [ '0.pool.ntp.org', '1.pool.ntp.org', '2.pool.ntp.org', '3.pool.ntp.org' ],
	}

	puppi::netinstall { 'mochad' :
		require => Package['libusb-1.0-0-dev'],
		url => 'http://sourceforge.net/projects/mochad/files/mochad-0.1.16/download',
		extracted_dir => 'mochad-0.1.16',
		destination_dir => '/tmp',
		postextract_command => '/tmp/mochad-0.1.16/configure && make && make install',
	}
}