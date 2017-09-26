node 'puppet' {
  # Configure puppetdb and its underlying database
  class { 'puppetdb': }
  # Configure the Puppet master to use puppetdb
  class { 'puppetdb::master::config': }
}

node 'git' {

  file {'/tmp/it_works.txt':
    ensure  => present,
    mode    => '0644',
    content => "It works !\n",
  }
  notify {"notif from JMQ":}

  class { 'ntp':
    servers => ['nist-time-server.eoni.com','nist1-lv.ustiming.org','ntp-nist.ldsbc.edu'],
  }

  package {'git':
    ensure => installed;
  }

  group { 'git':
    gid => 1111,
  }

  user {'git':
    uid => 1111,
    gid => 1111,
    comment => 'Git User',
    home => '/home/git',
    require => Group['git'],
  }

  file {'/home/git':
    ensure => 'directory',
    owner => 1111,
    group => 1111,
    require => User['git'],
  }

  file {'/home/git/repos':
    ensure => 'directory',
    owner => 1111,
    group => 1111,
    require => File['/home/git'],
  }

}


node 'no62' {

  file {'/tmp/it_works.txt':
    ensure  => present,
    mode    => '0644',
    content => "It works !\n",
  }
  notify {"notif from JMQ":}

  class { 'ntp':
    servers => ['nist-time-server.eoni.com','nist1-lv.ustiming.org','ntp-nist.ldsbc.edu'],
  }

  $nameservers = ['10.0.2.3']

#  BREAKS DNS 
#    file { '/etc/resolv.conf':
#      ensure  => file,
#      owner   => 'root',
#      group   => 'root',
#      mode    => '0644',
#      content => template('resolver/resolv.conf.erb'),
#    }

  resources { 'firewall':
    purge => true,
  }

  Firewall {
    before  => Class['my_fw::post'],
    require => Class['my_fw::pre'],
  }

  class { ['my_fw::pre', 'my_fw::post']: }

  class { 'firewall': }

}

node 'no64' {

  include roles::webserver

}

