class profiles::base {
  class { 'ntp':
    servers => ['nist-time-server.eoni.com','nist1-lv.ustiming.org','ntp-nist.ldsbc.edu']
  }

mysql::db { 'mydb':
  user     => 'jmq',
  password => 'jmq15',
  host     => 'localhost',
  grant    => ['SELECT', 'UPDATE'],
}

}
