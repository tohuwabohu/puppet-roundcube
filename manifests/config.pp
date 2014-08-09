# Class: roundcube::config
#
# Manage the Roundcube configuration files.
#
# === Authors
#
# Martin Meinhold <martin.meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2013 Martin Meinhold, unless otherwise noted.
#
class roundcube::config inherits roundcube {

  $application_dir = $roundcube::install::target

  file { "${application_dir}/config/db.inc.php":
    content => template('roundcube/db.inc.php.erb'),
    owner   => $roundcube::process,
    group   => $roundcube::process,
    mode    => '0440',
  }

  file { "${application_dir}/config/main.inc.php":
    content => template('roundcube/main.inc.php.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { "${application_dir}/plugins/password/config.inc.php":
    content => template('roundcube/plugins/password/config.inc.php.erb'),
    owner   => $roundcube::process,
    group   => $roundcube::process,
    mode    => '0440',
  }
}
