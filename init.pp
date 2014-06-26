
vcsrepo{"/usr/local/etc/puppet":
	ensure => present,
	provider => git,
	source => 'git://github.com/pawmint/beagle-setup.git',
	revision => 'puppet',
}

cron{"puppet":
	require => Vcsrepo["/usr/local/etc/puppet"],
	ensure => present,
	command => '/usr/bin/puppet apply --modulepath /usr/local/etc/puppet/modules /usr/local/etc/puppet/manifests/node.pp',
	user => root,
	minute => '*/10',
}
