# Class: roundcube::params
#
# Default parameters for the roundcube class.
#
class roundcube::params {
  $version = '0.9.5'
  $md5 = '757f6ab3306d4abf8da6664ae65138d7'
  $process = $::operatingsystem ? {
    default => 'www-data',
  }

  $package_dir = $::operatingsystem ? {
    default => '/var/cache/puppet/archives',
  }
  $install_dir = $::operatingsystem ? {
    default => '/opt',
  }

  # default configuration values
  $db_type = 'postgresql'
  $db_name = 'roundcubemail'
  $db_host = 'localhost'
  $db_user = 'roundcube'
  $db_password = 'pass'

  $imap_host = ''
  $imap_port = 143
  $des_key = 'rcmail-!24ByteDESkey*Str'
  $plugins = []
  $mime_param_folding = 1
  $language = ''
  $support_url = ''
}
