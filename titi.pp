node 'git' {




  file {'/tmp/it_works.txt':
    ensure  => present,
    mode    => '0644',
    content => "It works !\n",
#  }

 }
