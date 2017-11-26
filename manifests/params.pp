# == Class: roundcube::params
#
# Default configuration values for the `roundcube` class.
#
# === Copyright
#
# Copyright 2016 Martin Meinhold, unless otherwise noted.
#
class roundcube::params {
  $version = '1.3.3'
  $checksum = '05d9856c966c0d93accabf724e7ff2fd493bba1a57c44247ed0a2aacd617c879'  # complete edition
  $checksum_type = 'sha256'

  $archive_provider = 'camptocamp'
  $package_dir = '/var/cache/puppet/archives'
  $install_dir = '/opt'

  $document_root_manage = true
  $document_root = '/var/www/roundcubemail'
  $process = 'www-data'

  $exec_paths = ['/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin', '/bin']
  $composer_command_name = 'composer'
  $composer_disable_git_ssl_verify = false
}
