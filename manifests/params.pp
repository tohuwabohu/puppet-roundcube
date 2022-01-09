# == Class: roundcube::params
#
# Default configuration values for the `roundcube` class.
#
# === Copyright
#
# Copyright 2016 Martin Meinhold, unless otherwise noted.
#
class roundcube::params {
  $version = '1.5.2'
  $checksum = 'f03968381156fe790d858af7e069c5550a8577fb964f96624434895272053838'  # complete edition
  $checksum_type = 'sha256'

  # deprecated: 'camptocamp' will be replaced with 'puppet' in the next major release
  $archive_provider = 'camptocamp'
  $package_dir = '/var/cache/puppet/archives'
  $install_dir = '/opt'

  $document_root_manage = true
  $document_root = '/var/www/roundcubemail'
  $process = 'www-data'

  $exec_paths = ['/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin', '/bin']
  $composer_command_name = 'composer'
  $composer_disable_git_ssl_verify = false
  $composer_manage = true

  $plugins_manage = true
  $cronjobs_manage = true
}
