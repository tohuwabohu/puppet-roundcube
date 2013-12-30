# Class: roundcube::config
#
# Manage the Roundcube configuration files.
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
}
