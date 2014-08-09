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
class roundcube::config($application_dir, $process) {
  validate_absolute_path($application_dir)
  validate_string($process)

  file { "${application_dir}/config/db.inc.php":
    content => template('roundcube/db.inc.php.erb'),
    owner   => $process,
    group   => $process,
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
    owner   => $process,
    group   => $process,
    mode    => '0440',
  }
}
