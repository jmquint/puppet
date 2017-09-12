#!/bin/sh
sudo puppet apply /home/vagrant/puppet/cookbook/manifests/site.pp \--modulepath=/home/vagrant/puppet/cookbook/modules $* 
