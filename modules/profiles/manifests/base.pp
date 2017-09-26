class profiles::base {
  class { 'ntp':
    servers => ['nist-time-server.eoni.com','nist1-lv.ustiming.org','ntp-nist.ldsbc.edu']
  }

class { '::mysql::server':
  root_password           => 'root',
  remove_default_accounts => true,
  override_options => {
    mysqld => {
      log-error => '/var/log/mysqld.log',
      pid-file  => '/var/run/mysqld/mysqld.pid',
    },
  }
}


}
