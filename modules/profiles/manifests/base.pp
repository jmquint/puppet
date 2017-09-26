class profiles::base {
  class { 'ntp':
    servers => ['nist-time-server.eoni.com','nist1-lv.ustiming.org','ntp-nist.ldsbc.edu']
  }

  class { '::mysql::server':
    authentication_string    => 'strongpassword',
    override_options => { 'mysqld' => { 'max_connections' => '1024' } }
  }

}
