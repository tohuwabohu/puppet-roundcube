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

  if empty($roundcube::db_dsn) {
    $password = uriescape($roundcube::db_password)
    $db_dsnw = "${db_type}://${db_username}:${password}@${db_host}/${db_name}"
  }
  else {
    $db_dsnw = $roundcube::db_dsn
  }

  $options_defaults = {
    'db_dsnw'      => $db_dsnw,
    'default_host' => $roundcube::imap_host,
    'default_port' => $roundcube::imap_port,
    'des_key'      => $roundcube::des_key,
    'plugins'      => $roundcube::plugins,
  }

  $options = merge($options_defaults, $roundcube::options_hash)

  file { "${application_dir}/config/config.inc.php":
    content => template('roundcube/config.inc.php.erb'),
    owner   => $roundcube::process,
    group   => $roundcube::process,
    mode    => '0440',
  }

  file { '/etc/cron.daily/roundcube-cleandb':
    ensure => link,
    target => "${application_dir}/bin/cleandb.sh"
  }
}
