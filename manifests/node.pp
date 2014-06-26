 
node default {
	class { 'gsm_network':
		provider => 'free',
	}

	include mochad

	class { 'python' :
		version => '3'
		pip => true,
		dev => true,
		virualenv => true,
		gunicorn => false,
	}
}