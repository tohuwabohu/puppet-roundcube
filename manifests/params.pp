# == Class: roundcube::params
#
# Default configuration values for the `roundcube` class.
#
# === Copyright
#
# Copyright 2016 Martin Meinhold, unless otherwise noted.
#
class roundcube::params {
  $version = '1.1.4'
  $checksum = '9bfe88255d4ffc288f5776de1cead78352469b1766d5ebaebe6e28043affe181'
  $checksum_type = 'sha256'

  $package_dir = '/var/cache/puppet/archives'
  $install_dir = '/opt'

  $document_root_manage = true
  $document_root = '/var/www/roundcubemail'
  $process = 'www-data'

  $exec_paths = ['/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin', '/bin']
  $composer_command_name = 'composer'
  $composer_disable_git_ssl_verify = $::osfamily ? {
    'Debian' => true,
    default  => false,
  }
}
