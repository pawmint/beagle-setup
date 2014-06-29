 
class reverse_proxy ($url, $port) {
	package { ssh :
		ensure => installed,
	}

	file { '/root/.ssh/amazon.pem':
		require => Package[ssh],
		ensure => present,
		mode => '0600',
		owner => root,
		group => root,
		source => 'puppet:///modules/reverse_proxy/amazon.pem',
	}

	concat{ '/root/.ssh/known_hosts':
		mode => '0600',
		owner => root,
		group => owner,
	}

	concat::fragment{'amazon_id':
		target => '/root/.ssh/known_hosts',
		source => 'puppet:///modules/reverse_proxy/amazon.id',
	}

	file{ '/lib/systemd/system/reverseProxySSH.service':
		ensure => present,
		content => template('reverse_proxy/reverseProxySSH.service.erb'),
		notify => Service['reverseProxySSH'],
	}

	service {'reverseProxySSH.service':
		provider => systemd,
		enable => true,
		ensure => running,
		require => File['/lib/systemd/system/reverseProxySSH.service'],
	}



}