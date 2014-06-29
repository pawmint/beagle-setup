 
class reverse_proxy ($url, $port) {
	package { ssh :
		ensure => installed,
	}

	file { '/root/.ssh':
		ensure => directory,
		mode => 700,
		owner => root,
		group => root,
	}

	file { '/root/.ssh/amazon.pem':
		require => [Package[ssh], File['/root/.ssh']],
		ensure => present,
		mode => '0600',
		owner => root,
		group => root,
		source => 'puppet:///modules/reverse_proxy/amazon.pem',
		notify => Service['reverseProxySSH.service'],
	}

	concat{ '/root/.ssh/known_hosts':
		require => File['/root/.ssh'],
		mode => '0600',
		owner => root,
		group => root,
		notify => Service['reverseProxySSH.service'],
	}

	concat::fragment{'amazon_id':
		target => '/root/.ssh/known_hosts',
		source => 'puppet:///modules/reverse_proxy/amazon.id',
	}

	file{ '/lib/systemd/system/reverseProxySSH.service':
		ensure => present,
		content => template('reverse_proxy/reverseProxySSH.service.erb'),
		notify => Service['reverseProxySSH.service'],
	}

	service {'reverseProxySSH.service':
		provider => systemd,
		enable => true,
		ensure => running,
		require => File['/lib/systemd/system/reverseProxySSH.service'],
	}



}