
vcsrepo{"/usr/local/etc/puppet":
	ensure => present,
	provider => git,
	source => 'git://github.com/pawmint/beagle-setup.git',
	revision => 'puppetDir',
}

cron{"puppet":
	require => Vcsrepo["/usr/local/etc/puppet"],
	ensure => present,
	command => '(cd /usr/local/etc/puppet && git pull && /usr/bin/puppet apply --modulepath /usr/local/etc/puppet/modules /usr/local/etc/puppet/manifests/node.pp)',
	user => root,
	minute => '*/10',
}
