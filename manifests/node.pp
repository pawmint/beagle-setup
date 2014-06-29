 
node default {
	
	include time
	
	class { 'gsm_network':
		provider => 'free',
	}

	include mochad

	class {'reverse_proxy':
		url => 'ubuntu@ec2-54-186-251-30.us-west-2.compute.amazonaws.com',
        port => 5900,
    }

	class { 'python' :
		version => '3',
		pip => true,
		dev => true,
		virtualenv => true,
		gunicorn => false,
	}
}