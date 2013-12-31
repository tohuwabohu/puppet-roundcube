# Class: roundcube::params
#
# Default parameters for the roundcube class.
#
class roundcube::params {
  $version = '0.8.5'
  $md5 = '10bbe9bbf5e4ff50109d200c0484728b'
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
  $mime_param_folding = 0
  $support_url = ''
}
