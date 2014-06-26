#!/bin/bash

#apt-get update
apt-get install puppet git -y

hostname pokemon
echo "pokemon" > /etc/hostname

puppet module install stankevich-python
puppet module install example42-puppi
puppet module install puppetlabs-vcsrepo

puppet apply init.pp
