# == Class: roundcube::params
#
# Default configuration values for the `roundcube` class.
#
# === Copyright
#
# Copyright 2016 Martin Meinhold, unless otherwise noted.
#
class roundcube::params {
  $version = '1.6.0'
  $checksum = '2409ccdfe2e465f086cb9fc18c88dfe0aaf6ccc23924564975061209921694ba'  # complete edition
  $checksum_type = 'sha256'

  # deprecated: 'camptocamp' will be replaced with 'puppet' in the next major release
  $archive_provider = 'camptocamp'
  $package_dir = '/var/cache/puppet/archives'
  $install_dir = '/opt'
  $archive_cleanup = false

  $document_root_manage = true
  $document_root = '/var/www/roundcubemail'
  $process = 'www-data'

  $exec_paths = ['/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin', '/bin']
  $composer_command_name = 'composer'
  $composer_user = 'root'
  $composer_disable_git_ssl_verify = false

  $plugins_manage = true
  $cronjobs_manage = true
}
