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
  $options_defaults = {
    'default_host' => $roundcube::imap_host,
    'default_port' => $roundcube::imap_port,
    'des_key'      => $roundcube::des_key,
  }

  $options = merge($options_defaults, $roundcube::options_hash)

  file { "${application_dir}/config/config.inc.php":
    content => template('roundcube/config.inc.php.erb'),
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

  file { '/etc/cron.daily/roundcube-cleandb':
    ensure => link,
    target => "${application_dir}/bin/cleandb.sh"
  }
}
