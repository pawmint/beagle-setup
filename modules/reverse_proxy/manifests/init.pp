 
class reverse_proxy ($url) {
	package { ssh :
		ensure => installed,
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