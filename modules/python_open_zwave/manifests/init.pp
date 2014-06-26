 
class python_open_zwave {
	package { ['mercurial', 'subversion', 'python-pip', 'python-dev', 'python-setuptools', 'python-louie', 'build-essential', 'libudev-dev', 'g++'] :
		ensure => installed,
		alias => pyOpZWPack,
	}

	package{['sphinxcontrib-blockdiag', 'sphinxcontrib-actdiag', 'sphinxcontrib-nwdiag', 'sphinxcontrib-seqdiag'] :
		provider => pip,
		ensure => installed,
		alias => pyOpZWPackPip
	}
	
	puppi::netinstall { 'python_open_zwave' :
		require => [pyOpZWPack, pyOpZWPackPip]
		url => 'https://code.google.com/p/python-openzwave/',
		extracted_dir => 'python-openzwave',
		destination_dir => '/tmp',
		postextract_command => '/tmp/python-openzwave/update.sh && compile.sh',
	}
}