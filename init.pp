
vcsrepo{"/usr/local/etc/beagle-setup":
	ensure => present,
	provider => git,
	source => 'git://github.com/pawmint/beagle-setup.git',
	revision => 'puppet',
}

cron{"puppet":
	require => Vcsrepo["/usr/local/etc/beagle-setup"],
	ensure => present,
	command => '/usr/bin/puppet apply --modulepath /usr/local/etc/beagle-setup/puppet/modules /usr/local/etc/beagle-setup/puppet/manifests/node.pp',
	user => root,
	minute => 10,
}
