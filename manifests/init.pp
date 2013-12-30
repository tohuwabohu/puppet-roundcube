# == Class: roundcube
#
# Install and manage the Roundcube webmail application.
#
# === Parameters
#
# [*version*]
#   Set the version of the web application to be installed.
#
# [*md5*]
#   Set the MD5 hash sum of the web application's archive file.
#
# [*package_dir*]
#   Set the directory where to keep the downloaded software packages.
#
# [*install_dir*]
#   Set the directory where to install the web application.
#
# === Authors
#
# Martin Meinhold <martin.meinhold@gmx.de>
#
# === Copyright
#
# Copyright 2013 Martin Meinhold, unless otherwise noted.
#
class roundcube (
  $version = params_lookup('version'),
  $md5 = params_lookup('md5'),

  $package_dir = params_lookup('package_dir'),
  $install_dir = params_lookup('install_dir')
) inherits roundcube::params {
  validate_string($version)
  validate_string($md5)
  validate_absolute_path($package_dir)
  validate_absolute_path($install_dir)

  class { 'roundcube::package':
    version     => $version,
    md5         => $md5,
    package_dir => $package_dir,
    install_dir => $install_dir,
  }
}
