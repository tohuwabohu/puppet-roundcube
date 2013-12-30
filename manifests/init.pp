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
# [*db_type*]
#   Set the type database (e.g. mysql or postgres).
#
# [*db_name*]
#   Set the name of the database.
#
# [*db_host*]
#   Set the hostname where the database is running. Puppet can only manage databases on the local host.
#
# [*db_user*]
#   Set the username used to connect to the database.
#
# [*db_password*]
#   Set the password used to authenticate the db_user.
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
  $install_dir = params_lookup('install_dir'),

  $db_type = params_lookup('db_type'),
  $db_name = params_lookup('db_name'),
  $db_host = params_lookup('db_host'),
  $db_user = params_lookup('db_user'),
  $db_password = params_lookup('db_password')
) inherits roundcube::params {
  validate_string($version)
  validate_string($md5)
  validate_absolute_path($package_dir)
  validate_absolute_path($install_dir)
  validate_string($db_type)
  validate_string($db_name)
  validate_string($db_host)
  validate_string($db_user)
  validate_string($db_password)

  class { 'roundcube::package':
    version     => $version,
    md5         => $md5,
    package_dir => $package_dir,
    install_dir => $install_dir,
  }

  class { 'roundcube::database':
    db_type     => $db_type,
    db_name     => $db_name,
    db_host     => $db_host,
    db_user     => $db_user,
    db_password => $db_password,
  }
}
