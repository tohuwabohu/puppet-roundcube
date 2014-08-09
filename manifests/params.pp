# Class: roundcube::params
#
# Default parameters for the roundcube class.
#
# === Authors
#
# Martin Meinhold <martin.meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2013 Martin Meinhold, unless otherwise noted.
#
class roundcube::params {
  $version = '0.9.5'
  $md5 = '757f6ab3306d4abf8da6664ae65138d7'
  $process = $::osfamily ? {
    default => 'www-data',
  }

  $package_dir = $::osfamily ? {
    default => '/var/cache/puppet/archives',
  }
  $install_dir = $::osfamily ? {
    default => '/opt',
  }
  $document_root = $::osfamily ? {
    default => '/var/www/roundcubemail',
  }

  # default configuration values
  $db_type = 'postgresql'
  $db_name = 'roundcubemail'
  $db_host = 'localhost'
  $db_username = 'roundcube'
  $db_password = 'pass'

  $imap_host = ''
  $imap_port = 143
  $des_key = 'rcmail-!24ByteDESkey*Str'
  $plugins = []
  $mime_param_folding = 1
  $language = ''
  $support_url = ''

  $password_minimum_length = 0
  $password_require_nonalpha = false
  $password_db_dsn = ''
  $password_query = 'SELECT update_passwd(%c, %u)'
}
