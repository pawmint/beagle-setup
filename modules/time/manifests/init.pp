 
class time {
	package { 'tzdata' :
		require => Class['::ntp'],
		ensure => installed,
	}

	class { '::ntp':
		servers => [ '0.pool.ntp.org', '1.pool.ntp.org', '2.pool.ntp.org', '3.pool.ntp.org' ],
	}

	
}