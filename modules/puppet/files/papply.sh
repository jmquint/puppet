#!/bin/sh
sudo puppet apply --modulepath=/etc/puppet/cookbook/modules /etc/puppet/cookbook/manifests/site.pp
